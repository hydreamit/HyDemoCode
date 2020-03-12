//
//  HyAudioCapturer.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioWriter.h"
#import "HyAudioCapturer.h"
#import "HyAVCaptureProtocol.h"


@interface HyAudioCapturer ()<AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureDevice *audioDevice;
@property (nonatomic,strong) AVCaptureDeviceInput *audioInput;
@property (nonatomic,strong) AVCaptureAudioDataOutput *audioOutput;
@end


@implementation HyAudioCapturer
@synthesize didOutputBlock = _didOutputBlock, avCapture = _avCapture;
- (instancetype)init {
    if (self = [super init]) {
        self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        self.audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:NULL];
        self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [self.audioOutput setSampleBufferDelegate:self queue:HyAVCapture_Queue];
    }
    return self;
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
   
    if (!self.avCapture.avWriter.audioWriter) {
        CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
        const AudioStreamBasicDescription *asbd = CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
        Float64 sampleRate = asbd->mSampleRate;
        int audioChannels = asbd->mChannelsPerFrame;
        [self.avCapture.avWriter addAudioWriter:HyAudioWriter.audioWriter(audioChannels, sampleRate)];
    }
    
    CFRetain(sampleBuffer);
    [self.avCapture.avWriter.audioWriter encodeFrame:sampleBuffer];
    CFRelease(sampleBuffer);
}

- (void)audioAuthWithStatusBlock:(void (^)(AVAuthorizationStatus))block {
   __block AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
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
    [self.audioOutput setSampleBufferDelegate:nil queue:dispatch_get_main_queue()];
}

@end
