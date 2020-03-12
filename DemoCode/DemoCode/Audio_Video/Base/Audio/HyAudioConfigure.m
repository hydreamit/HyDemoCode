//
//  HyAudioConfigure.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioConfigure.h"

@implementation HyAudioConfigure
@synthesize sampleRate = _sampleRate, channelCount = _channelCount, bitrate = _bitrate, outFilePath = _outFilePath, codecBlock = _codecBlock;

- (instancetype)init {
    if (self = [super init]) {
        self.channelCount = 1;
        self.bitrate = 64000;
        self.sampleRate  = 44100;
    }
    return self;
}

@end
