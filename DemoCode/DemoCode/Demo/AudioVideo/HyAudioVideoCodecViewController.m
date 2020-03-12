//
//  HyAudioVideoCodecViewController.m
//  DemoCode
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioVideoCodecViewController.h"
#import <HyCategoriess/HyCategories.h>

#import "HyAVCapturer.h"
#import "HyAudioCapturer.h"
#import "HyVideoCapturer.h"

#import "HyAudioToolboxEncoder.h"
#import "HyAudioToolboxDecoder.h"
#import "HyVideoToolboxEncoder.h"
#import "HyVideoToolboxDecoder.h"
#import "HyOpenGLESVideoPlayer.h"


@interface HyAudioVideoCodecViewController ()
@property (nonatomic,strong) id<HyAVCaptureProtocol> avCapturer;
@property (nonatomic,strong) id<HyVideoEncoderProtocol> videoEncoder;
@property (nonatomic,strong) id<HyVideoDecoderProtocol> videoDecoder;
@property (nonatomic,strong) id<HyAudioEncoderProtocol> audioEncoder;
@property (nonatomic,strong) id<HyAudioDecoderProtocol> audioDecoder;
@property (nonatomic,strong) HyOpenGLESVideoPlayer *player;
@property (nonatomic,assign) CGFloat videoH;
@end


@implementation HyAudioVideoCodecViewController

- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.videoH = self.view.bounds.size.height / 3;
    
    CGFloat naviHeight = 64;
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
                naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
        }
    }
    
    UILabel *labelOne = UILabel.new;
    labelOne.text = @"录制 - H264 编码";
    labelOne.frame = CGRectMake(12, naviHeight, self.view.width, 50);
    [self.view addSubview:labelOne];
    
    UILabel *labelTwo = UILabel.new;
    labelTwo.text = @"解码 - 播放";
    labelTwo.frame = CGRectMake(12, naviHeight + self.videoH + 50, self.view.width, 50);
    [self.view addSubview:labelTwo];
    
    self.player =[[HyOpenGLESVideoPlayer alloc] initWithFrame:CGRectMake(0, labelTwo.bottom, self.view.bounds.size.width, self.videoH)];
    self.player.backgroundColor = self.view.backgroundColor.CGColor;
    [self.view.layer addSublayer:self.player];
    
    __weak typeof(self) _self = self;
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem hy_itemWithTitle:@"切换摄像头" style:UIBarButtonItemStyleDone actionBlock:^(UIBarButtonItem * _Nonnull item) {
        __strong typeof(_self) self = _self;
        [self.avCapturer.videoCapturer switchDevicePosition];
    }];
    
    [self.avCapturer startRunning];
}

- (id<HyAVCaptureProtocol>)avCapturer {
    if (!_avCapturer){
        
        __weak typeof(self) _self = self;
        _avCapturer = HyAVCapturer.new;
        
        id<HyAudioCapturerProtocol> audioCapture = HyAudioCapturer.new;
        audioCapture.didOutputBlock = ^(AVCaptureOutput * _Nonnull output, CMSampleBufferRef  _Nonnull sampleBuffer, AVCaptureConnection * _Nonnull connection) {
            __strong typeof(_self) self = _self;
            [self.audioEncoder codecWithSampleBuffer:sampleBuffer];
        };
        
        id<HyVideoCapturerProtocol> videoCapture = HyVideoCapturer.new;
        videoCapture.didOutputBlock = ^(AVCaptureOutput * _Nonnull output, CMSampleBufferRef  _Nonnull buffer, AVCaptureConnection * _Nonnull connection) {
            __strong typeof(_self) self = _self;
            [self.videoEncoder codecWithSampleBuffer:buffer];
        };
        
        [self.avCapturer addAudioCapturer:audioCapture];
        [self.avCapturer addVideoCapturer:videoCapture];
        
        CGFloat naviHeight = 64;
        if (@available(iOS 11.0, *)) {
           if ([[UIApplication sharedApplication].keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
                   naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
           }
        }
        videoCapture.preViewLayer.frame = CGRectMake(0, naviHeight + 50, self.view.bounds.size.width, self.videoH);
        videoCapture.preViewLayer.backgroundColor = UIColor.blackColor.CGColor;
        [self.view.layer insertSublayer:videoCapture.preViewLayer atIndex:0];
    }
    return _avCapturer;
}

- (id<HyVideoEncoderProtocol>)videoEncoder {
    if (!_videoEncoder){
        __weak typeof(self) _self = self;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"videoH264.h264"];
        _videoEncoder = [HyVideoToolboxEncoder codecWithConfigure:^(id<HyVideoConfigureProtocol>  _Nonnull configure) {
            configure.outFilePath = path;
            configure.encodeBlock = ^(NSData * _Nonnull codecData, H624DataType dataType) {
                __strong typeof(_self) self = _self;
                [self.videoDecoder codecWithNaluData:codecData];
            };
        }];
    }
    return _videoEncoder;
}

- (id<HyVideoDecoderProtocol>)videoDecoder {
    if (!_videoDecoder){
        __weak typeof(self) _self = self;
        _videoDecoder = [HyVideoToolboxDecoder codecWithConfigure:^(id<HyVideoConfigureProtocol>  _Nonnull configure) {
            configure.decodeBlock = ^(CVImageBufferRef  _Nonnull imageBuffer) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(_self) self = _self;
                    self.player.pixelBuffer = imageBuffer;
                    CVPixelBufferRelease(imageBuffer);
                });
            };
        }];
    }
    return _videoDecoder;
}

- (id<HyAudioEncoderProtocol>)audioEncoder {
    if (!_audioEncoder){
        __weak typeof(self) _self = self;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audioAAC.aac"];
        _audioEncoder = [HyAudioToolboxEncoder codecWithConfigure:^(id<HyAudioConfigureProtocol>  _Nonnull configure) {
            configure.outFilePath  = path;
            configure.codecBlock = ^(NSData * _Nonnull codecData) {
                __strong typeof(_self) self = _self;
                [self.audioDecoder codecWithAACData:codecData];
            };
        }];
    }
    return _audioEncoder;
}

- (id<HyAudioDecoderProtocol>)audioDecoder {
    if (!_audioDecoder){
         __weak typeof(self) _self = self;
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audioPCM.pcm"];
        _audioDecoder = [HyAudioToolboxDecoder codecWithConfigure:^(id<HyAudioConfigureProtocol>  _Nonnull configure) {
            configure.outFilePath = path;
            configure.codecBlock = ^(NSData * _Nonnull codecData) {
//                __strong typeof(_self) self = _self;
                
            };
        }];
    }
    return _audioDecoder;
}

- (void)dealloc {
    [self.avCapturer stopRunning];
}

@end
