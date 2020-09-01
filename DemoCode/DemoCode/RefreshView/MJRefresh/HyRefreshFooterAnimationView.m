//
//  HyRefreshFooterAnimationView.m
//  BTCC_Pro
//
//  Created by huangyi on 2020/8/16.
//  Copyright © 2020 BTCC_Pro. All rights reserved.
//

#import "HyRefreshFooterAnimationView.h"


@interface HyRefreshFooterAnimationView ()<CAAnimationDelegate>
@property (nonatomic,strong) UIView *ballOne;
@property (nonatomic,strong) UIView *ballTwo;
@property (nonatomic,strong) UIView *ballThree;
@property (nonatomic,assign) BOOL animating;
@end

@implementation HyRefreshFooterAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{

    CGFloat ballWidth = 10.0f;
    
    _ballOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballOne.center = CGPointMake(ballWidth/2.0f , self.bounds.size.height/2.0f);
    _ballOne.layer.cornerRadius = ballWidth/2.0f;
    _ballOne.backgroundColor = UIColor.orangeColor;
    [self addSubview:_ballOne];
    
    _ballTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballTwo.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _ballTwo.layer.cornerRadius = ballWidth/2.0f;
    _ballTwo.backgroundColor = UIColor.greenColor;
    [self addSubview:_ballTwo];
    
    _ballThree = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ballThree.center = CGPointMake(self.bounds.size.width - ballWidth/2.0f , self.bounds.size.height/2.0f);
    _ballThree.layer.cornerRadius = ballWidth/2.0f;
    _ballThree.backgroundColor = UIColor.blueColor ;
    [self addSubview:_ballThree];
}

-(void)startPathAnimate{
    
//    UIBezierPath *path = UIBezierPath.bezierPath;
//    [path appendPath:self.leftTopPath];
//    [path appendPath:self.rightBottomPath];
//    [path appendPath:self.rightTopPath];
//    [path appendPath:self.leftBottomPath];
//
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.path = path.CGPath;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.duration = [self animationDuration] * 4;
//    animation.removedOnCompletion = NO;
//    animation.delegate = self;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [_ballOne.layer addAnimation:animation forKey:nil];
//
//    CAKeyframeAnimation *leftBottom_two = [self animationWithPath:self.leftBottomPath];
//    CAKeyframeAnimation *topLeft_two = [self animationWithPath:self.leftTopPath];
//    topLeft_two.beginTime = CACurrentMediaTime() + [self animationDuration] * 3;
//    [_ballTwo.layer addAnimation:leftBottom_two forKey:nil];
//    [_ballTwo.layer addAnimation:topLeft_two forKey:nil];
//
//    UIBezierPath *pathThree = UIBezierPath.bezierPath;
//    [pathThree appendPath:self.rightTopPath];
//    [pathThree appendPath:self.rightBottomPath];
//    CAKeyframeAnimation *animationThree = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animationThree.path = pathThree.CGPath;
//    animationThree.removedOnCompletion = NO;
//    animationThree.fillMode = kCAFillModeForwards;
//    animationThree.duration = [self animationDuration] * 2;
//    animationThree.removedOnCompletion = NO;
//    animationThree.beginTime = CACurrentMediaTime() + [self animationDuration];
//    animationThree.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [_ballThree.layer addAnimation:animationThree forKey:nil];
//
    
    
    CAKeyframeAnimation *topLeft_one = [self animationWithPath:self.leftTopPath];
    CAKeyframeAnimation *rightBottom_one = [self animationWithPath:self.rightBottomPath];
    rightBottom_one.beginTime = CACurrentMediaTime() + [self animationDuration];
    CAKeyframeAnimation *rightTop_one = [self animationWithPath:self.rightTopPath];
    rightTop_one.beginTime = CACurrentMediaTime() + [self animationDuration] * 3;
    CAKeyframeAnimation *leftBottom_one = [self animationWithPath:self.leftBottomPath];
    leftBottom_one.beginTime = CACurrentMediaTime() + [self animationDuration] * 4;

    [_ballOne.layer removeAllAnimations];
    [_ballOne.layer addAnimation:topLeft_one forKey:nil];
    [_ballOne.layer addAnimation:rightBottom_one forKey:nil];
    [_ballOne.layer addAnimation:rightTop_one forKey:nil];
    [_ballOne.layer addAnimation:leftBottom_one forKey:nil];

    CAKeyframeAnimation *leftBottom_two = [self animationWithPath:self.leftBottomPath];

    CAKeyframeAnimation *topLeft_two = [self animationWithPath:self.leftTopPath];
    topLeft_two.beginTime = CACurrentMediaTime() + [self animationDuration] * 2;

    CAKeyframeAnimation *rightBottom_two = [self animationWithPath:self.rightBottomPath];
    rightBottom_two.beginTime = CACurrentMediaTime() + [self animationDuration] * 3;

    CAKeyframeAnimation *rightTop_two = [self animationWithPath:self.rightTopPath];
    rightTop_two.beginTime = CACurrentMediaTime() + [self animationDuration] * 5;

    [_ballTwo.layer removeAllAnimations];
    [_ballTwo.layer addAnimation:leftBottom_two forKey:nil];
    [_ballTwo.layer addAnimation:topLeft_two forKey:nil];
    [_ballTwo.layer addAnimation:rightBottom_two forKey:nil];
    [_ballTwo.layer addAnimation:rightTop_two forKey:nil];

    CAKeyframeAnimation *rightTop_three = [self animationWithPath:self.rightTopPath];
    rightTop_three.beginTime = CACurrentMediaTime() + [self animationDuration];

    CAKeyframeAnimation *leftBottom_three = [self animationWithPath:self.leftBottomPath];
    leftBottom_three.beginTime = CACurrentMediaTime() + [self animationDuration] * 2;

    CAKeyframeAnimation *topLeft_three= [self animationWithPath:self.leftTopPath];
    topLeft_three.beginTime = CACurrentMediaTime() + [self animationDuration] * 4;

    CAKeyframeAnimation *rightBottom_three = [self animationWithPath:self.rightBottomPath];
    rightBottom_three.beginTime = CACurrentMediaTime() + [self animationDuration] * 5;
    rightBottom_three.delegate = self;

    [_ballThree.layer removeAllAnimations];
    [_ballThree.layer addAnimation:rightTop_three forKey:nil];
    [_ballThree.layer addAnimation:leftBottom_three forKey:nil];
    [_ballThree.layer addAnimation:topLeft_three forKey:nil];
    [_ballThree.layer addAnimation:rightBottom_three forKey:nil];
}

