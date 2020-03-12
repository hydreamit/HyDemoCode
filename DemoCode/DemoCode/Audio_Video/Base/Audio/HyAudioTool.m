//
//  HyAudioTool.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioTool.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation HyAudioTool

- (NSData *)convertAudioSamepleBufferToPcmData:(CMSampleBufferRef)sampleBuffer {
    
    //获取pcm数据大小
    size_t size = CMSampleBufferGetTotalSampleSize(sampleBuffer);
    //分配空间
    int8_t *audio_data = (int8_t *)malloc(size);
    memset(audio_data, 0, size);
    
    //获取CMBlockBuffer, 这里面保存了PCM数据
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    //将数据copy到我们分配的空间中
    CMBlockBufferCopyDataBytes(blockBuffer, 0, size, audio_data);
    NSData *data = [NSData dataWithBytes:audio_data length:size];
    
    free(audio_data);
    return data;
}

@end
