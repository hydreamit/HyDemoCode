//
//  HyAVCapturer.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAVCapturer.h"
#import "HyAVWriter.h"


@interface HyAVCapturer () 
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) id<HyAudioCapturerProtocol> audioCapturer;
@property (nonatomic,strong) id<HyVideoCapturerProtocol> videoCapturer;
@end


@implementation HyAVCapturer
@synthesize avWriter = _avWriter;
- (void)addAudioCapturer:(id<HyAudioCapturerProtocol>)audioCapturer {
    if (audioCapturer) {
        self.audioCapturer = audioCapturer;
        self.audioCapturer.avCapture = self;
        [self.session beginConfiguration];
        [self addInput:audioCapturer.audioInput];
        [self addOutput:audioCapturer.audioOutput];
        [self.session commitConfiguration];
    }
}

- (void)addVideoCapturer:(id<HyVideoCapturerProtocol>)videoCapturer {
    if (videoCapturer) {
        self.videoCapturer = videoCapturer;
        self.videoCapturer.avCapture = self;
        [self.session beginConfiguration];
        [self addInput:videoCapturer.videoInput];
        [self addOutput:videoCapturer.videoOutput];
        [self.session commitConfiguration];
        // added next to set
        [videoCapturer.videoOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation = AVCaptureVideoOrientationPortrait;
    }
}

- (void)startRunning {
    
    if ((!self.audioCapturer && !self.videoCapturer) || self.session.isRunning) {
        return;
    }
    
    __block NSInteger authCount = 0;
    if (self.audioCapturer) {authCount++;};
    if (self.videoCapturer) {authCount++;};
    void (^authBlock)(AVAuthorizationStatus) = ^(AVAuthorizationStatus status){
        if (status == AVAuthorizationStatusAuthorized) {
            authCount > 1 ? authCount-- : [self.session startRunning];
        }
    };
    if (self.audioCapturer) {
        [self.audioCapturer audioAuthWithStatusBlock:authBlock];
    }
    if (self.videoCapturer) {
        [self.videoCapturer videoAuthWithStatusBlock:authBlock];
    }
}

- (void)stopRunning {
    if ((!self.audioCapturer && !self.videoCapturer) || !self.session.isRunning) {
        return;
    }
    [self.session stopRunning];
    [self.videoCapturer.preViewLayer removeFromSuperlayer];
}

- (void)addInput:(AVCaptureInput *)input {
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
}

- (void)addOutput:(AVCaptureOutput *)output {
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
}

- (AVCaptureSession *)session {
    if (!_session){
        _session = [[AVCaptureSession alloc] init];
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
    }
    return _session;
}

- (void)dealloc {
    [self stopRunning];
    if (self.audioCapturer) {
        [self.session removeInput:self.audioCapturer.audioInput];
        [self.session removeOutput:self.audioCapturer.audioOutput];
    }
    if (self.videoCapturer) {
        [self.session removeInput:self.videoCapturer.videoInput];
        [self.session removeOutput:self.videoCapturer.videoOutput];
    }
}

- (void)setAvWriter:(id<HyAVWriterProtocol>)avWriter {
    _avWriter = avWriter;
    if (self.audioCapturer && !self.videoCapturer) {
        avWriter.writerType = HyAVWriterTypeAudio;
    } else
    if (!self.audioCapturer && self.videoCapturer) {
        avWriter.writerType = HyAVWriterTypeVideo;
    } else
    if (self.audioCapturer && self.videoCapturer) {
        avWriter.writerType = HyAVWriterTypeAudioVideo;
    }
}

////session运行期间发生错误
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSessionState:) name:AVCaptureSessionRuntimeErrorNotification object:nil];
////session开始运行的通知
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSessionStartRunning:) name:AVCaptureSessionDidStartRunningNotification object:nil];
////session停止运行的通知
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSessionStopRunning:) name:AVCaptureSessionDidStopRunningNotification object:nil];
////session被打断的通知
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSessionInterrpute:) name:AVCaptureSessionWasInterruptedNotification object:nil];

@end
