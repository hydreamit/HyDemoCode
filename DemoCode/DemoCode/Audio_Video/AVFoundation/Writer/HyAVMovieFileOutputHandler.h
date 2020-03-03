//
//  HyAVMovieFileOutputHandler.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/16.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAVWriterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyAVMovieFileOutputHandler : NSObject <HyAVWriterProtocol>

+ (instancetype(^)(AVCaptureSession *session))handler;

@end

NS_ASSUME_NONNULL_END
