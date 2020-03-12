//
//  HyAudioVideoCaptureViewController.m
//  DemoCode
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioVideoCaptureViewController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyAVMovieFileOutputHandler.h"
#import "HyAVCapturer.h"
#import "HyAudioCapturer.h"
#import "HyVideoCapturer.h"
#import "HyAVWriter.h"
#import "HyAudioVideoCaptureButton.h"
#import "HyPhotoLibraryTool.h"
#import "HyTipText.h"


@interface HyAudioVideoCaptureViewController ()
@property (nonatomic,strong) id<HyAVCaptureProtocol> avCapturer;
@property (nonatomic,strong) NSURL *recordFileURL;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet HyAudioVideoCaptureButton *captureButton;
@end


@implementation HyAudioVideoCaptureViewController

- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    __weak typeof(self) _self = self;
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"captureTest.mp4"];
    self.recordFileURL = [NSURL fileURLWithPath:path];
    
    self.view.backgroundColor = UIColor.blackColor;
    self.captureButton.layer.cornerRadius = self.captureButton.width / 2;
    self.captureButton.longPressBlock = ^(BOOL end) {
        __strong typeof(_self) self = _self;
        if (end) {
            ShowTipText(@"暂停录制");
            [self.avCapturer.avWriter pauseRecording];
            [self.captureButton resetTransform];
            [UIView animateWithDuration:.25 animations:^{
                self.timeLabel.transform = CGAffineTransformIdentity;
            } completion:nil];
        } else {
            
            if (self.captureButton.progress < 10) {
                [UIView animateWithDuration:.25 animations:^{
                    self.timeLabel.transform = CGAffineTransformMakeScale(1.35, 1.35);
                } completion:nil];
            }
            
            if (self.captureButton.progress > 0 && self.captureButton.progress < 10) {
                ShowTipText(@"继续录制");
                [self.avCapturer.avWriter resumeRecording];
            }
            if (self.captureButton.progress == 0) {
                ShowTipText(@"开始录制");
                [self.avCapturer.avWriter startRecordingWithURL:self.recordFileURL time:10 completionHandler:nil];
            }
        }
    };
    
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem hy_itemWithTitle:@"切换摄像头" style:UIBarButtonItemStyleDone actionBlock:^(UIBarButtonItem * _Nonnull item) {
        __strong typeof(_self) self = _self;
        [self.avCapturer.videoCapturer switchDevicePosition];
    }];
}

- (void)hy_viewWillAppear:(BOOL)animated firstLoad:(BOOL)flag {
    [super hy_viewWillAppear:animated firstLoad:flag];
    
    if (flag) {
        [self.avCapturer startRunning];
    }
}

- (IBAction)saveBtnAction:(id)sender {
    if (self.captureButton.progress > 0) {
         __weak typeof(self) _self = self;
        [self.avCapturer.avWriter stopRceordingWithCompletionHandler:^(NSURL * _Nonnull fileUrl) {
            __strong typeof(_self) self = _self;
            [HyPhotoLibraryTool saveVideoWithUrl:self.recordFileURL assetName:nil completion:^(NSURL * _Nonnull vedioUrl, NSError * _Nonnull error) {
                __strong typeof(_self) self = _self;
                [self cancenBtnAction:nil];
                if (!error) {
                     ShowTipText(@"保存成功");
                }
            }];
        }];
    }
}

- (IBAction)cancenBtnAction:(id)sender {
    if (self.captureButton.progress > 0) {
        ShowTipText(@"取消录制");
        [self.avCapturer.avWriter stopRceordingWithCompletionHandler:nil];
        [self.captureButton resetTransform];
        self.captureButton.progress = 0;
        self.timeLabel.text = @"";
        self.timeLabel.transform = CGAffineTransformIdentity;
        [[NSFileManager defaultManager] removeItemAtPath:self.recordFileURL.path error:nil];
    }
}

- (id<HyAVCaptureProtocol>)avCapturer {
    if (!_avCapturer){
        
        __weak typeof(self) _self = self;
        _avCapturer = HyAVCapturer.new;
        
        id<HyAudioCapturerProtocol> audioCapture = HyAudioCapturer.new;
        id<HyVideoCapturerProtocol> videoCapture = HyVideoCapturer.new;
        
        videoCapture.didOutputBlock = ^(AVCaptureOutput * _Nonnull output, CMSampleBufferRef  _Nonnull buffer, AVCaptureConnection * _Nonnull connection) {
            __strong typeof(_self) self = _self;
            CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(buffer);
            CIImage *ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
            UIImage *image = [UIImage imageWithCIImage:ciImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        };
        
        [self.avCapturer addAudioCapturer:audioCapture];
        [self.avCapturer addVideoCapturer:videoCapture];
        
        CGFloat naviHeight = 64;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication].keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
                    naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
            }
        }
        videoCapture.preViewLayer.frame = CGRectMake(0, naviHeight, self.view.width, self.view.height - naviHeight);
        videoCapture.preViewLayer.backgroundColor = UIColor.blackColor.CGColor;
        videoCapture.preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer insertSublayer:videoCapture.preViewLayer atIndex:0];
        
        //    self.avCapturer.avWriter = HyAVMovieFileOutputHandler.handler(self.avCapturer.session);
        self.avCapturer.avWriter = HyAVWriter.new;
        self.avCapturer.avWriter.recordingProcessBlock = ^(NSTimeInterval time) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(_self) self = _self;
                NSTimeInterval handleTime = time;
                if (handleTime > 10) {
                    handleTime = 10;
                }
                self.timeLabel.text = [NSString stringWithFormat:@"%.1f S", handleTime];
                self.captureButton.progress = handleTime / 10;
            });
        };
    }
    return _avCapturer;
}

- (void)dealloc {
    [self.avCapturer stopRunning];
}

@end
