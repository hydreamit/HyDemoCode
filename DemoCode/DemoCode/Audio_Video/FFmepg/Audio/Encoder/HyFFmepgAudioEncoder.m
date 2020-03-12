//
//  HyFFmepgAudioEncoder.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/4.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyFFmepgAudioEncoder.h"
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


@implementation HyFFmepgAudioEncoder {
            
    AVFormatContext                       *formatContext;   // 格式封装上下文
    AVOutputFormat                        *outputFormat;   //  视频输出格式
    AVStream                              *stream;        // 音频码流
    AVCodecContext                        *codecContext; // 编码器上下文
    AVCodec                               *codec;         // 编码器
    AVFrame                               *frame;        //音频编码前缓存区
    AVPacket                              *packet;      // 音频编码后帧缓存区
    uint8_t                               *sample_buffer;  // 采样帧内存
    int                                   sample_buffer_size; // 采样帧内存大戏哦啊
    int                                   frameCount; //当前帧数
    BOOL isEndCodec;
}

- (BOOL)encoderInitialization {

    av_register_all();

     formatContext = avformat_alloc_context();

     [self closeFile];
     const char *coutFilePath = [self.audioConfigure.outFilePath UTF8String];
     outputFormat = av_guess_format(NULL, coutFilePath, NULL);

     formatContext->oformat = outputFormat;

     if (avio_open(&formatContext->pb, coutFilePath, AVIO_FLAG_WRITE) < 0) {
         NSLog(@"打开输出文件失败");
         return NO;
     }


     stream = avformat_new_stream(formatContext, NULL);

     // 编码器上下文
     codecContext = stream->codec;
     codecContext->codec_id = outputFormat->audio_codec;
     codecContext->codec_type = AVMEDIA_TYPE_AUDIO;
     codecContext->sample_fmt = AV_SAMPLE_FMT_S16;
     codecContext->sample_rate = 44100;
     codecContext->bit_rate = 128000;
     codecContext->channel_layout = AV_CH_LAYOUT_STEREO; //立体声
     codecContext->channels = av_get_channel_layout_nb_channels(codecContext->channel_layout);//声道数量

     // 查找编码器
    codec = avcodec_find_encoder_by_name("libfdk_aac");
     if (codec == NULL) {
         NSLog(@"找不到音频编码器");
         return NO;
     }

     // 打开编码器
     if (avcodec_open2(codecContext, codec, NULL) < 0) {
         NSLog(@"打开音频编码器失败");
         return NO;
     }

     // 音视频编码前采样缓冲区
    AVFrame *av_frame = av_frame_alloc();
    av_frame->nb_samples = codecContext->frame_size;
    av_frame->format = codecContext->sample_fmt;

    sample_buffer_size = av_samples_get_buffer_size(NULL,
                                                    codecContext->channels,
                                                    codecContext->frame_size,
                                                    codecContext->sample_fmt,
                                                    1);
    sample_buffer = (uint8_t *) av_malloc(sample_buffer_size);

    avcodec_fill_audio_frame(av_frame,
                             codecContext->channels,
                             codecContext->sample_fmt,
                             (const uint8_t *)sample_buffer,
                             sample_buffer_size,
                             1);

     return YES;
}

- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer{}

- (void)codecWithFilePath:(NSString *)filePath completion:(void (^)(NSString * _Nonnull))completion {
    
    if (isEndCodec) {
        return;
    }

    if (!codec) {
        if (![self encoderInitialization]) {
            return;
        }
    }
    
    const char *infilePath = [filePath UTF8String];
    FILE *in_file = fopen(infilePath, "rb");
    if (in_file == NULL) {
        NSLog(@"音频文件打开失败");
        return;
    }


    int i = 0, ret = 0;
    while (true && !isEndCodec) {

        if (fread(sample_buffer, 1, sample_buffer_size, in_file) <= 0) {
            NSLog(@"Failed to read raw data! \n");
            break;
        } else if (feof(in_file)) {
            break;
        }

        // 填充 frame
        frame->data[0] = sample_buffer;
        frame->pts = i;
        i++;

        // 码一帧音频采样数据->得到音频压缩数据->aac
        ret = avcodec_send_frame(codecContext, frame);
        if (ret != 0) {
            NSLog(@"Failed to send frame! \n");
            return;
        }
        ret = avcodec_receive_packet(codecContext, packet);

        if (ret == 0) {
            // 将编码后的音频码流写入文件
            packet->stream_index = stream->index;
            ret = av_write_frame(formatContext, packet);
            

            NSLog(@"当前编码到了第%d帧", i);
            if (ret < 0) {
                NSLog(@"写入失败! \n");
                return;
            }
        } else {
            NSLog(@"Failed to encode! \n");
            return;
        }
    }

    ret = flush_audio_encoder(formatContext, 0);
    if (ret < 0) {
        NSLog(@"Flushing encoder failed\n");
        return;
    }

    [self endCodec];
    
    fclose(in_file);

    !completion ?: completion(self.audioConfigure.outFilePath);
}

- (void)endCodec {
    [super endCodec];
    
    //写文件尾（对于某些没有文件头的封装格式，不需要此函数。比如说MPEG2TS）
   av_write_trailer(formatContext);

   // 释放内存
   avcodec_close(codecContext);
   av_free(frame);
   av_free(sample_buffer);
   av_packet_free(&packet);
   avio_close(formatContext->pb);
   avformat_free_context(formatContext);

    isEndCodec = YES;
}

int flush_audio_encoder(AVFormatContext *fmt_ctx, unsigned int stream_index) {

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
