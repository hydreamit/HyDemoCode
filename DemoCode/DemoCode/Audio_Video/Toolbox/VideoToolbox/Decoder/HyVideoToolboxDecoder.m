//
//  HyVideoToolboxDecoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoToolboxDecoder.h"
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

#define VideoToolboxDecoderQueue dispatch_queue_create("H264 Decoder Queue", DISPATCH_QUEUE_SERIAL)


@interface HyVideoToolboxDecoder ()
// 解码  session
@property (nonatomic,assign) VTDecompressionSessionRef decompressionSession;
// 解码 format 封装了sps和pps
@property (nonatomic,assign) CMVideoFormatDescriptionRef formatDescription;
@end


@implementation HyVideoToolboxDecoder {
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
}

- (BOOL)decoderInitialization {
    
    if (_decompressionSession) {
        return YES;
    }
    
    //用sps 和pps 实例化formatDescription
    const uint8_t* const parameterSetPointers[2] = {_sps, _pps};
    const size_t parameterSetSizes[2] = {_spsSize, _ppsSize};
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                        2, //param count
                                                                        parameterSetPointers,
                                                                        parameterSetSizes,
                                                                        4, //nal start code size
                                                                        &_formatDescription);
      
      if(status == noErr) {
          NSDictionary *destinationPixelBufferAttributes = @{
                                                             (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange),
                                                             (id)kCVPixelBufferOpenGLCompatibilityKey : @(YES)
                                                             };
          VTDecompressionOutputCallbackRecord callBackRecord;
          callBackRecord.decompressionOutputCallback = decompressH264;
          callBackRecord.decompressionOutputRefCon = (__bridge void *)self;
          status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                                _formatDescription,
                                                NULL,
                                                (__bridge CFDictionaryRef)destinationPixelBufferAttributes,
                                                &callBackRecord,
                                                &_decompressionSession);
          VTSessionSetProperty(_decompressionSession, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)[NSNumber numberWithInt:1]);
          VTSessionSetProperty(_decompressionSession, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);
      } else {
          NSLog(@"IOS8VT: reset decoder session failed status=%d", (int)status);
      }
    
    return YES;
}

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion{}

- (void)codecWithNaluData:(NSData *)data {
    
    if (!data.length) {
        return;
    }
    
    uint32_t size = (uint32_t)data.length;
    uint8_t *frame = (uint8_t *)[data bytes];
    
    /*
      0x00 00 00 01四个字节为StartCode，在两个StartCode之间的内容即为一个完整的NALU。
     
      每个NALU的第一个字节包含了该NALU的类型信息，该字节的8个bit将其转为二进制数据后，解读顺序为从左往右算，如下:
     （1）第1位禁止位，值为1表示语法出错
     （2）第2~3位为参考级别
     （3）第4~8为是nal单元类型
     
        由此可知计算NALU类型时，只需将该字节的值与0x1F（二进制的0001 1111）相与，结果即为该NALU类型。
     */
    
    // 获取nalu type
    int nalu_type = (frame[4] & 0x1F);
    CVPixelBufferRef pixelBuffer = NULL;
    
    // 填充nalu size 去掉startcode 替换成nalu size
    uint32_t nalSize = (uint32_t)(size - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    frame[0] = *(pNalSize + 3);
    frame[1] = *(pNalSize + 2);
    frame[2] = *(pNalSize + 1);
    frame[3] = *(pNalSize);
    
    //传输的时候 关键帧不能丢数据 否则绿屏   B/P可以丢  这样会卡顿
    switch (nalu_type) {
            
        case 0x05: { // 关键帧
            if([self decoderInitialization]) {
                pixelBuffer = [self decode:frame withSize:size];
            }
        } break;
            
        case 0x07: { //  sps
            _spsSize = size - 4;
            _sps = malloc(_spsSize);
            memcpy(_sps, &frame[4], _spsSize);
        } break;
            
        case 0x08:{ //  pps
            _ppsSize = size - 4;
            _pps = malloc(_ppsSize);
            memcpy(_pps, &frame[4], _ppsSize);
        } break;
            
        default: { // B/P其他帧
            if([self decoderInitialization]){
                pixelBuffer = [self decode:frame withSize:size];
            }
        } break;
    }
}

- (CVPixelBufferRef)decode:(uint8_t *)frame withSize:(uint32_t)frameSize {
    
    CVPixelBufferRef outputPixelBuffer = NULL;
    CMBlockBufferRef blockBuffer = NULL;
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(NULL,
                                                          (void *)frame,
                                                          frameSize,
                                                          kCFAllocatorNull,
                                                          NULL,
                                                          0,
                                                          frameSize,
                                                          FALSE,
                                                          &blockBuffer);
    if(status == kCMBlockBufferNoErr) {
        CMSampleBufferRef sampleBuffer = NULL;
        const size_t sampleSizeArray[] = {frameSize};
        status = CMSampleBufferCreateReady(kCFAllocatorDefault,
                                           blockBuffer,
                                           _formatDescription ,
                                           1,
                                           0,
                                           NULL,
                                           1,
                                           sampleSizeArray,
                                           &sampleBuffer);
        if (status == kCMBlockBufferNoErr && sampleBuffer) {
            VTDecodeFrameFlags flags = 0;
            VTDecodeInfoFlags flagOut = 0;
            OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decompressionSession,
                                                                      sampleBuffer,
                                                                      flags,
                                                                      &outputPixelBuffer,
                                                                      &flagOut);
            
            if(decodeStatus == kVTInvalidSessionErr) {
                
                NSLog(@"decode failed Invalid session, reset decoder session");
                
            } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
                
                NSLog(@"ecode failed status=%d(Bad data)", (int)decodeStatus);
                
            } else if(decodeStatus != noErr) {
                
                NSLog(@"decode failed status=%d", (int)decodeStatus);
                
            }
            CFRelease(sampleBuffer);
        }
        CFRelease(blockBuffer);
    }
    return outputPixelBuffer;
}

static void decompressH264( void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration ){
    
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
    HyVideoToolboxDecoder *decoder = (__bridge HyVideoToolboxDecoder *)decompressionOutputRefCon;
        
    !decoder.videoConfigure.decodeBlock ?: decoder.videoConfigure.decodeBlock(pixelBuffer);
}

@end
