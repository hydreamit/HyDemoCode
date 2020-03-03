//
//  HyVideoTool.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyVideoTool : NSObject


+ (UIImage *_Nullable)thumbnailImageForVideo:(NSURL *)url atTime:(CGFloat)time;


+ (void)cropVideo:(NSURL *)url
        startTime:(CGFloat)startTime
          endTime:(CGFloat)endTime
        outputUrl:(NSURL *)outputURL
       completion:(void (^)(NSURL *outputURL, Float64 duration, BOOL isSuccess))completion;


@end

NS_ASSUME_NONNULL_END
