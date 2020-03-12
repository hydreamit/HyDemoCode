//
//  HyAudioToolboxEncoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioToolboxEncoder.h"
#import <AudioToolbox/AudioToolbox.h>


#define AudioToolboxEncoderQueue dispatch_queue_create("AAC Encoder Queue", DISPATCH_QUEUE_SERIAL)

@interface HyAudioToolboxEncoder ()
@property (nonatomic,assign) BOOL isEndCodec;
@property (nonatomic,assign) char *pcmBuffer; // PCM缓存区
@property (nonatomic,assign) size_t pcmBufferSize; // PCM缓存区大小
@property (nonatomic, unsafe_unretained) AudioConverterRef audioConverter; // 音频转换器
@end


@implementation HyAudioToolboxEncoder

// aac编码 回调函数
static OSStatus aacConverte(AudioConverterRef inAudioConverter,
                            UInt32 *ioNumberDataPackets,
                            AudioBufferList *ioData,
                            AudioStreamPacketDescription **outDataPacketDescription,
                            void *inUserData) {
    
    HyAudioToolboxEncoder *encoder = (__bridge HyAudioToolboxEncoder *)(inUserData);
    if (!encoder.pcmBufferSize) {
        *ioNumberDataPackets = 0;
        return  - 1;
    }
    
    //填充
    ioData->mBuffers[0].mData = encoder.pcmBuffer;
    ioData->mBuffers[0].mDataByteSize = (uint32_t)encoder.pcmBufferSize;
    ioData->mBuffers[0].mNumberChannels = (uint32_t)encoder.audioConfigure.channelCount;
    
    //填充完毕,则清空数据
    encoder.pcmBuffer = NULL;
    encoder.pcmBufferSize = 0;
    *ioNumberDataPackets = 1;
    
    return noErr;
}

- (BOOL)encoderInitializationWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    if (_audioConverter) {
        return YES;
    }

    CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
    const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    Float64 sampleRate = asbd->mSampleRate;
    int audioChannels = asbd->mChannelsPerFrame;
    
    if (self.audioConfigure.sampleRate == 0) {
        self.audioConfigure.sampleRate = sampleRate;
    }
    if (self.audioConfigure.channelCount == 0) {
        self.audioConfigure.channelCount = audioChannels;
    }
    
    // 输入音频格式描述
    AudioStreamBasicDescription inputAduioDes =
    *CMAudioFormatDescriptionGetStreamBasicDescription(CMSampleBufferGetFormatDescription(sampleBuffer));
    
    // 输出音频格式描述
    AudioStreamBasicDescription outputAudioDes = {0};
    // 音频流，在正常播放情况下的帧率。如果是压缩的格式，这个属性表示解压缩后的帧率。帧率不能为0。
    outputAudioDes.mSampleRate = self.audioConfigure.sampleRate;
    outputAudioDes.mFormatID = kAudioFormatMPEG4AAC;                // 输出格式
    outputAudioDes.mFormatFlags = kMPEG4Object_AAC_LC;              // 如果设为0 代表无损编码
    // 每一个packet的音频数据大小。如果的动态大小，设置为0。动态大小的格式，需要用AudioStreamPacketDescription 来确定每个packet的大小。
    outputAudioDes.mBytesPerPacket = 0;                             //自己确定每个packet 大小
    // 每个packet的帧数。如果是未压缩的音频数据，值是1。动态码率格式，这个值是一个较大的固定数字，比如说AAC的1024。如果是动态大小帧数（比如Ogg格式）设置为0。
    outputAudioDes.mFramesPerPacket = 1024;                         //每一个packet帧数 AAC-1024；
    outputAudioDes.mBytesPerFrame = 0;                              //每一帧大小
    outputAudioDes.mChannelsPerFrame = self.audioConfigure.channelCount; //输出声道数
    outputAudioDes.mBitsPerChannel = 0;                             //数据帧中每个通道的采样位数。
    outputAudioDes.mReserved =  0;                                  //对其方式 0(8字节对齐)
    //填充输出相关信息
    UInt32 outDesSize = sizeof(outputAudioDes);
    AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &outDesSize, &outputAudioDes);
    
    
    // 获取编码器的描述信息(只能传入software)
    AudioClassDescription *audioClassDesc = [self getAudioCalssDescriptionWithType:outputAudioDes.mFormatID
                                                                   fromManufacture:kAppleSoftwareAudioCodecManufacturer];
    
    /** 创建音频转换器
     参数1：输入音频格式描述
     参数2：输出音频格式描述
     参数3：class desc的数量
     参数4：class desc
     参数5：创建的解码器
     */
    OSStatus status = AudioConverterNewSpecific(&inputAduioDes, &outputAudioDes, 1, audioClassDesc, &_audioConverter);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC创建失败, status= %d", (int)status);
        return NO;
    }
    
    
    // 设置编解码质量
    /*
     kAudioConverterQuality_Max                              = 0x7F,
     kAudioConverterQuality_High                             = 0x60,
     kAudioConverterQuality_Medium                           = 0x40,
     kAudioConverterQuality_Low                              = 0x20,
     kAudioConverterQuality_Min                              = 0
     */
    UInt32 temp = kAudioConverterQuality_High;
    //编解码器的呈现质量
    AudioConverterSetProperty(_audioConverter, kAudioConverterCodecQuality, sizeof(temp), &temp);
    
    //设置比特率
    uint32_t audioBitrate = self.audioConfigure.bitrate;
    uint32_t audioBitrateSize = sizeof(audioBitrate);
    status = AudioConverterSetProperty(_audioConverter, kAudioConverterEncodeBitRate, audioBitrateSize, &audioBitrate);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC 设置比特率失败");
    }
    
