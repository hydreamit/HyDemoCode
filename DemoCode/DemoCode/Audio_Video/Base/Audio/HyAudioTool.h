//
//  HyAudioTool.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyAudioTool : NSObject

/// CMSampleBufferRef 提取PCM 数据
- (NSData *)convertAudioSamepleBufferToPcmData:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
