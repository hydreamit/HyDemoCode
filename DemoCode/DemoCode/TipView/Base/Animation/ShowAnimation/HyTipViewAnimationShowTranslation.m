//
//  HyTipViewAnimationShowTranslation.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationShowTranslation.h"
#import "HyTipViewProtocol.h"

@implementation HyTipViewAnimationShowTranslation

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        
        CGFloat translationX = 0;
        CGFloat translationY = 0;
        if ([self.parameter isKindOfClass:NSString.class]) {
             NSString *type = ((NSString *)self.parameter).lowercaseString;
            if ([type isEqualToString:@"top"]) {
                translationY = - CGRectGetMaxY(tipView.contentView.frame);
            } else if ([type isEqualToString:@"left"]) {
                translationX = - CGRectGetMaxX(tipView.contentView.frame);
            } else if ([type isEqualToString:@"bottom"]) {
                translationY = tipView.bounds.size.height - CGRectGetMinY(tipView.contentView.frame);
            } else if ([type isEqualToString:@"right"]) {
                translationX = tipView.bounds.size.width - CGRectGetMinX(tipView.contentView.frame);
            }
        }
        tipView.alpha = 0.0;
        tipView.contentView.layer.transform = CATransform3DMakeTranslation(translationX, translationY, 0);
        [UIView animateWithDuration:.5
                              delay:0
             usingSpringWithDamping:0.75
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
         tipView.alpha = 1.0;
         tipView.contentView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            !self.completion ?: self.completion();
        }];
    };
}

@end