//    //获取最大输出 (用于填充数据时检查是否填满)
//    UInt32 audioMaxOutput = 0;
//    UInt32 audioMaxOutputSize = sizeof(audioMaxOutput);
//    self.audioMaxOutputFrameSize = audioMaxOutputSize;
//    status = AudioConverterGetProperty(_audioConverter, kAudioConverterPropertyMaximumOutputPacketSize, &audioMaxOutputSize, &audioBitrate);
//
//    if (audioMaxOutputSize == 0) {
//        NSLog(@"Error!: 硬编码AAC 获取最大frame size失败");
//    }
    
    return YES;
}

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {}
- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    if (self.isEndCodec) {
        return;
    }
    
    CFRetain(sampleBuffer);
    
     if (!_audioConverter) {
         if (![self encoderInitializationWithSampleBuffer:sampleBuffer]) {
             CFRelease(sampleBuffer);
             return;
         }
      }
             
      // 获取CMBlockBuffer, 这里面保存了PCM数据
      CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
      CFRetain(blockBuffer);
      
      // 获取BlockBuffer中音频数据大小以及音频数据地址
      OSStatus status = CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &_pcmBufferSize, &_pcmBuffer);
      
      NSError *error = nil;
      if (status != kCMBlockBufferNoErr) {
         error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
         NSLog(@"Error: ACC encode get data point error: %@",error);
         return;
      }
      
      // 创建临时容器aac
      //开辟_pcmBuffsize大小的pcm内存空间
      uint8_t *accBuffer = malloc(_pcmBufferSize);
      //将_pcmBufferSize数据set到pcmBuffer中.
      memset(accBuffer, 0, _pcmBufferSize);

      //3.输出buffer
      /*
      typedef struct AudioBufferList {
      UInt32 mNumberBuffers;
      AudioBuffer mBuffers[1];
      } AudioBufferList;

      struct AudioBuffer
      {
      UInt32              mNumberChannels;
      UInt32              mDataByteSize;
      void* __nullable    mData;
      };
      typedef struct AudioBuffer  AudioBuffer;
      */
      //将pcmBuffer数据填充到outAudioBufferList 对象中
      AudioBufferList outAudioBufferList = {0};
      outAudioBufferList.mNumberBuffers = 1;
      outAudioBufferList.mBuffers[0].mNumberChannels = self.audioConfigure.channelCount;
      outAudioBufferList.mBuffers[0].mDataByteSize = (UInt32)_pcmBufferSize;
      outAudioBufferList.mBuffers[0].mData = accBuffer;

      //输出包大小为1
      UInt32 outputDataPacketSize = 1;

      //配置填充函数，获取输出数据
      //转换由输入回调函数提供的数据
      /*
      参数1: inAudioConverter 音频转换器
      参数2: inInputDataProc 回调函数.提供要转换的音频数据的回调函数。当转换器准备好接受新的输入数据时，会重复调用此回调.
      参数4: inInputDataProcUserData,self
      参数5: ioOutputDataPacketSize,输出缓冲区的大小
      参数6: outOutputData,需要转换的音频数据
      参数7: outPacketDescription,输出包信息
      */
      status = AudioConverterFillComplexBuffer(_audioConverter,
                                               aacConverte,
                                               (__bridge void * _Nullable)(self),
                                               &outputDataPacketSize,
                                               &outAudioBufferList,
                                               NULL);

      if (status == noErr) {
          
         //获取数据
         NSData *rawAAC = [NSData dataWithBytes:outAudioBufferList.mBuffers[0].mData
                                         length:outAudioBufferList.mBuffers[0].mDataByteSize];
        
          
         // 添加ADTS头，想要获取裸流时，请忽略添加ADTS头，写入文件时，必须添加
         NSData *adtsHeader = [self adtsDataForPacketLength:rawAAC.length channelCount:self.audioConfigure.channelCount];
         NSMutableData *fullData = [NSMutableData dataWithCapacity:adtsHeader.length + rawAAC.length];;
         [fullData appendData:adtsHeader];
         [fullData appendData:rawAAC];
        
          !self.audioConfigure.codecBlock ?: self.audioConfigure.codecBlock(fullData);
          if (self.file) {
              fwrite([fullData bytes], 1, fullData.length, self.file);
          }
          
          //释放accBuffer
          free(accBuffer);
   
      } else {
         error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
      }

      CFRelease(blockBuffer);
      CFRelease(sampleBuffer);
      if (error) {
         NSLog(@"error: AAC编码失败 %@",error);
      }
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
 *  Add ADTS header at the beginning of each and every AAC packet.
 *  This is needed as MediaCodec encoder generates a packet of raw
 *  AAC data.
 *
 *  AAC ADtS头
 *  Note the packetLen must count in the ADTS header itself.
 *  See: http://wiki.multimedia.cx/index.php?title=ADTS
 *  Also: http://wiki.multimedia.cx/index.php?title=MPEG-4_Audio#Channel_Configurations
 **/
