//
//  HyVideoEncoderProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyVideoEncoderProtocol <NSObject>

- (void)codecWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
