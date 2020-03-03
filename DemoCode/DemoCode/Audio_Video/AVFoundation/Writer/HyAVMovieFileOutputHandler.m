//
//  HyAVMovieFileOutputHandler.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/16.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAVMovieFileOutputHandler.h"


@interface HyAVMovieFileOutputHandler ()<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic,strong) AVCaptureMovieFileOutput *fileOutput;
@property (nonatomic,copy) void(^completionHandler)(NSURL *);
@property (nonatomic,copy) void(^timeCompletionHandler)(NSURL *);
@property (nonatomic,weak) AVCaptureSession *session;
@property (nonatomic,strong) NSURL *recordFileURL;
@property (nonatomic,strong) NSTimer *timer;
@end


@implementation HyAVMovieFileOutputHandler
@synthesize writerType = _writerType, writerStatus = _writerStatus, recordingProcessBlock = _recordingProcessBlock;
+ (instancetype(^)(AVCaptureSession *session))handler {
    return ^(AVCaptureSession *session){
        HyAVMovieFileOutputHandler *handler = [[self alloc] init];
        handler.session = session;
        return handler;
    };
}

- (void (^)(NSURL * _Nonnull))startRecording {
    return ^(NSURL *url){
        if (!self.fileOutput.isRecording) {
            self.recordFileURL = url;
            [[NSFileManager defaultManager] removeItemAtPath:self.recordFileURL.path error:nil];
            [self.session removeOutput:self.fileOutput];
            if ([self.session canAddOutput:self.fileOutput]) {
                [self.session addOutput:self.fileOutput];
            }
            [self.fileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        }
    };
}

- (void)stopRceordingWithCompletionHandler:(void (^_Nullable)(NSURL * _Nonnull))handler {
    if (!self.fileOutput.isRecording) {
        return;
    }
    self.completionHandler = [handler copy];
    [self.fileOutput stopRecording];
    [self.session removeOutput:self.fileOutput];
}

- (void)startRecordingWithURL:(NSURL *)URL
                         time:(NSTimeInterval)time
            completionHandler:(void(^_Nullable)(NSURL *fileUrl))handler {
    
    if (!self.fileOutput.isRecording) {
        
        self.recordFileURL = URL;
        [[NSFileManager defaultManager] removeItemAtPath:self.recordFileURL.path error:nil];
        [self.session removeOutput:self.fileOutput];
        if ([self.session canAddOutput:self.fileOutput]) {
            [self.session addOutput:self.fileOutput];
        }
        self.timeCompletionHandler = [handler copy];
        self.fileOutput.maxRecordedDuration = CMTimeMake(time, 1);
        [self.fileOutput startRecordingToOutputFileURL:URL recordingDelegate:self];
    }
}

- (void)captureOutput:(AVCaptureFileOutput *)output didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections {
    
    self.writerStatus = HyAVWriterStatusRecording;
    [self startTimer];
}

- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(nullable NSError *)error {
    
    if (self.completionHandler) {
        self.completionHandler(outputFileURL);
        self.timeCompletionHandler = nil;
    } else {
        !self.timeCompletionHandler ?: self.timeCompletionHandler(outputFileURL);
        self.timeCompletionHandler = nil;
    }
    self.writerStatus = HyAVWriterStatusNoRecording;
    [self stopTimer];
}

- (AVCaptureMovieFileOutput *)fileOutput {
    if (!_fileOutput){
        _fileOutput = [[AVCaptureMovieFileOutput alloc] init];
        AVMediaType type = self.writerType == HyAVWriterTypeAudio ? AVMediaTypeAudio : AVMediaTypeVideo;
        AVCaptureConnection *connection = [_fileOutput connectionWithMediaType:type];
        connection.automaticallyAdjustsVideoMirroring = YES;
        if (type == AVMediaTypeVideo) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    return _fileOutput;
}

- (BOOL)isAssetWriting {
    return NO;
}

- (void)pauseRecording {
    NSLog(@"AVCaptureMovieFileOutput 不支持暂停");
}

- (void)resumeRecording {
   NSLog(@"AVCaptureMovieFileOutput 不支持暂停");
}

- (void)cancelRecording {
    [self stopRceordingWithCompletionHandler:^(NSURL * _Nonnull fileUrl) {
         [[NSFileManager defaultManager] removeItemAtPath:fileUrl.path error:nil];
    }];
}

- (void)startTimer{
    [self stopTimer];
    __weak typeof(self) _self = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(_self) self = _self;
        !_self.recordingProcessBlock ?: _self.recordingProcessBlock(CMTimeGetSeconds(self.fileOutput.recordedDuration));
    }];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

@end
