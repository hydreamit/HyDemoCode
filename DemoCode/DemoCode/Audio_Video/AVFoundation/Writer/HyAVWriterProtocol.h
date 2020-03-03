//
//  HyAVWriterProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HyAudioWriterProtocol.h"
#import "HyVideoWriterProtocol.h"
#import "HyAVWriterTypedef.h"



NS_ASSUME_NONNULL_BEGIN

@protocol HyAVWriterProtocol <NSObject>

@required
- (void(^)(NSURL *fileUrl))startRecording;
- (void)stopRceordingWithCompletionHandler:(void(^_Nullable)(NSURL *fileUrl))handler;
- (void)pauseRecording;
- (void)resumeRecording;
- (void)cancelRecording;
- (void)startRecordingWithURL:(NSURL *)URL
                         time:(NSTimeInterval)time
            completionHandler:(void(^_Nullable)(NSURL *fileUrl))handler;

@property (nonatomic,copy) void(^recordingProcessBlock)(NSTimeInterval time);
@property (nonatomic,assign,readonly,getter=isAssetWriting) BOOL assetWriting;
@property (nonatomic,assign) HyAVWriterType writerType;
@property (nonatomic,assign) HyAVWriterStatus writerStatus;




@optional
@property (nonatomic,assign,getter=isWriting) BOOL writing;
@property (nonatomic,strong,readonly) AVAssetWriter *writer;
@property (nonatomic,strong,readonly,nullable) id<HyAudioWriterProtocol> audioWriter;
@property (nonatomic,strong,readonly,nullable) id<HyVideoWriterProtocol> videoWriter;
- (void)addAudioWriter:(id<HyAudioWriterProtocol>)audioWriter;
- (void)addVideoWriter:(id<HyVideoWriterProtocol>)videoWriter;

@end

NS_ASSUME_NONNULL_END
