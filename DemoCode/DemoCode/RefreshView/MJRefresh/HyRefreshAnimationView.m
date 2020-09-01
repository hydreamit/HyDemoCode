//
//  HyRefreshAnimationView.m
//  DemoCode
//
//  Created by Hy on 2017/12/10.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRefreshAnimationView.h"


#define CircleSizeWH  (self.layer.bounds.size.width / 3.5f)

@interface HyRefreshAnimationView ()
@property (nonatomic,assign) BOOL animating;
@property (nonatomic,strong) CAShapeLayer *circleA;
@property (nonatomic,strong) CAShapeLayer *circleB;
@property (nonatomic,strong) CAShapeLayer *circleC;

@property (nonatomic,assign) CGPoint centerPoint;
@property (nonatomic,assign) CGPoint pointA;
@property (nonatomic,assign) CGPoint pointB;
@property (nonatomic,assign) CGPoint pointC;
@property (nonatomic, assign) CGFloat percent;
@end


@implementation HyRefreshAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
                
        self.centerPoint = CGPointMake(self.layer.bounds.size.width / 2, self.layer.bounds.size.height / 2);
        self.pointA = CGPointMake(self.layer.bounds.size.width / 2, CircleSizeWH / 2);
        self.pointB = CGPointMake(CircleSizeWH / 2, self.layer.bounds.size.height - CircleSizeWH / 2);
        self.pointC = CGPointMake(self.layer.bounds.size.width - CircleSizeWH / 2, self.layer.bounds.size.height - CircleSizeWH / 2);

        self.circleA = [self createCircleLayerWithColor:UIColor.blueColor];
        self.circleB = [self createCircleLayerWithColor:UIColor.orangeColor];
        self.circleC = [self createCircleLayerWithColor:UIColor.greenColor];
        
        [self.layer addSublayer:self.circleA];
        [self.layer addSublayer:self.circleB];
        [self.layer addSublayer:self.circleC];
    }
    return self;
}

- (void)changeWithPercent:(CGFloat)percent {
    
    CGFloat handleP = percent;
    if (handleP > 1) {
        handleP = 1.0;
    }
    
    if (self.percent == percent) {
        return;
    }
    self.percent = percent;
    
    self.circleA.position = CGPointMake(self.centerPoint.x + (self.pointA.x - self.centerPoint.x) * handleP, self.centerPoint.y + (self.pointA.y - self.centerPoint.y) * handleP);
    
    self.circleB.position = CGPointMake(self.centerPoint.x + (self.pointB.x - self.centerPoint.x) * handleP, self.centerPoint.y + (self.pointB.y - self.centerPoint.y) * handleP);
    
    self.circleC.position = CGPointMake(self.centerPoint.x + (self.pointC.x - self.centerPoint.x) * handleP, self.centerPoint.y + (self.pointC.y - self.centerPoint.y) * handleP);
}

- (void)startAnimating {
    
    if (self.animating) {return;}
    self.animating = YES;
    
    [self.circleA addAnimation:[self animationWithValues:[self circleAAnimationValues]] forKey:@"animation"];
    [self.circleB addAnimation:[self animationWithValues:[self circleBAnimationValues]] forKey:@"animation"];
    [self.circleC addAnimation:[self animationWithValues:[self circleCAnimationValues]] forKey:@"animation"];
}

- (void)stopAnimating {
        
    [self.circleA removeAnimationForKey:@"animation"];
    [self.circleB removeAnimationForKey:@"animation"];
    [self.circleC removeAnimationForKey:@"animation"];
    
    self.animating = NO;
}

- (CAShapeLayer *)createCircleLayerWithColor:(UIColor *)color {
        
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CircleSizeWH, CircleSizeWH)];
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = path.CGPath;
    circle.bounds = CGRectMake(0, 0, CircleSizeWH, CircleSizeWH);
    circle.anchorPoint = CGPointMake(0.5f, 0.5f);
    circle.shouldRasterize = YES;
    circle.rasterizationScale = [[UIScreen mainScreen] scale];
    circle.fillColor = color.CGColor;
//    circle.strokeColor = color.CGColor;
    circle.position = self.centerPoint;
    return circle;
}

- (CAKeyframeAnimation *)animationWithValues:(NSArray *)values {
        
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.repeatCount = HUGE_VALF;
    transformAnimation.duration = 2.0f;
    transformAnimation.beginTime = CACurrentMediaTime();
    transformAnimation.keyTimes = @[@(0.0f), @(1.0f / 3.0f), @(2.0f / 3.0f), @(1.0)];

    transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    transformAnimation.values = values;
    return transformAnimation;
}

- (NSArray *)circleAAnimationValues {
    
     CATransform3D t1 = CATransform3DMakeTranslation(self.pointC.x - self.pointA.x, self.pointC.y - self.pointA.y, 0.0f);
    CATransform3D t2 = CATransform3DMakeTranslation(self.pointB.x - self.pointA.x, self.pointB.y - self.pointA.y, 0.0f);
    CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
    return @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
             [NSValue valueWithCATransform3D:t1],
             [NSValue valueWithCATransform3D:t2],
             [NSValue valueWithCATransform3D:t3]];
}

- (NSArray *)circleBAnimationValues {
    
    CATransform3D t1 = CATransform3DMakeTranslation(self.pointA.x - self.pointB.x, self.pointA.y - self.pointB.y, 0.0f);
    CATransform3D t2 = CATransform3DMakeTranslation(self.pointC.x - self.pointB.x, self.pointC.y - self.pointB.y, 0.0f);
    CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
    return @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
             [NSValue valueWithCATransform3D:t1],
             [NSValue valueWithCATransform3D:t2],
             [NSValue valueWithCATransform3D:t3]];
}

- (NSArray *)circleCAnimationValues {
    
    CATransform3D t1 = CATransform3DMakeTranslation(self.pointB.x - self.pointC.x, self.pointB.y - self.pointC.y, 0.0f);
    CATransform3D t2 = CATransform3DMakeTranslation(self.pointA.x - self.pointC.x, self.pointA.y - self.pointC.y, 0.0f);
    CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
    return @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
             [NSValue valueWithCATransform3D:t1],
             [NSValue valueWithCATransform3D:t2],
             [NSValue valueWithCATransform3D:t3]];
}

@end
