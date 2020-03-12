//
//  HyFFmepgAudioDecoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/5.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyFFmepgAudioDecoder.h"
//核心库
#import "libavcodec/avcodec.h"
//封装格式处理库
#import "libavformat/avformat.h"
//工具库
#import "libavutil/imgutils.h"
//视频像素数据格式库
#import "libswscale/swscale.h"
//音频数据格式库
#import "libswresample/swresample.h"



@implementation HyFFmepgAudioDecoder 


- (void)codecWithAACData:(NSData *)data { }

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {
    
    av_register_all();

   AVFormatContext *avformat_context = avformat_alloc_context();
  
   const char *cinFilePath = [filePath UTF8String];
   if (avformat_open_input(&avformat_context, cinFilePath, NULL, NULL) != 0) {
       NSLog(@"打开文件失败");
       return;
   }
   
   // 查找音频流
   if (avformat_find_stream_info(avformat_context, NULL) < 0) {
       NSLog(@"查找失败");
       return;
   }
   
   //查找音频解码器
   
   //查找音频流索引位置
   int av_audio_stream_index = -1;
   for (int i = 0; i < avformat_context->nb_streams; ++i) {
       if (avformat_context->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO){
           av_audio_stream_index = i;
           break;
       }
   }
   //根据视频流索引，获取解码器上下文
   AVCodecContext *avcodec_context = avformat_context->streams[av_audio_stream_index]->codec;
   //根据音频解码器上下文，获得解码器ID，然后查找音频解码器
   AVCodec *avcodec = avcodec_find_decoder(avcodec_context->codec_id);
      
   // 打开音频解码器
   if (avcodec_open2(avcodec_context, avcodec, NULL) != 0) {
       NSLog(@"打开解码器失败");
       return;
   }
   
   
   // 解码前每一帧音频压缩数据
   AVPacket *avPacket = (AVPacket *) av_malloc(sizeof(AVPacket));
   
   // 解码后一帧音频采样数据
   AVFrame *avFrame = av_frame_alloc();
   
   // 统一转换为pcm格式
   SwrContext *swrContext = swr_alloc();
   int64_t in_ch_layout = av_get_default_channel_layout(avcodec_context->channels);
   swr_alloc_set_opts(swrContext,
                      AV_CH_LAYOUT_STEREO,
                      AV_SAMPLE_FMT_S16,
                      avcodec_context->sample_rate,
                      in_ch_layout,
                      avcodec_context->sample_fmt,
                      avcodec_context->sample_rate,
                      0,
                      NULL);
   
   // 初始化上下文
   swr_init(swrContext);
   
   // 统一输出音频采样数据格式->pcm
   int MAX_AUDIO_SIZE = 44100 * 2;
   uint8_t *out_buffer = (uint8_t *) av_malloc(MAX_AUDIO_SIZE);
   
   // 获取缓冲区实际大小
   int out_nb_channels = av_get_channel_layout_nb_channels(AV_CH_LAYOUT_STEREO);

   
   int current_index = 0;
   while (av_read_frame(avformat_context, avPacket) >= 0) {
       if (avPacket->stream_index == av_audio_stream_index) {
           
           // 发送一帧音频压缩数据->acc格式、mp3格式
           avcodec_send_packet(avcodec_context, avPacket);
           // 解码一帧音频采样数据->pcm格式
           int ret = avcodec_receive_frame(avcodec_context, avFrame);
           if (ret == 0) {
               
               // 统一转换为pcm格式
               swr_convert(swrContext,
                           &out_buffer,
                           MAX_AUDIO_SIZE,
                           (const uint8_t **) avFrame->data,
                           avFrame->nb_samples);
               
               //获取缓冲区实际大小
               //参数一：行大小
               //参数二：输出声道数量（单声道、双声道）
               //参数三：输入大小
               //参数四：输出音频采样数据格式
               //参数五：字节对齐方式->默认是1
               int buffer_size = av_samples_get_buffer_size(NULL,
                                                            out_nb_channels,
                                                            avFrame->nb_samples,
                                                            avcodec_context->sample_fmt,
                                                            1);
               
               // 回调
               if (self.audioConfigure.codecBlock) {
                   NSData *pcmData = [NSData dataWithBytes:out_buffer length:buffer_size];
                   self.audioConfigure.codecBlock(pcmData);
               }
            
               // 写入文件
               if (self.file) {
                   fwrite(out_buffer, 1, buffer_size, self.file);
               }
               current_index++;
               
               NSLog(@"当前解码到了第%d帧", current_index);
           }
       }
   }
       
    completion ?: completion(self.audioConfigure.outFilePath);
    
    // 释放资源（内存）
    av_packet_free(&avPacket);
    av_frame_free(&avFrame);
    free(out_buffer);
    avcodec_close(avcodec_context);
    avformat_free_context(avformat_context);
}



@end