- (NSData*)adtsDataForPacketLength:(NSUInteger)packetLength channelCount:(int)channelCount {
    
    int adtsLength = 7;
    char *packet = malloc(sizeof(char) * adtsLength);
    // Variables Recycled by addADTStoPacket
    
    int profile = 2;  //AAC LC 编码压缩级别
    int freqIdx = 4;  //3： 48000 Hz、4：44.1KHz、8: 16000 Hz、11: 8000 Hz  // 采样率 44.1KHz
    int chanCfg = channelCount;  //MPEG-4 Audio Channel Configuration. 1 Channel front-center // 声道数
    
    NSUInteger fullLength = adtsLength + packetLength;
    // fill in ADTS data
    packet[0] = (char)0xFF;    // 11111111      = syncword
    packet[1] = (char)0xF9;    // 1111 1 00 1  = syncword MPEG-2 Layer CRC
    packet[2] = (char)(((profile-1)<<6) + (freqIdx<<2) +(chanCfg>>2));
    packet[3] = (char)(((chanCfg&3)<<6) + (fullLength>>11));
    packet[4] = (char)((fullLength&0x7FF) >> 3);
    packet[5] = (char)(((fullLength&7)<<5) + 0x1F);
    packet[6] = (char)0xFC;
    NSData *data = [NSData dataWithBytesNoCopy:packet length:adtsLength freeWhenDone:YES];
    return data;
}
/**
 .AAC文件处理流程
 (1)　判断文件格式，确定为ADIF或ADTS
 (2)　若为ADIF，解ADIF头信息，跳至第6步。
 (3)　若为ADTS，寻找同步头。
 (4)  解ADTS帧头信息。
 (5)  若有错误检测，进行错误检测。
 (6)  解块信息。
 (7)  解元素信息。
 */


/**
 获取编码器类型描述
 参数1：类型
 */
- (AudioClassDescription *)getAudioCalssDescriptionWithType:(AudioFormatID)type
                                            fromManufacture: (uint32_t)manufacture {
    
    static AudioClassDescription desc;
    UInt32 encoderSpecific = type;
    
    //获取满足AAC编码器的总大小
    UInt32 size;
    
    /**
     参数1：编码器类型
     参数2：类型描述大小
     参数3：类型描述
     参数4：大小
     */
    OSStatus status = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecific), &encoderSpecific, &size);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC get info 失败, status= %d", (int)status);
        return nil;
    }
    //计算aac编码器的个数
    unsigned int count = size / sizeof(AudioClassDescription);
    //创建一个包含count个编码器的数组
    AudioClassDescription description[count];
    //将满足aac编码的编码器的信息写入数组
    status = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecific), &encoderSpecific, &size, &description);
    if (status != noErr) {
        NSLog(@"Error！：硬编码AAC get propery 失败, status= %d", (int)status);
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

@end
