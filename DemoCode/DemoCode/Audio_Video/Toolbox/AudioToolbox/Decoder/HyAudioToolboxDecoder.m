//
//  HyAudioToolboxDecoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioToolboxDecoder.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HyAudioConfigure.h"

#define AudioToolboxDecoderQueue dispatch_queue_create("AAC Decoder Queue", DISPATCH_QUEUE_SERIAL)

typedef struct {
    AudioBufferList *aacBufferlist;
    AudioStreamPacketDescription *packetDesc;
} ConverterInUserData;


@interface HyAudioToolboxDecoder ()
@property (nonatomic) AudioConverterRef audioConverter; // 音频转换器
@property (nonatomic,assign) BOOL isEndCodec;
@end


@implementation HyAudioToolboxDecoder


- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {
    
    
//    OSStatus status = AudioFileOpenURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], kAudioFileReadPermission, 0, &_audioFileID);
//    if (status != noErr){
//        NSLog(@"*** Error *** filePath:%@--code:%d", filePath,(int)status);
//        return ;
//    }
//    
//    //取得音频数据格式
//    UInt32 size = sizeof(dataFormat);
//    AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataFormat, &size, &dataFormat);
//
//    //读取 最大Packet大小
//    size = sizeof(maxPacketSize);
//    AudioFileGetProperty(_audioFileID, kAudioFilePropertyPacketSizeUpperBound, &size, &maxPacketSize);
//    
//    
//    if(dataFormat.mFramesPerPacket != 0){
//        
//        Float64 numPacketsPersecond = dataFormat.mSampleRate / dataFormat.mFramesPerPacket;
//        outBufferSize = numPacketsPersecond *maxPacketSize;
//        
//    }else{
//        
//        outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
//        
//    }
//    if (outBufferSize > maxBufferSize && outBufferSize > maxPacketSize) {
//        outBufferSize = maxBufferSize;
//    } else {
//        if (outBufferSize < minBufferSize){
//            outBufferSize = minBufferSize;
//        }
//    }
//    numPacketsToRead = outBufferSize / maxPacketSize;
//    packetDescs = (AudioStreamPacketDescription*)malloc(numPacketsToRead *sizeof(AudioStreamPacketDescription));
//    
// 
//    UInt32 ioNumBytes = outBufferSize;
//    UInt32 ioNumPackets = numPacketsToRead;
//    
//    void *  convertBuffer;
//    
//    UInt32 pcmBufferSize = (UInt32)(1024 * 2 * self.audioConfigure.channelCount);
//    uint8_t *pcmBuffer = malloc(pcmBufferSize);
//    memset(pcmBuffer, 0, pcmBufferSize);
//    
//    status =
//    AudioFileReadPacketData(_audioFileID,
//                            NO,
//                            &ioNumBytes, //想要读的io字节数量
//                            packetDescs, //每个包的描述信息数组
//                            packetIndex, //第一个包的开始位置索引
//                            &ioNumPackets, //想要读的包的数量
//                            pcmBuffer); //输出地址
}

//解码器回调函数
static OSStatus pcmConverte(AudioConverterRef inAudioConverter,
                            UInt32 *ioNumberDataPackets,
                            AudioBufferList *ioData,
                            AudioStreamPacketDescription **outDataPacketDescription,
                            void *inUserData) {
    
    ConverterInUserData *converterData = (ConverterInUserData *)(inUserData);
    if (converterData->aacBufferlist->mBuffers[0].mDataByteSize <= 0) {
        return -1;
    }

     *outDataPacketDescription = converterData->packetDesc;
     (*outDataPacketDescription)[0].mStartOffset = 0;
     (*outDataPacketDescription)[0].mDataByteSize = converterData->aacBufferlist->mBuffers[0].mDataByteSize;
     (*outDataPacketDescription)[0].mVariableFramesInPacket = 1;
     
     ioData->mBuffers[0].mData           = converterData->aacBufferlist->mBuffers[0].mData;
     ioData->mBuffers[0].mDataByteSize   = converterData->aacBufferlist->mBuffers[0].mDataByteSize;
     ioData->mBuffers[0].mNumberChannels = converterData->aacBufferlist->mBuffers[0].mNumberChannels;
     ioData->mNumberBuffers              = converterData->aacBufferlist->mNumberBuffers;
             
     return noErr;
}


