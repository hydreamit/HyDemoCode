//
//  HyVideoCaptureProtocol.h
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
@protocol HyVideoCapturerProtocol <NSObject>

@property (nonatomic,weak) id<HyAVCaptureProtocol> avCapture;
@property (nonatomic,strong,readonly) AVCaptureDevice *videoDevice;
@property (nonatomic,strong,readonly) AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong,readonly) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preViewLayer;

- (void)switchDevicePosition;

@property (nonatomic,copy) void(^didOutputBlock)(AVCaptureOutput *output,CMSampleBufferRef buffer, AVCaptureConnection *connection);

- (void)videoAuthWithStatusBlock:(void(^)(AVAuthorizationStatus status))block;

@end

NS_ASSUME_NONNULL_END
