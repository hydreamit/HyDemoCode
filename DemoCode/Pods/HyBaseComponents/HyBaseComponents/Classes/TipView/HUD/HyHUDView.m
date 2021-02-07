//
//  HyHUDView.m
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyHUDView.h"

static CGFloat ballScale = 1.35f;

@interface HyHUDView () <CAAnimationDelegate>
@property (nonatomic,strong) UIView *ballOne;
@property (nonatomic,strong) UIView *ballTwo;
@property (nonatomic,strong) UIView *ballThree;
@property (nonatomic,assign) BOOL stopAnimationByUser;
@property (nonatomic,copy) void(^stopCompletion)(void);
@end

@implementation HyHUDView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self start];
    }
    return self;
}

-(void)initUI{

    CGFloat ballWidth = 10.0f;
    CGFloat margin = 5.0f;
    
    _ballOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballOne.center = CGPointMake(ballWidth/2.0f + margin, self.bounds.size.height/2.0f);
    _ballOne.layer.cornerRadius = ballWidth/2.0f;
    _ballOne.backgroundColor = UIColor.orangeColor;
    [self addSubview:_ballOne];
    
    _ballTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballTwo.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _ballTwo.layer.cornerRadius = ballWidth/2.0f;
    _ballTwo.backgroundColor = UIColor.greenColor;
    [self addSubview:_ballTwo];
    
    _ballThree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballThree.center = CGPointMake(self.bounds.size.width - ballWidth/2.0f - margin, self.bounds.size.height/2.0f);
    _ballThree.layer.cornerRadius = ballWidth/2.0f;
    _ballThree.backgroundColor = UIColor.blueColor ;
    [self addSubview:_ballThree];
}

-(void)startPathAnimate{
    
  
    CGFloat width = self.bounds.size.width;
    CGFloat r = (_ballOne.bounds.size.width)*ballScale/2.0f;
    CGFloat R = (width/2 + r)/2.0;
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:_ballOne.center];
    [path1 addArcWithCenter:CGPointMake(R + r, width/2) radius:R startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
  
    UIBezierPath *path1_1 = [UIBezierPath bezierPath];
    [path1_1 addArcWithCenter:CGPointMake(width/2, width/2) radius:r*2 startAngle:M_PI*2 endAngle:M_PI clockwise:NO];
    [path1 appendPath:path1_1];
 
    [path1 addLineToPoint:_ballOne.center];
  
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.path = path1.CGPath;
    animation1.removedOnCompletion = YES;
    animation1.duration = [self animationDuration];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_ballOne.layer addAnimation:animation1 forKey:@"animation1"];
    
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:_ballThree.center];
    [path3 addArcWithCenter:CGPointMake(width - (R + r), width/2) radius:R startAngle:2*M_PI endAngle:M_PI clockwise:NO];
 
    UIBezierPath *path3_1 = [UIBezierPath bezierPath];
    [path3_1 addArcWithCenter:CGPointMake(width/2, width/2) radius:r*2 startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [path3 appendPath:path3_1];
    [path3 addLineToPoint:_ballThree.center];

    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.path = path3.CGPath;
    animation3.removedOnCompletion = YES;
    animation3.duration = [self animationDuration];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation3.delegate = self;
    [_ballThree.layer addAnimation:animation3 forKey:@"animation3"];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
    CGFloat delay = 0.3f;
    CGFloat duration = [self animationDuration]/2 - delay;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut|
                                UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        self.ballOne.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        self.ballTwo.transform = CGAffineTransformMakeScale(ballScale, ballScale);
        self.ballThree.transform = CGAffineTransformMakeScale(ballScale, ballScale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseInOut|
                                    UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.ballOne.transform = CGAffineTransformIdentity;
            self.ballTwo.transform = CGAffineTransformIdentity;
            self.ballThree.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.stopAnimationByUser) {
        return;
    }
    [self startPathAnimate];
}

- (CGFloat)animationDuration {
    return 1.5f;
}

- (void)start {
    [self startPathAnimate];
    self.stopAnimationByUser = false;
}

- (void)stop {
    self.stopAnimationByUser = true;
   [self.ballOne.layer removeAllAnimations];
   [self.ballOne removeFromSuperview];
   [self.ballTwo.layer removeAllAnimations];
   [self.ballTwo removeFromSuperview];
   [self.ballThree.layer removeAllAnimations];
   [self.ballThree removeFromSuperview];
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        view.color = UIColor.orangeColor;
////        CGFloat scale = frame.size.width / view.bounds.size.width;
////        view.transform = CGAffineTransformMakeScale(scale, scale);
//        [self addSubview:view];
//        view.frame = self.bounds;
//        [view startAnimating];
//    }
//    return self;
//}


- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
