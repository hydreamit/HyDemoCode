//
//  HyAudioEncoderProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/10.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HyAudioCodecProtocol.h"

NS_ASSUME_NONNULL_BEGIN

// PCM音频数据 -> ADTS + AAC音频压缩数据
@protocol HyAudioEncoderProtocol <HyAudioCodecProtocol>

- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
