//
//  HyFFmepgVideoEncoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/4.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyFFmepgVideoEncoder.h"
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



@implementation HyFFmepgVideoEncoder {
    
    
    AVFormatContext                       *formatContext;   // 格式封装上下文
    AVOutputFormat                        *outputFormat;   //  视频输出格式
    AVStream                              *stream;        // 视频码流
    AVCodecContext                        *codecContext; // 编码器上下文
//    AVCodecParameters                   *codecParameters;
    AVCodec                               *codec; // 编码器
    uint8_t                               *image_buffer;
    AVFrame                               *frame;        // 视频编码前YUV缓存区
    AVPacket                              *packet;      // 视频编码后缓存区
    int                                   y_size;      // YUV y的大小
    int                                   frameCount; //当前帧数
}


- (BOOL)encoderInitialization {
    
    av_register_all();
    
    // 封装格式上下文
    formatContext = avformat_alloc_context();

    [self closeFile];
    const char *coutFilePath = [self.videoConfigure.outFilePath UTF8String];
    outputFormat = av_guess_format(NULL, coutFilePath, NULL);

    formatContext->oformat = outputFormat;

    // 打开文件的缓冲区
    if (avio_open(&formatContext->pb, coutFilePath, AVIO_FLAG_WRITE) < 0) {
        NSLog(@"打开输出文件失败");
        return NO;
    }

    // 视频码流 - 创建一块内存空间
    stream = avformat_new_stream(formatContext, NULL);
    stream->time_base.num = 1;
    stream->time_base.den = 25;
    
//    codecParameters = stream->codecpar;
//    codecParameters->codec_id = outputFormat->video_codec;
//    codecParameters->codec_type = AVMEDIA_TYPE_VIDEO;
//    codecParameters->format = AV_PIX_FMT_YUV420P;
//    codecParameters->sample_aspect_ratio.num = 1;
//    codecParameters->sample_aspect_ratio.den = 25;
//    codecParameters->width = configure.width;
//    codecParameters->height = configure.height;
//    codecParameters->bit_rate = configure.bitrate;

//  配置视频编码器参数
    codecContext = stream->codec;
    codecContext->codec_id = outputFormat->video_codec;
    codecContext->codec_type = AVMEDIA_TYPE_VIDEO;
    codecContext->pix_fmt = AV_PIX_FMT_YUV420P;
    
    codecContext->width = self.videoConfigure.width;
    codecContext->height = self.videoConfigure.height;
    // 帧率->表示每秒25帧
    codecContext->time_base.num = 1;
    codecContext->time_base.den = 25;
    // 码率 (kbps)=【视频大小 - 音频大小】(bit位) /【时间】(秒)
    // (视频大小（M） x 1024 x 1024 x 8) / 秒 （s）
    codecContext->bit_rate = self.videoConfigure.bitrate;
    // 视频质量度量标准, 量化系数越小，视频越是清晰
    codecContext->qmin = 10;
    codecContext->qmax = 51;
    // 两个I帧之间的间隔 I P B
    codecContext->gop_size = 30;
    // B帧最大的数量 B帧越多视频越清晰 但比较消耗性能与时
    codecContext->max_b_frames = 0;
    
    // 查找编码器->h264
    codec = avcodec_find_encoder(codecContext->codec_id);
    if (codec == NULL) {
        NSLog(@"找不到编码器");
        return NO;
    }

    //编码选项->编码设置 (编码延时问题)
    AVDictionary *param = 0;
    if (codecContext->codec_id == AV_CODEC_ID_H264) {
        //需要查看x264源码->x264.c文件
        //第一个值：预备参数
        //key: preset
        //value: slow->慢
        //value: superfast->超快
        av_dict_set(&param, "preset", "slow", 0);
        //第二个值：调优
        //key: tune->调优
        //value: zerolatency->零延迟
        av_dict_set(&param, "tune", "zerolatency", 0);
    }
    
    // 打开编码器
    if (avcodec_open2(codecContext, codec, &param) < 0) {
        NSLog(@"打开编码器失败");
        return NO;
    }
    
    avformat_write_header(formatContext, NULL);
    
    y_size = codecContext->width * codecContext->height;
    
    // 视频编码前YUV缓存区 大小
    int one_image_buffer_size = av_image_get_buffer_size(codecContext->pix_fmt,
                                                         codecContext->width,
                                                         codecContext->height,
                                                         1);
    image_buffer = (uint8_t *)av_malloc(one_image_buffer_size);
    
    // 视频编码前YUV缓存区
    frame = av_frame_alloc();
    av_image_fill_arrays(frame->data,
                         frame->linesize,
                         image_buffer,
                         codecContext->pix_fmt,
                         codecContext->width,
                         codecContext->height,
                         1);
    
    // 视频编码后缓存区
    packet = (AVPacket *)av_malloc(one_image_buffer_size);

    return YES;
}

- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
   CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
   
   // 锁定imageBuffer内存地址开始进行编码
   if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
       
       // 从CVPixelBufferRef读取YUV的值
       // NV12和NV21属于YUV格式，是一种two-plane模式，即Y和UV分为两个Plane，但是UV（CbCr）为交错存储，而不是分为三个plane
       // 获取Y分量的地址
       UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
       // 获取UV分量的地址
       UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
       
       // 根据像素获取图片的真实宽度&高度
       size_t width = CVPixelBufferGetWidth(imageBuffer);
       size_t height = CVPixelBufferGetHeight(imageBuffer);
       
       // 获取Y分量长度
       size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
       size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,1);
       UInt8 *yuv420_data = (UInt8 *)malloc(width * height *3/2);
       
       // 将NV12数据转成YUV420P(I420)数据
       UInt8 *pY = bufferPtr ;
       UInt8 *pUV = bufferPtr1;
       UInt8 *pU = yuv420_data + width*height;
       UInt8 *pV = pU + width*height/4;
       for(int i =0;i<height;i++)
       {
           memcpy(yuv420_data+i*width,pY+i*bytesrow0,width);
       }
       for(int j = 0;j<height/2;j++)
       {
           for(int i =0;i<width/2;i++)
           {
               *(pU++) = pUV[i<<1];
               *(pV++) = pUV[(i<<1) + 1];
           }
           pUV+=bytesrow1;
       }
       
       // 读取YUV的数据 给frame填充数据
       image_buffer = yuv420_data;
       frame->data[0] = image_buffer;              // Y
       frame->data[1] = image_buffer+ y_size;      // U
       frame->data[2] = image_buffer+ y_size*5/4;  // V
       // 设置当前帧
       frame->pts = frameCount;
       frameCount++;
       
       frame->width = self.videoConfigure.width;
       frame->height = self.videoConfigure.height;
       frame->format = AV_PIX_FMT_YUV420P;
   
       avcodec_send_frame(codecContext, frame);
       int result = avcodec_receive_packet(codecContext, packet);
       if (result == 0) {
           packet->stream_index = stream->index;
           result = av_write_frame(formatContext, packet);
           av_packet_unref(packet);
           NSLog(@"=====第几==%d", frameCount);
           if (result < 0) {
               return;
           }
       }

       free(yuv420_data);
   }
   
   CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {
    
    const char *inFilePath = [filePath UTF8String];
    FILE *in_file = fopen(inFilePath, "rb");
    if (in_file == NULL) {
        NSLog(@"文件不存在");
        return;
    }
    
    int i = 0;
    int result = 0;
    while (true) {
        
       //从yuv文件里面读取缓冲区
       //读取yuv大小：y_size * 3 / 2
       if (fread(image_buffer, 1, y_size * 3 / 2, in_file) <= 0) {
           NSLog(@"读取完毕...");
           break;
       } else if (feof(in_file)) {
           break;
       }

       //将缓冲区数据->转成AVFrame类型
       //给AVFrame填充数据
       frame->data[0] = image_buffer;
       frame->data[1] = image_buffer + y_size;
       frame->data[2] = image_buffer + y_size * 5 / 4;
       frame->pts = i;
       i++;
        
       frame->width = self.videoConfigure.width;
       frame->height = self.videoConfigure.height;
       frame->format = AV_PIX_FMT_YUV420P;
   
       // 编码
       avcodec_send_frame(codecContext, frame);
       result = avcodec_receive_packet(codecContext, packet);
       if (result == 0) {
           //将视频压缩数据->写入到输出文件中->outFilePath
           packet->stream_index = stream->index;
           result = av_write_frame(formatContext, packet);
           NSLog(@"=====第几帧==%d", i);
           if (result < 0) {
               return;
           }
       }
    }
    
    [self endCodec];
    
    fclose(in_file);
    
    !completion ?: completion(self.videoConfigure.outFilePath);
}

- (void)endCodec {
    [super endCodec];
    
    // 写入剩余帧数据
    flush_video_encoder(formatContext,0);
    // 写入文件尾部信息
    av_write_trailer(formatContext);

    avcodec_close(codecContext);
    av_free(frame);
    av_free(image_buffer);
    av_packet_free(&packet);
    avio_close(formatContext->pb);
    avformat_free_context(formatContext);
    
    frameCount = 0;
    
}

int flush_video_encoder(AVFormatContext *fmt_ctx, unsigned int stream_index) {
    int ret;
    int got_frame;
    AVPacket enc_pkt;
    if (!(fmt_ctx->streams[stream_index]->codec->codec->capabilities &
          AV_DISPOSITION_KARAOKE))
        return 0;
    while (1) {
        enc_pkt.data = NULL;
        enc_pkt.size = 0;
        av_init_packet(&enc_pkt);
        ret = avcodec_encode_video2(fmt_ctx->streams[stream_index]->codec, &enc_pkt,
                                    NULL, &got_frame);
        av_frame_free(NULL);
        if (ret < 0)
            break;
        if (!got_frame) {
            ret = 0;
            break;
        }
        NSLog(@"Flush Encoder: Succeed to encode 1 frame!\tsize:%5d\n", enc_pkt.size);
        /* mux encoded frame */
        ret = av_write_frame(fmt_ctx, &enc_pkt);
        if (ret < 0)
            break;
    }
    return ret;
}

@end
