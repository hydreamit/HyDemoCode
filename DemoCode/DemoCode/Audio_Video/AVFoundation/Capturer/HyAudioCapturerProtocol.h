//
//  HyAudioCaptureProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HyAVWriterProtocol.h"
#import <AVKit/AVKit.h>


NS_ASSUME_NONNULL_BEGIN
@protocol HyAVCaptureProtocol;
@protocol HyAudioCapturerProtocol <NSObject>

@property (nonatomic,weak) id<HyAVCaptureProtocol> avCapture;
@property (nonatomic,strong,readonly) AVCaptureDevice *audioDevice;
@property (nonatomic,strong,readonly) AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong,readonly) AVCaptureAudioDataOutput *audioOutput;
@property (nonatomic,copy) void(^didOutputBlock)(AVCaptureOutput *output,CMSampleBufferRef buffer, AVCaptureConnection *connection);

- (void)audioAuthWithStatusBlock:(void(^)(AVAuthorizationStatus status))block;

@end

NS_ASSUME_NONNULL_END
