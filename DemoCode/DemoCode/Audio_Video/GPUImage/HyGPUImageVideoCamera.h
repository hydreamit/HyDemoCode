//
//  HyGPUImageVideoCamera.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/14.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyGPUImageVideoCamera : NSObject

+ (instancetype)videoCameraWithFrame:(CGRect)frame
                              onView:(UIView *)onView
                              filter:(GPUImageOutput<GPUImageInput> *)filter
                 sampleBufferHandler:(void(^)(CMSampleBufferRef sampleBuffer))handler;

- (void)startCameraCapture;
- (void)stopCameraCapture;
- (void)rotateCamera;

- (void)removeFilter;
- (void)addFilter:(GPUImageOutput<GPUImageInput> *)filter;


- (void(^)(NSURL *fileUrl))startRecording;
- (void)stopRceordingWithCompletionHandler:(void(^)(NSURL *fileUrl))handler;

- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *processedImage, NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
