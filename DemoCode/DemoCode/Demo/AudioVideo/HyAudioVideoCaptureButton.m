//
//  HyAudioVideoCaptureButton.m
//  DemoCode
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioVideoCaptureButton.h"
#import <HyCategoriess/HyCategories.h>



@interface HyAudioVideoCaptureButton ()
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@end


@implementation HyAudioVideoCaptureButton

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        CGFloat centerXY = 35;
        CGFloat radius = (70 - 3) / 2.0;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerXY, centerXY) radius:radius startAngle:(-0.5f * M_PI) endAngle:(1.5f * M_PI) clockwise:YES];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
        _progressLayer.lineCap = kCALineCapSquare;//kCALineCapRound;
        _progressLayer.lineWidth = 3;
        _progressLayer.path = [path CGPath];
        _progressLayer.strokeEnd = 0;
        [self.layer addSublayer:_progressLayer];
        
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPressGes];

    } return self;
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    
    if (self.progress == 1) {
        return;
    }
    
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:{
            !self.longPressBlock ?: self.longPressBlock(NO);
            [UIView animateWithDuration:.25 animations:^{
                self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:nil];
        } break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            !self.longPressBlock ?: self.longPressBlock(YES);
            [UIView animateWithDuration:.25 animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:nil];
        }break;
        default:
        break;
    }
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress > 1) {
        progress = 1;
    }
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
    [self.progressLayer removeAllAnimations];
}


- (void)resetTransform {
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
