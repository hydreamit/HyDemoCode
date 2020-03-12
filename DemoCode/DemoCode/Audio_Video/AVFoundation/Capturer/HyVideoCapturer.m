//
//  HyVideoCapturer.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoCapturer.h"
#import "HyAVCaptureProtocol.h"
#import "HyVideoWriter.h"

@interface HyVideoCapturer ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureDevice *videoDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;

@property (nonatomic,assign) CMTime startTime;
@property (nonatomic,assign) CMTime lastTime;
@property (nonatomic,assign) CMTime timeOffset;
@property (nonatomic,assign) CGFloat recordTotalTime;
@end


@implementation HyVideoCapturer
@synthesize didOutputBlock = _didOutputBlock, avCapture = _avCapture, preViewLayer = _preViewLayer;
- (instancetype)init {
    if (self = [super init]) {
        
        self.videoDevice = [self captureDeviceWithPostion:AVCaptureDevicePositionBack];
        self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:NULL];
        self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [[self.videoOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [self.videoOutput setAlwaysDiscardsLateVideoFrames:NO];
        [self.videoOutput setSampleBufferDelegate:self queue:HyAVCapture_Queue];
        self.videoOutput.videoSettings =
        @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    }
    return self;
}

- (AVCaptureVideoPreviewLayer *)preViewLayer {
    if (!_preViewLayer){
        _preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.avCapture.session];
//        _preViewLayer.connection.videoOrientation = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo].videoOrientation;
        _preViewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//        _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _preViewLayer;
}

- (void)switchDevicePosition {
      CATransition *transition = CATransition.new;
      transition.type = @"oglFlip";
      transition.subtype = @"fromLeft";
      transition.duration = .75;
      [self.preViewLayer addAnimation:transition forKey:@""];
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                    (int64_t)(.1 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
          AVCaptureDevicePosition position =  self.videoInput.device.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
          self.videoDevice = [self captureDeviceWithPostion:position];
          AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:NULL];
          [self.avCapture.session beginConfiguration];
          [self.avCapture.session removeInput:self.videoInput];
          [self.avCapture.session addInput:videoInput];
          [self.avCapture.session commitConfiguration];
          self.videoInput = videoInput;
          [[self.videoOutput connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:AVCaptureVideoOrientationPortrait];
      });
}

- (AVCaptureDevice *)captureDeviceWithPostion:(AVCaptureDevicePosition)position{
    NSArray<AVCaptureDevice *> *devices;
    if (@available(iOS 10.0, *)){
        devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position].devices;
     } else {
         devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
     }
    AVCaptureDevice *captureDevice = devices.firstObject;
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}

- (void)captureOutput:(AVCaptureOutput *)output
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {

    !self.didOutputBlock ?: self.didOutputBlock(output, sampleBuffer, connection);
    
    if (!self.avCapture.avWriter) {
        return;
    }
    
    if (!self.avCapture.avWriter.isAssetWriting) {
        return;
    }

    if (!self.avCapture.avWriter.videoWriter) {
//        NSDictionary* actualSettings = self.videoOutput.videoSettings;
//        NSInteger videoWidth = [[actualSettings objectForKey:@"Width"] integerValue];
//        NSInteger videoHeight = [[actualSettings objectForKey:@"Height"] integerValue];
        NSInteger videoWidth = self.avCapture.videoCapturer.preViewLayer.bounds.size.width;
        NSInteger videoHeight = self.avCapture.videoCapturer.preViewLayer.bounds.size.height;
        [self.avCapture.avWriter addVideoWriter:HyVideoWriter.videoWriter(videoWidth, videoHeight)];
    }

    CFRetain(sampleBuffer);
    [self.avCapture.avWriter.videoWriter encodeFrame:sampleBuffer];
    CFRelease(sampleBuffer);
}

- (void)videoAuthWithStatusBlock:(void (^)(AVAuthorizationStatus))block {
    __block AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
      switch (status) {
          case AVAuthorizationStatusNotDetermined:{
              [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                  if (granted) {
                      status = AVAuthorizationStatusAuthorized;
                  } else {
                      status = AVAuthorizationStatusDenied;
                  }
                  !block ?: block(status);
              }];
          }break;
          case AVAuthorizationStatusAuthorized:
          case AVAuthorizationStatusDenied:
          case AVAuthorizationStatusRestricted:
          break;
          default:
          break;
      }
      !block ?: block(status);
}

- (void)dealloc {
    [self.videoOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

@end
