//
//  HyFFmepgVideoDecoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/5.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyFFmepgVideoDecoder.h"
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


@implementation HyFFmepgVideoDecoder

- (void)codecWithNaluData:(NSData *)data {}

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {
    
    av_register_all();
          
   AVFormatContext *formatContext = avformat_alloc_context();
   
   // 打开视频文件
   const char *url = [filePath UTF8String];
   int avformat_open_input_result = avformat_open_input(&formatContext, url, NULL, NULL);
   if (avformat_open_input_result != 0){
       NSLog(@"打开文件失败");
       return;
   }
   
   // 获取视频流信息
   int avformat_find_stream_info_result = avformat_find_stream_info(formatContext, NULL);
   if (avformat_find_stream_info_result < 0){
       NSLog(@"查找失败");
       return;
   }
   
   // 查找视频解码器
   
   // 查找视频流索引位置
   int av_stream_index = -1;
   for (int i = 0; i < formatContext->nb_streams; ++i) {
       if (formatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO){
           av_stream_index = i;
           break;
       }
   }
   // 根据视频流索引，获取解码器上下文
   AVCodecContext *avcodec_context = formatContext->streams[av_stream_index]->codec;
   // 根据解码器上下文，获得解码器ID，然后查找解码器
   AVCodec *avcodec = avcodec_find_decoder(avcodec_context->codec_id);
   
   
   // 打开解码器
   int avcodec_open2_result = avcodec_open2(avcodec_context, avcodec, NULL);
   if (avcodec_open2_result != 0){
       NSLog(@"打开解码器失败");
       return;
   }
   
   
   // 解码前 一帧数据缓存区
   AVPacket *packet = (AVPacket*)av_malloc(sizeof(AVPacket));
   
   // 解码后 一帧数据缓存区
   AVFrame *frame = av_frame_alloc();
   
   // 解码后一帧数据统一转换为 一帧YUV420P格式缓存区
   AVFrame *yuv420p_frame = av_frame_alloc();
   int buffer_size = av_image_get_buffer_size(AV_PIX_FMT_YUV420P,
                                              avcodec_context->width,
                                              avcodec_context->height,
                                              1);
   uint8_t *out_buffer = (uint8_t *)av_malloc(buffer_size);
   av_image_fill_arrays(yuv420p_frame->data,
                        yuv420p_frame->linesize,
                        out_buffer,
                        AV_PIX_FMT_YUV420P,
                        avcodec_context->width,
                        avcodec_context->height,
                        1);
   
   
   // YUV420P格式转换上下文
   struct SwsContext *swscontext = sws_getContext(avcodec_context->width,
                                             avcodec_context->height,
                                             avcodec_context->pix_fmt,
                                             avcodec_context->width,
                                             avcodec_context->height,
                                             AV_PIX_FMT_YUV420P,
                                             SWS_BICUBIC,
                                             NULL,
                                             NULL,
                                             NULL);
   
   
   int y_size, u_size, v_size;
   int current_index = 0;
   int decode_result = 0;
   
   while (av_read_frame(formatContext, packet) >= 0) {
       if (packet->stream_index == av_stream_index) {
           
           // 解码
           avcodec_send_packet(avcodec_context, packet);
           decode_result = avcodec_receive_frame(avcodec_context, frame);
           if (decode_result == 0) {
               
               // 转换成yuv420p格式
               sws_scale(swscontext,
                         (const uint8_t *const *)frame->data,
                         frame->linesize,
                         0,
                         avcodec_context->height,
                         yuv420p_frame->data,
                         yuv420p_frame->linesize);
               
               y_size = avcodec_context->width * avcodec_context->height;
               u_size = y_size / 4;
               v_size = y_size / 4;
               
               // 写入文件
               if (self.file) {
                   fwrite(yuv420p_frame->data[0], 1, y_size, self.file);
                   fwrite(yuv420p_frame->data[1], 1, u_size, self.file);
                   fwrite(yuv420p_frame->data[2], 1, v_size, self.file);
               }

//               if (self.videoConfigure.decodeBlock) {
//                   NSData *y_data = [[NSData alloc] initWithBytes:yuv420p_frame->data[0] length:y_size];
//                   NSData *u_data = [[NSData alloc] initWithBytes:yuv420p_frame->data[1] length:u_size];
//                   NSData *v_data = [[NSData alloc] initWithBytes:yuv420p_frame->data[2] length:v_size];
//
//                   NSMutableData *yuvData = [[NSMutableData alloc] init];
//                   [yuvData appendData:y_data];
//                   [yuvData appendData:u_data];
//                   [yuvData appendData:v_data];
//                   self.videoConfigure.decodeBlock(yuvData);
//               }
               
               current_index++;
               
               NSLog(@"当前解码第%d帧", current_index);
           }
       }
   }
   
   // 释放内存
   av_packet_free(&packet);
   av_frame_free(&frame);
   av_frame_free(&yuv420p_frame);
   free(out_buffer);
   avcodec_close(avcodec_context);
   avformat_free_context(formatContext);
    
    [self closeFile];
}


@end
