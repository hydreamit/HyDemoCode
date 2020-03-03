//
//  HyAudioWriterProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HyAVWriterTypedef.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyAVWriterProtocol;
@protocol HyAudioWriterProtocol <NSObject>

@property (nonatomic,assign) HyAVWriterStatus writerStatus;

@property (nonatomic,weak) id<HyAVWriterProtocol> avWriter;
@property (nonatomic,strong,readonly) AVAssetWriterInput *audioInput;

+ (instancetype(^)(int channels, CGFloat sampleRate))audioWriter;
- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
