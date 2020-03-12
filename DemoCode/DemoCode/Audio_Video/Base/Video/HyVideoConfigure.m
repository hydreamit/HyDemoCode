//
//  HyVideoConfigure.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoConfigure.h"

@implementation HyVideoConfigure
@synthesize width = _width, height = _height, bitrate = _bitrate, frameRate = _frameRate, gop_size = _gop_size, max_b_frames = _max_b_frames, outFilePath = _outFilePath, encodeBlock = _encodeBlock, decodeBlock = _decodeBlock;

- (instancetype)init {
    if (self = [super init]) {
        self.frameRate = 30;
        self.gop_size = 30;
        self.max_b_frames = 0;
    }
    return self;
}

@end
