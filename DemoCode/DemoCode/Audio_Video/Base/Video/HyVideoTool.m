//
//  HyVideoTool.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoTool.h"
#import <AVFoundation/AVFoundation.h>


@implementation HyVideoTool

+ (UIImage *)thumbnailImageForVideo:(NSURL *)url atTime:(CGFloat)time {
        
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
  
    CMTime cmTime = urlAsset.duration;
    
    Float64 totalTime = CMTimeGetSeconds(cmTime);
    if (time > totalTime) {
        return nil;
    }
    
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
  
    NSError *error = nil;
    CMTime requestTime = CMTimeMakeWithSeconds(time, cmTime.timescale);
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if(error) {
        return nil;
    }
    
    CMTimeShow(actualTime);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return image;
}

+ (void)cropVideo:(NSURL *)url
        startTime:(CGFloat)startTime
          endTime:(CGFloat)endTime
        outputUrl:(NSURL *)outputURL
       completion:(void (^)(NSURL *outputURL, Float64 duration, BOOL isSuccess))completion {
    
    if (endTime - startTime >= 0) {
        return;
    }
    
    if (!outputURL) { return; }
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
 
    Float64 duration = CMTimeGetSeconds(asset.duration);
    if (endTime > duration) {
        endTime = duration;
    }
    if (startTime > duration) {
        return;
    }

    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        
        AVAssetExportSession *exportSession =
        [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];

        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (completion) {
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"合成失败：%@", [[exportSession error] description]);
                        completion(outputURL, endTime, NO);
                    } break;
                    case AVAssetExportSessionStatusCancelled: {
                        completion(outputURL, endTime, NO);
                    } break;
                    case AVAssetExportSessionStatusCompleted: {
                        completion(outputURL, endTime, YES);
                    }  break;
                    default: {
                        completion(outputURL, endTime, NO);
                    } break;
                }
            }
        }];
    }
}


@end
