//
//  HyGPUImageVideoCamera.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/14.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyGPUImageVideoCamera.h"


@interface HyGPUImageVideoCamera ()<GPUImageVideoCameraDelegate>
@property (nonatomic,weak) UIView *onView;
@property (nonatomic,strong) GPUImageView *gpuImageView;
@property (nonatomic,strong) GPUImageStillCamera *videoCamera;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,copy) void(^outputSampleBufferHandler)(CMSampleBufferRef sampleBuffer);
@property (nonatomic,strong) GPUImageMovieWriter *writer;
@property (nonatomic,strong) NSURL *recordFileURL;
@end


@implementation HyGPUImageVideoCamera

+ (instancetype)videoCameraWithFrame:(CGRect)frame
                              onView:(UIView *)onView
                              filter:(GPUImageOutput<GPUImageInput> *)filter
                 sampleBufferHandler:(void(^)(CMSampleBufferRef sampleBuffer))handler {
    
    if (!onView || CGRectEqualToRect(frame, CGRectZero)) {
        return nil;
    }
    HyGPUImageVideoCamera *videoCamera = [[self alloc] init];
    videoCamera.gpuImageView = [[GPUImageView alloc] initWithFrame:frame];
    videoCamera.onView = onView;
    videoCamera.filter = filter;
    videoCamera.outputSampleBufferHandler = [handler copy];
    return videoCamera;
}

- (void)startCameraCapture {
    if (self.videoCamera.captureSession.isRunning) {
        return;
    }
    [self.onView insertSubview:self.gpuImageView atIndex:0];
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [self.videoCamera startCameraCapture];
    });
}

- (void)stopCameraCapture {
    dispatch_async(dispatch_queue_create(0, 0), ^{
        [self.videoCamera startCameraCapture];
    });
}

- (void)rotateCamera {
    
    CATransition *transition = CATransition.new;
    transition.type = @"oglFlip";
    transition.subtype = @"fromLeft";
    transition.duration = .65;
    [self.gpuImageView.layer addAnimation:transition forKey:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                  (int64_t)(.1 * NSEC_PER_SEC)),
    dispatch_get_main_queue(), ^{
        [self.videoCamera rotateCamera];
    });
}

- (void)removeFilter {
    if (self.filter) {
        self.filter = nil;
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.gpuImageView];
    }
}

- (void)addFilter:(GPUImageOutput<GPUImageInput> *)filter {
    if (filter) {
        if (self.filter) {
            [self removeFilter];
        }
        [filter addTarget:self.gpuImageView];
        [self.videoCamera addTarget:filter];
        self.filter = filter;
    }
}

- (NSURL *)recordFileURL {
    
    NSString *string =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *fileName = self.videoCapturer ? @"video.mp4" : @"audio.mp3";
    NSString *fileName = @"sdsdvideo.mp4";
    NSString *filePath = [string stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:filePath];
}

- (void(^)(NSURL *fileUrl))startRecording {
    return ^(NSURL *fileUrl){
        if (!self.writer) {
            
            self.recordFileURL = fileUrl;
            self.writer = [[GPUImageMovieWriter alloc] initWithMovieURL:fileUrl size:self.gpuImageView.frame.size];
            self.writer.encodingLiveVideo = YES;
            if (self.filter) {
               [self.filter addTarget:self.writer];
            }
            self.videoCamera.audioEncodingTarget = self.writer;
            dispatch_async(dispatch_queue_create(0, 0), ^{
                [self.writer startRecording];
            });
        }
    };
}

- (void)stopRceordingWithCompletionHandler:(void(^)(NSURL *fileUrl))handler {
    __weak typeof(self) _self = self;
    [self.writer finishRecordingWithCompletionHandler:^{
        __strong typeof(_self) self = _self;
        
        if (self.filter) {
            [self.filter removeTarget:self.writer];
        }
        self.videoCamera.audioEncodingTarget = nil;
        self.writer = nil;
        !handler ?: handler(self.recordFileURL);
    }];
}

- (void)takePhotoWithCompletionHandler:(void (^)(UIImage * _Nonnull, NSError * _Nonnull))handler {
    [self.videoCamera capturePhotoAsImageProcessedUpToFilter:self.filter
                                       withCompletionHandler:handler];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    !self.outputSampleBufferHandler ?: self.outputSampleBufferHandler(sampleBuffer);
}

- (GPUImageStillCamera *)videoCamera {
    if (!_videoCamera){
        _videoCamera =
        [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        if (self.filter) {
            [self.filter addTarget:self.gpuImageView];
            [_videoCamera addTarget:self.filter];
        } else {
            [_videoCamera addTarget:self.gpuImageView];
        }
        _videoCamera.delegate = self;
    }
    return _videoCamera;
}

@end
