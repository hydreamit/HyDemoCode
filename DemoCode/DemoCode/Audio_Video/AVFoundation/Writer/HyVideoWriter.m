//
//  HyVideoWriter.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoWriter.h"
#import "HyAVWriterProtocol.h"
#import "HyAVWriter.h"


@interface HyVideoWriter ()
@property (nonatomic,strong) AVAssetWriterInput *videoInput;
@property (nonatomic,assign) CMTime startTime;
@property (nonatomic,assign) CMTime lastTime;
@property (nonatomic,assign) CMTime timeOffset;
@end


@implementation HyVideoWriter
@synthesize avWriter = _avWriter, writerStatus = _writerStatus;
+ (instancetype(^)(CGFloat width, CGFloat height))videoWriter {
    return ^(CGFloat width, CGFloat height){
        
        HyVideoWriter *vWriter = [[self alloc] init];
        NSDictionary* videoSettings = @{
                                   AVVideoCodecKey: AVVideoCodecH264,
                                   AVVideoWidthKey: @(width),
                                   AVVideoHeightKey: @(height),
                                   AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                   AVVideoCompressionPropertiesKey: @{
//                                           AVVideoAverageBitRateKey: @(468000),
                                           AVVideoAverageBitRateKey: @((width * height) * 12),
                                           AVVideoExpectedSourceFrameRateKey: @(15),
                                           AVVideoMaxKeyFrameIntervalKey: @(15),
                                           AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel,
//                                           AVVideoAllowFrameReorderingKey: @NO,
//                                           AVVideoH264EntropyModeKey: AVVideoH264EntropyModeCAVLC,
                                           //AVVideoAverageNonDroppableFrameRateKey: @(24)
                                           }
                                   };
        vWriter.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                outputSettings:videoSettings];
        vWriter.videoInput.expectsMediaDataInRealTime = YES;
        return vWriter;
    };
}

- (BOOL)encodeFrame:(CMSampleBufferRef)sampleBuffer {
    
    CFRetain(sampleBuffer);
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
                
        NSInteger writerCount = self.avWriter.writerType == HyAVWriterTypeAudioVideo ? 2 : 1;
        if (self.avWriter.writer.inputs.count < writerCount) {
            CFRelease(sampleBuffer);
            return NO;
        }

        CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        if (!self.avWriter.isWriting && self.avWriter.writer.status == AVAssetWriterStatusUnknown) {
            self.avWriter.writing = YES;
            [self.avWriter.writer startWriting];
            [self.avWriter.writer startSessionAtSourceTime:startTime];
        }

        if (self.avWriter.writer.status == AVAssetWriterStatusFailed) {
            NSLog(@"videoWriter error %@", self.avWriter.writer.error.localizedDescription);
            CFRelease(sampleBuffer);
            return NO;
        }

        if (self.writerStatus == HyAVWriterStatusPauseing) {
            if (self.lastTime.value == 0) {
                 self.lastTime = startTime;
//                CMTime duration = CMSampleBufferGetDuration(sampleBuffer);
//                if (duration.value > 0) {
//                   self.lastTime = CMTimeAdd(startTime, duration);
//                } else {
//                   self.lastTime = startTime;
//                }
            }
            CFRelease(sampleBuffer);
            return NO;
        }

        if (self.writerStatus == HyAVWriterStatusResuming) {
            self.writerStatus = HyAVWriterStatusRecording;
            self.avWriter.writerStatus = HyAVWriterStatusRecording;
            
            CMTime offset = CMTimeSubtract(startTime, self.lastTime);
            if (self.timeOffset.value == 0) {
                self.timeOffset = offset;
            } else {
                self.timeOffset = CMTimeAdd(self.timeOffset, offset);
            }
            
            self.lastTime = CMTimeMake(0, 1);
        }
            
        if (self.timeOffset.value > 0) {
           CFRelease(sampleBuffer);
           sampleBuffer = [self adjustTime:sampleBuffer by:self.timeOffset];
        }
           
        CMTime time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        if (self.startTime.value == 0) {
           self.startTime = time;
        }

        CMTime sub = CMTimeSubtract(time, self.startTime);
        Float64 recordTotalTime = CMTimeGetSeconds(sub);
        
        BOOL isHandleTime = self.avWriter.writerType != HyAVWriterTypeAudio;
        if (isHandleTime) {
            !self.avWriter.recordingProcessBlock ?: self.avWriter.recordingProcessBlock(recordTotalTime);
        }
        
        if (recordTotalTime > self.avWriter.maxTime) {
            if (isHandleTime) {
                [self.avWriter writingTimeOut];
            }
            CFRelease(sampleBuffer);
            return NO;
        }

        if (self.avWriter.writer.status == AVAssetWriterStatusWriting &&
            self.videoInput.readyForMoreMediaData) {
            [self.videoInput appendSampleBuffer:sampleBuffer];
            CFRelease(sampleBuffer);
            return YES;
        }
    }
    
    CFRelease(sampleBuffer);
    return NO;
}

- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo *pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

@end
