//
//  HyAudioDecoderProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/10.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioCodecProtocol.h"


NS_ASSUME_NONNULL_BEGIN

// ADTS + AAC 频压缩数据 -> 音PCM音频数据

@protocol HyAudioDecoderProtocol <HyAudioCodecProtocol>

- (void)codecWithAACData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
