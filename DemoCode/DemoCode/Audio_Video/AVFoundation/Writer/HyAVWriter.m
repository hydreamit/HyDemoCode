//
//  HyAVWriter.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAVWriter.h"
#import "HyAVCaptureProtocol.h"


@interface HyAVWriter ()
@property (nonatomic,strong) NSURL *recordFileURL;
@property (nonatomic,strong) AVAssetWriter *writer;
@property (nonatomic,strong) id<HyAudioWriterProtocol> audioWriter;
@property (nonatomic,strong) id<HyVideoWriterProtocol> videoWriter;
@property (nonatomic,assign,getter=isAssetWriting) BOOL assetWriting;
@property (nonatomic,copy) void(^timeCompletionHandler)(NSURL *);
@end


@implementation HyAVWriter
@synthesize writing = _writing, writerType = _writerType, writerStatus = _writerStatus, recordingProcessBlock = _recordingProcessBlock;
- (void (^)(NSURL * _Nonnull))startRecording {
    return ^(NSURL *url){
        if (!self.isAssetWriting) {
            self.recordFileURL = url;
            self.assetWriting = YES;
            self.writer = nil;
            self.audioWriter = nil;
            self.videoWriter = nil;
            [[NSFileManager defaultManager] removeItemAtPath:self.recordFileURL.path error:nil];
            self.writer = [AVAssetWriter assetWriterWithURL:self.recordFileURL fileType:AVFileTypeMPEG4 error:nil];
            self.writer.shouldOptimizeForNetworkUse = YES;
            self.writerStatus = HyAVWriterStatusRecording;
        }
    };
}

- (void)stopRceordingWithCompletionHandler:(void (^)(NSURL * _Nonnull))handler {
    if (self.isAssetWriting) {
        self.assetWriting = NO;
        self.writing = NO;
        if (self.writer.status == AVAssetWriterStatusWriting) {
            __weak typeof(self) _self = self;
            dispatch_async(HyAVCapture_Queue, ^{
                [self.writer finishWritingWithCompletionHandler:^{
                    __strong typeof(_self) self = _self;
                    self.writerStatus = HyAVWriterStatusNoRecording;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !handler ?: handler(self.recordFileURL);
                    });
                }];
            });
        }
    }
}

- (void)startRecordingWithURL:(NSURL *)URL
                         time:(NSTimeInterval)time
            completionHandler:(void(^_Nullable)(NSURL *fileUrl))handler {

    if (!self.isAssetWriting) {
        self.maxTime = time;
        self.timeCompletionHandler = [handler copy];
        self.startRecording(URL);
    }
}

- (void)addAudioWriter:(id<HyAudioWriterProtocol>)audioWriter {
    if (audioWriter) {
        self.audioWriter = audioWriter;
        self.audioWriter.avWriter = self;
        [self.writer addInput:audioWriter.audioInput];
    }
}

- (void)addVideoWriter:(id<HyVideoWriterProtocol>)videoWriter {
    if (videoWriter) {
        self.videoWriter = videoWriter;
        self.videoWriter.avWriter = self;
        [self.writer addInput:videoWriter.videoInput];
    }
}

- (void)cancelRecording {
    
    [self.writer cancelWriting];
    self.assetWriting = NO;
    self.writing = NO;
    
    self.writerStatus = HyAVWriterStatusNoRecording;
    if (self.audioWriter) {
        self.audioWriter.writerStatus = HyAVWriterStatusNoRecording;
    }
    if (self.videoWriter) {
        self.videoWriter.writerStatus = HyAVWriterStatusNoRecording;
    }
    self.writer = nil;
    self.audioWriter = nil;
    self.videoWriter = nil;
}

- (void)pauseRecording {
    if (self.writerStatus == HyAVWriterStatusRecording) {
        self.writerStatus = HyAVWriterStatusPauseing;
        if (self.audioWriter) {
            self.audioWriter.writerStatus = HyAVWriterStatusPauseing;
        }
        if (self.videoWriter) {
            self.videoWriter.writerStatus = HyAVWriterStatusPauseing;
        }
    }
}

- (void)resumeRecording {
    if (self.writerStatus == HyAVWriterStatusPauseing) {
        self.writerStatus = HyAVWriterStatusResuming;
        if (self.audioWriter) {
            self.audioWriter.writerStatus = HyAVWriterStatusResuming;
        }
        if (self.videoWriter) {
            self.videoWriter.writerStatus = HyAVWriterStatusResuming;
        }
    }
}

- (void)writingTimeOut {
    [self stopRceordingWithCompletionHandler:self.timeCompletionHandler];
}

@end
