//
//  HyAVCaptureProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioCapturerProtocol.h"
#import "HyVideoCapturerProtocol.h"
#import "HyAVWriterProtocol.h"


#define HyAVCapture_Queue dispatch_queue_create("com.hy.capture", DISPATCH_QUEUE_SERIAL)


NS_ASSUME_NONNULL_BEGIN

@protocol HyAVCaptureProtocol <NSObject>

@property (nonatomic,strong,readonly) AVCaptureSession *session;
@property (nonatomic,strong,readonly,nullable) id<HyAudioCapturerProtocol> audioCapturer;
@property (nonatomic,strong,readonly,nullable) id<HyVideoCapturerProtocol> videoCapturer;
- (void)addAudioCapturer:(id<HyAudioCapturerProtocol>)audioCapturer;
- (void)addVideoCapturer:(id<HyVideoCapturerProtocol>)videoCapturer;
- (void)startRunning;
- (void)stopRunning;


@property (nonatomic,strong) id<HyAVWriterProtocol> avWriter;


@end

NS_ASSUME_NONNULL_END