- (CAKeyframeAnimation *)animationWithPath:(UIBezierPath *)path {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = [self animationDuration];
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

- (UIBezierPath *)leftTopPath {
    
    CGFloat ballWidth = 10.0f;
    CGFloat radiusX = (self.bounds.size.width - ballWidth) / 4;
    CGFloat radiusY = ballWidth / 2;
    CGPoint center = CGPointMake(ballWidth / 2 + radiusX, self.bounds.size.height / 2);
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 =
    CGAffineTransformConcat(CGAffineTransformConcat(
    CGAffineTransformMakeTranslation(-center.x, -center.y),
    CGAffineTransformMakeScale(1, radiusY / radiusX)),
    CGAffineTransformMakeTranslation(center.x, center.y));
    CGPathAddArc(ovalfromarc, &t2, center.x, center.y, radiusX, M_PI, M_PI * 2, 0);
    return [UIBezierPath bezierPathWithCGPath:ovalfromarc];
}

- (UIBezierPath *)leftBottomPath {
    
    CGFloat ballWidth = 10.0f;
    CGFloat radiusX = (self.bounds.size.width - ballWidth) / 4;
    CGFloat radiusY = ballWidth / 2;
    CGPoint center = CGPointMake(ballWidth / 2 + radiusX, self.bounds.size.height / 2);
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 =
    CGAffineTransformConcat(CGAffineTransformConcat(
    CGAffineTransformMakeTranslation(-center.x, -center.y),
    CGAffineTransformMakeScale(1, radiusY / radiusX)),
    CGAffineTransformMakeTranslation(center.x, center.y));
    CGPathAddArc(ovalfromarc, &t2, center.x, center.y, radiusX, 0, M_PI , 0);
    return [UIBezierPath bezierPathWithCGPath:ovalfromarc];
}

- (UIBezierPath *)rightTopPath {
    
    CGFloat ballWidth = 10.0f;
    CGFloat radiusX = (self.bounds.size.width - ballWidth) / 4;
    CGFloat radiusY = ballWidth / 2;
    CGPoint center = CGPointMake(self.bounds.size.width / 2 + radiusX, self.bounds.size.height / 2);
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 =
    CGAffineTransformConcat(CGAffineTransformConcat(
    CGAffineTransformMakeTranslation(-center.x, -center.y),
    CGAffineTransformMakeScale(1, radiusY / radiusX)),
    CGAffineTransformMakeTranslation(center.x, center.y));
    CGPathAddArc(ovalfromarc, &t2, center.x, center.y, radiusX, M_PI * 2, M_PI, 1);
    return [UIBezierPath bezierPathWithCGPath:ovalfromarc];
}

- (UIBezierPath *)rightBottomPath {
    
    CGFloat ballWidth = 10.0f;
    CGFloat radiusX = (self.bounds.size.width - ballWidth) / 4;
    CGFloat radiusY = ballWidth / 2;
    CGPoint center = CGPointMake(self.bounds.size.width / 2 + radiusX, self.bounds.size.height / 2);
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 =
    CGAffineTransformConcat(CGAffineTransformConcat(
    CGAffineTransformMakeTranslation(-center.x, -center.y),
    CGAffineTransformMakeScale(1, radiusY / radiusX)),
    CGAffineTransformMakeTranslation(center.x, center.y));
    CGPathAddArc(ovalfromarc, &t2, center.x, center.y, radiusX, M_PI, 0, 1);
    return [UIBezierPath bezierPathWithCGPath:ovalfromarc];
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animating) {
       [self startPathAnimate];
    }
}

- (CGFloat)animationDuration {
    return 0.5f;
}

- (void)startAnimating {
    if (self.animating) {return;}
    self.animating = YES;
    [self startPathAnimate];
}

- (void)stopAnimating {
   [self.ballOne.layer removeAllAnimations];
   [self.ballTwo.layer removeAllAnimations];
   [self.ballThree.layer removeAllAnimations];
    self.animating = NO;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
