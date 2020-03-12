//
//  HyOpenGLESVideoPlayer.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/9.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <QuartzCore/QuartzCore.h>
#include <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyOpenGLESVideoPlayer : CAEAGLLayer

@property CVPixelBufferRef pixelBuffer;
- (id)initWithFrame:(CGRect)frame;
- (void)resetRenderBuffer;

@end

NS_ASSUME_NONNULL_END