- (BOOL)decoderInitialization {
    
    if (_audioConverter) {
        return YES;
    }
    
    // 输入音频格式描述 AAC
    AudioStreamBasicDescription inputAduioDes = {0};
     memset(&inputAduioDes, 0, sizeof(inputAduioDes));
//    inputAduioDes.mSampleRate = self.audioConfigure.sampleRate;
//    inputAduioDes.mFormatID = kAudioFormatMPEG4AAC;                // 输出格式
//    inputAduioDes.mFormatFlags = kMPEG4Object_AAC_LC;              // 如果设为0 代表无损编码
//    inputAduioDes.mBytesPerPacket = 0;                             //自己确定每个packet 大小
//    inputAduioDes.mFramesPerPacket = 1024;                         // 每一个packet帧数 AAC-1024；
//    inputAduioDes.mBytesPerFrame = 0;                              //每一帧大小
//    inputAduioDes.mChannelsPerFrame = self.audioConfigure.channelCount; //输出声道数
//    inputAduioDes.mBitsPerChannel = 0;                             //数据帧中每个通道的采样位数。
//    inputAduioDes.mReserved =  0;                                  //对其方式 0(8字节对齐)
    
   inputAduioDes.mSampleRate = self.audioConfigure.sampleRate;
   inputAduioDes.mFormatID = kAudioFormatMPEG4AAC;
   inputAduioDes.mFormatFlags = kMPEG4Object_AAC_LC;
   inputAduioDes.mFramesPerPacket = 1024;
   inputAduioDes.mChannelsPerFrame = self.audioConfigure.channelCount;
   UInt32 inDesSize = sizeof(inputAduioDes);
   AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &inDesSize, &inputAduioDes);
    

    
     // 输出音频格式描述 PCM
    AudioStreamBasicDescription outputAudioDes = {0};
     memset(&outputAudioDes, 0, sizeof(outputAudioDes));
    outputAudioDes.mSampleRate = self.audioConfigure.sampleRate;       //采样率
    outputAudioDes.mChannelsPerFrame = self.audioConfigure.channelCount; //输出声道数
    outputAudioDes.mFormatID = kAudioFormatLinearPCM;                //输出格式
    outputAudioDes.mFormatFlags = (kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked); //编码 12
    outputAudioDes.mChannelsPerFrame = 1;
    outputAudioDes.mFramesPerPacket = 1;                             // 每个packet的帧数。如果是未压缩的音频数据，值是1。动态码率格式，这个值是一个较大的固定数字，比如说AAC的1024。如果是动态大小帧数（比如Ogg格式）设置为0。
    outputAudioDes.mBitsPerChannel = 16;                             //数据帧中每个通道的采样位数。
    outputAudioDes.mBytesPerFrame = outputAudioDes.mBitsPerChannel / 8 *outputAudioDes.mChannelsPerFrame;                              //每一帧大小（采样位数 / 8 *声道数）
    outputAudioDes.mBytesPerPacket = outputAudioDes.mBytesPerFrame * outputAudioDes.mFramesPerPacket;                             //每个packet大小（帧大小 * 帧数）
    outputAudioDes.mReserved =  0;                                  //对其方式 0(8字节对齐)
    //填充输出相关信息
    UInt32 outDesSize = sizeof(outputAudioDes);
    AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &outDesSize, &outputAudioDes);
    
   
    // 获取解码器的描述信息
    AudioClassDescription *audioClassDesc = [self getAudioCalssDescriptionWithType:outputAudioDes.mFormatID
                                                                   fromManufacture:kAppleSoftwareAudioCodecManufacturer];
    /** 创建converter
     参数1：输入音频格式描述
     参数2：输出音频格式描述
     参数3：class desc的数量
     参数4：class desc
     参数5：创建的解码器
     */
    OSStatus status = AudioConverterNewSpecific(&inputAduioDes, &outputAudioDes, 1, audioClassDesc, &_audioConverter);
    if (status != noErr) {
        NSLog(@"Error！：硬解码AAC创建失败, status= %d", (int)status);
        return NO;
    }
    
    return YES;
}

