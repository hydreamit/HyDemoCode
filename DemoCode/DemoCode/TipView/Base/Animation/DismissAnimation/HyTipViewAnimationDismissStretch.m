//
//  HyTipViewAnimationDismissStretch.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationDismissStretch.h"
#import "HyTipViewProtocol.h"


@implementation HyTipViewAnimationDismissStretch

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        
        if (![self.parameter isKindOfClass:NSString.class]) {
            [tipView removeFromSuperview];
            !self.completion ?: self.completion();
            return ;
        }
        
        NSString *type = ((NSString *)self.parameter).lowercaseString;
        if (![type isEqualToString:@"top"] &&
            ![type isEqualToString:@"left"] &&
            ![type isEqualToString:@"bottom"] &&
            ![type isEqualToString:@"right"]) {
            [tipView removeFromSuperview];
            !self.completion ?: self.completion();
            return ;
        }
        
        CABasicAnimation *translationAnimation;
        CABasicAnimation *scaleAnimation;
        
        if ([type isEqualToString:@"top"] ) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            translationAnimation.toValue  = [NSNumber numberWithFloat:(-tipView.contentView.bounds.size.height / 2)]; ;
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0];
        } else if ([type isEqualToString:@"left"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translationAnimation.toValue  = [NSNumber numberWithFloat:(-tipView.contentView.bounds.size.width / 2)]; ;
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0];
            
        } else if ([type isEqualToString:@"bottom"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
            translationAnimation.toValue  = [NSNumber numberWithFloat:(tipView.contentView.bounds.size.height / 2)]; ;
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0];
            
        } else if ([type isEqualToString:@"right"]) {
            
            translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
            translationAnimation.toValue  = [NSNumber numberWithFloat:(tipView.contentView.bounds.size.width / 2)]; ;
            
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
            scaleAnimation.toValue = [NSNumber numberWithFloat:0];
        }

        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = @[translationAnimation , scaleAnimation];
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.duration = .35;
        animGroup.removedOnCompletion = YES;
        [tipView.contentView.layer addAnimation:animGroup forKey:@"dismissStretch"];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
        opacityAnimation.repeatCount = 1;
        opacityAnimation.duration = .35;
        [tipView.layer addAnimation:opacityAnimation forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(.3 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [tipView removeFromSuperview];
            !self.completion ?: self.completion();
        });
    };
}

@end
