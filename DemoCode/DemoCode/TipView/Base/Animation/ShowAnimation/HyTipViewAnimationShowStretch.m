//
//  HyTipViewAnimationShowStretch.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationShowStretch.h"
#import "HyTipViewProtocol.h"

@implementation HyTipViewAnimationShowStretch

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        

        
        if (![self.parameter isKindOfClass:NSString.class]) {
            !self.completion ?: self.completion();
            return ;
        }
        NSString *type = ((NSString *)self.parameter).lowercaseString;
        if (![type isEqualToString:@"top"] &&
            ![type isEqualToString:@"left"] &&
            ![type isEqualToString:@"bottom"] &&
            ![type isEqualToString:@"right"] ) {
            !self.completion ?: self.completion();
            return ;
        }
        
        CABasicAnimation *translationAnimation;
        CABasicAnimation *scaleAnimation;
        
        if ([type isEqualToString:@"top"] ) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            translationAnimation.fromValue  = [NSNumber numberWithFloat:(-tipView.contentView.bounds.size.height / 2)]; ;
            translationAnimation.toValue    = [NSNumber numberWithFloat:0];
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            
        } else if ([type isEqualToString:@"left"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translationAnimation.fromValue  = [NSNumber numberWithFloat:(-tipView.contentView.bounds.size.width / 2)]; ;
            translationAnimation.toValue    = [NSNumber numberWithFloat:0];
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            
        } else if ([type isEqualToString:@"bottom"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            translationAnimation.fromValue  = [NSNumber numberWithFloat:(tipView.contentView.bounds.size.height / 2)]; ;
            translationAnimation.toValue    = [NSNumber numberWithFloat:0];
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
            
        } else if ([type isEqualToString:@"right"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translationAnimation.fromValue  = [NSNumber numberWithFloat:(tipView.contentView.bounds.size.width / 2)]; ;
            translationAnimation.toValue    = [NSNumber numberWithFloat:0];
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
            scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        }

        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = @[translationAnimation , scaleAnimation];
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.duration = .35;
        animGroup.removedOnCompletion = YES;
        [tipView.contentView.layer addAnimation:animGroup forKey:@"showStretch"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
       opacityAnimation.fromValue  = [NSNumber numberWithFloat:0.0f];
       opacityAnimation.toValue  = [NSNumber numberWithFloat:1.0f];
       opacityAnimation.repeatCount = 1;
       opacityAnimation.duration = .35;
       [tipView.layer addAnimation:opacityAnimation forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(.35 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            !self.completion ?: self.completion();
        });
    };
}

@end