- (void)codecWithAACData:(NSData *)data {
    
    dispatch_async(AudioToolboxDecoderQueue, ^{
        if (self.isEndCodec) {
             return;
         }
         
         if (data.length <= 0) {
             return;
         }
             
         Byte crcFlag;
        [data getBytes:&crcFlag range:NSMakeRange(1, 1)];

         // 分离 ADTS
        NSData *realyData = nil;
        NSData *adtsData = nil;
        if (crcFlag & 0x08) {   // 说明ADTS头部占用7个字节
            realyData = [data subdataWithRange:NSMakeRange(7, data.length-7)];
            adtsData = [data subdataWithRange:NSMakeRange(0,7)];
        } else {                // 说明ADTS头部占用9个字节
            realyData = [data subdataWithRange:NSMakeRange(9, data.length-9)];
            adtsData = [data subdataWithRange:NSMakeRange(0,9)];
        }
         
          // 读取 ADTS
         [self getADTSInfo:adtsData];
         
         if (!_audioConverter) {
            if (![self decoderInitialization]) {
                return;
            }
         }
         
         AudioBufferList aacBufferlist;
         aacBufferlist.mNumberBuffers = 1;
         aacBufferlist.mBuffers[0].mNumberChannels = self.audioConfigure.channelCount;
         aacBufferlist.mBuffers[0].mData = (void*)malloc(realyData.length);
         aacBufferlist.mBuffers[0].mDataByteSize = (UInt32)realyData.length;
         
         AudioStreamPacketDescription *packetDesc = malloc(sizeof((UInt32)realyData.length));
         packetDesc->mDataByteSize = (UInt32)realyData.length;
         packetDesc->mStartOffset = 0;
         packetDesc->mVariableFramesInPacket = 1;

         ConverterInUserData converterData = {0};
         converterData.aacBufferlist = &aacBufferlist;
         converterData.packetDesc = packetDesc;
        
         // 创建临时容器pcm
         UInt32 pcmBufferSize = (UInt32)(1024 * 2 * self.audioConfigure.channelCount);
         uint8_t *pcmBuffer = malloc(pcmBufferSize);
         memset(pcmBuffer, 0, pcmBufferSize);
        
         AudioBufferList pcmBufferlist;
         pcmBufferlist.mNumberBuffers = 1;
         pcmBufferlist.mBuffers[0].mNumberChannels = self.audioConfigure.channelCount;
         pcmBufferlist.mBuffers[0].mData = pcmBuffer;
         pcmBufferlist.mBuffers[0].mDataByteSize =  pcmBufferSize;
         
         // packet个数
         UInt32 pcmDataPacketSize = 1;

         //配置填充函数，获取输出数据
         OSStatus status = AudioConverterFillComplexBuffer(_audioConverter,
                                                           pcmConverte,
                                                           &converterData,
                                                           &pcmDataPacketSize,
                                                           &pcmBufferlist,
                                                           NULL);
         if (status != noErr) {
             NSLog(@"Error: AAC Decoder error, status=%d",(int)status);
             return;
         }
         
         //如果获取到数据
         if (pcmBufferlist.mBuffers[0].mDataByteSize > 0) {
             if (self.file) {
                 fwrite(pcmBufferlist.mBuffers[0].mData, 1, pcmBufferlist.mBuffers[0].mDataByteSize, self.file);
             }
             NSData *pcmData = [NSData dataWithBytes:pcmBufferlist.mBuffers[0].mData
                                              length:pcmBufferlist.mBuffers[0].mDataByteSize];
             !self.audioConfigure.codecBlock ?: self.audioConfigure.codecBlock(pcmData);
         }
         
         free(pcmBuffer);
    });
}

- (void)endCodec {

    [super endCodec];
    
    self.isEndCodec = YES;
    
    if (_audioConverter) {
        AudioConverterDispose(_audioConverter);
        _audioConverter = NULL;
    }
}


/**
 获取解码器类型描述
 参数1：类型
 */
- (AudioClassDescription *)getAudioCalssDescriptionWithType: (AudioFormatID)type fromManufacture: (uint32_t)manufacture {
    
    static AudioClassDescription desc;
    UInt32 decoderSpecific = type;
    //获取满足AAC解码器的总大小
    UInt32 size;
    /**
     参数1：编码器类型（解码）
     参数2：类型描述大小
     参数3：类型描述
     参数4：大小
     */
    OSStatus status = AudioFormatGetPropertyInfo(kAudioFormatProperty_Decoders, sizeof(decoderSpecific), &decoderSpecific, &size);
    if (status != noErr) {
        NSLog(@"Error！：硬解码AAC get info 失败, status= %d", (int)status);
        return nil;
    }
    //计算aac解码器的个数
    unsigned int count = size / sizeof(AudioClassDescription);
    //创建一个包含count个解码器的数组
    AudioClassDescription description[count];
    //将满足aac解码的解码器的信息写入数组
    status = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(decoderSpecific), &decoderSpecific, &size, &description);
    if (status != noErr) {
        NSLog(@"Error！：硬解码AAC get propery 失败, status= %d", (int)status);
        return nil;
    }
    for (unsigned int i = 0; i < count; i++) {
        if (type == description[i].mSubType && manufacture == description[i].mManufacturer) {
            desc = description[i];
            return &desc;
        }
    }
    return nil;
}


// 解析ADTS 头部的采样率，声道数等信息
- (void)getADTSInfo:(NSData *)adtsData {
    
    const unsigned char buff[10];
    [adtsData getBytes:(void*)buff length:adtsData.length];
    
    unsigned long long adts = 0;
    const unsigned char *p = buff;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++; adts <<= 8;
    adts |= *p ++;
    
    // 获取声道数
    UInt32 channels = (adts >> 30) & 0x07;
    // 获取采样率
    UInt32 samplerate = (adts >> 34) & 0x0f;
    
    //3： 48000 Hz、4：44.1KHz、8: 16000 Hz、11: 8000 Hz  // 采样率 44.1KHz
    self.audioConfigure.sampleRate = 44100;
    switch (samplerate) {
        case 3:{
            self.audioConfigure.sampleRate = 48000;
        }break;
        case 4:{
            self.audioConfigure.sampleRate = 44100;
        }break;
        case 8:{
           self.audioConfigure.sampleRate = 16000;
        }break;
        case 11:{
            self.audioConfigure.sampleRate = 8000;
        }break;
        default:
        break;
    }
    self.audioConfigure.channelCount = channels;
}

@end
