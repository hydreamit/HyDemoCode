//
//  HyVideoToolboxEncoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoToolboxEncoder.h"
#import <VideoToolbox/VideoToolbox.h>

#define VideoToolboxEncoderQueue dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface HyVideoToolboxEncoder ()
// sps
@property (nonatomic,strong) NSData *sps;
// pps
@property (nonatomic,strong) NSDate *pps;
// 当前帧数
@property (nonatomic, assign) NSInteger frameIndex;
// 编码会话
@property (nonatomic,assign) VTCompressionSessionRef compressionSession;
@end


@implementation HyVideoToolboxEncoder


- (BOOL)encoderInitializationWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    if (_compressionSession) {
        return YES;
    }
    
    self.frameIndex = 0;
    
    int width = self.videoConfigure.width;
    int height = self.videoConfigure.height;
    if (width == 0 || height == 0) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        width = (int)CVPixelBufferGetWidth(imageBuffer);
        height = (int)CVPixelBufferGetHeight(imageBuffer);
    }

    // 创建CompressionSession对象
   OSStatus status = VTCompressionSessionCreate(NULL,
                                                width,
                                                height,
                                                kCMVideoCodecType_H264,
                                                NULL,
                                                NULL,
                                                NULL,
                                                compressH264,
                                                (__bridge void *)(self),
                                                &_compressionSession);
    
    if (status != 0) {
        NSLog(@"H264 编码会话创建失败");
        return NO;
    }
    
    // 配置编码参数
    
    // 设置实时编码输出
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    
    // 设置帧率(每秒多少帧,如果帧率过低,会造成画面卡顿)
    int fps = self.videoConfigure.frameRate;
    CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    
     // 设置码率，均值
    int bitRate = width * height * 12 * 8;
//    int bitRate = self.videoConfigure.bitrate;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
    
   //设置码率，上下线
    NSArray *limit = @[@(bitRate * 1.5/8), @(1)];
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_DataRateLimits, (__bridge CFArrayRef)limit);
    
    // 设置关键帧间隔, 间隔越小越清晰（GOPsize)
    int frameInterval = self.videoConfigure.gop_size;
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    
    //准备进行编码
    VTCompressionSessionPrepareToEncodeFrames(self.compressionSession);
    
    return YES;
}

- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    if (!self.compressionSession) {
        if (![self encoderInitializationWithSampleBuffer:sampleBuffer]) {
            return;
        }
    }
    
    CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CMTime presentationTimeStamp = CMTimeMake(self.frameIndex++, 1000);
    VTEncodeInfoFlags flags;
    
    OSStatus statusCode = VTCompressionSessionEncodeFrame(self.compressionSession,
                                                          imageBuffer,
                                                          presentationTimeStamp,
                                                          kCMTimeInvalid,
                                                          NULL,
                                                          NULL,
                                                          &flags);
    if (statusCode != noErr) {
        NSLog(@"H264: VTCompressionSessionEncodeFrame failed with %d", (int)statusCode);
        if (self.compressionSession) {
            VTCompressionSessionInvalidate(self.compressionSession);
            CFRelease(self.compressionSession);
            self.compressionSession = NULL;
        }
        return;
    }
    
    NSLog(@"编码第%ld帧", (long)self.frameIndex);
}

- (void)endCodec {
    [super endCodec];
}

- (void)endEncode {
    if (self.compressionSession) {
        VTCompressionSessionCompleteFrames(self.compressionSession, kCMTimeInvalid);
        VTCompressionSessionInvalidate(self.compressionSession);
        CFRelease(self.compressionSession);
        self.compressionSession = NULL;
    }
}

- (void)callbackH264DataBytes:(void*)dataBytes size:(size_t)size type:(H624DataType)type {
    
    if (self.videoConfigure.encodeBlock) {
        // startCode 隔开
        const char bytes[] = "\x00\x00\x00\x01";
        size_t length = (sizeof bytes) - 1;
        NSData *ByteHeader = [NSData dataWithBytes:bytes length:length];
        
        NSData *data = [[NSData alloc] initWithBytes:dataBytes length:size];
        
        NSMutableData *h264Data = [[NSMutableData alloc] init];
        [h264Data appendData:ByteHeader];
        [h264Data appendData:data];
        
        self.videoConfigure.encodeBlock(h264Data, type);
    }
}

- (void)writeH264DataBytes:(void*)dataBytes size:(size_t)size {
    
    // startCode 隔开
    const Byte bytes[] = "\x00\x00\x00\x01";
    if (self.file) {
        fwrite(bytes, 1, 4, self.file);
        fwrite(dataBytes, 1, size, self.file);
    }
}

- (void)dealloc {
    [self endEncode];
}

// H264编码回调方法
void compressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer) {
    
    // 判断状态
    if (status != noErr) {
        return;
    }
    
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        return;
    }
    
    // 根据传入的参数获取对象
    HyVideoToolboxEncoder *encoder = (__bridge HyVideoToolboxEncoder*)outputCallbackRefCon;
    
    // 判断是否是关键帧(I帧)
    bool isKeyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    // 判断当前帧是否为关键帧
    // 获取sps & pps数据
    if (isKeyframe)
    {
        // 获取编码后的信息（存储于CMFormatDescriptionRef中）
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        
        // 获取SPS信息
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                           0,
                                                           &sparameterSet,
                                                           &sparameterSetSize,
                                                           &sparameterSetCount,
                                                           0);
        
        // 获取PPS信息
        size_t pparameterSetSize, pparameterSetCount;
        const uint8_t *pparameterSet;
        CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format,
                                                           1,
                                                           &pparameterSet,
                                                           &pparameterSetSize,
                                                           &pparameterSetCount,
                                                           0);
        
        [encoder callbackH264DataBytes:(void *)sparameterSet size:sparameterSetSize type:H624DataTypeNaluSps];
        [encoder callbackH264DataBytes:(void *)pparameterSet size:pparameterSetSize type:H624DataTypeNaluPps];
        
        [encoder writeH264DataBytes:(void *)sparameterSet size:sparameterSetSize];
        [encoder writeH264DataBytes:(void *)pparameterSet size:pparameterSetSize];
    }
    
    // 获取数据块
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    
    // 获取数据指针和NALU的帧总长度，前四个字节里面保存的
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    
    if (statusCodeRet == noErr) {
        
        size_t bufferOffset = 0;
        // 返回的NALU数据前四个字节不是0001的startcode，而是大端模式的帧长度length
        static const int AVCCHeaderLength = 4;
        
        // 循环获取NALU数据
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            
            // 读取NALU长度的数据
            uint32_t NALUnitLength = 0;
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            // 从大端转系统端
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            
            [encoder callbackH264DataBytes:(void *)(dataPointer + bufferOffset + AVCCHeaderLength)
                                      size:NALUnitLength
                                      type:isKeyframe ? H624DataTypeNaluIFrame : H624DataTypeNaluPBFrame];
            
            [encoder writeH264DataBytes:(void *)(dataPointer + bufferOffset + AVCCHeaderLength) size:NALUnitLength];
            
            // 移动到下一个NALU单元
            bufferOffset += AVCCHeaderLength + NALUnitLength;
        }
    }
}

@end
