//
//  HyTipViewAnimationDismissTranslation.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationDismissTranslation.h"
#import "HyTipViewProtocol.h"

@implementation HyTipViewAnimationDismissTranslation

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
        [UIView animateWithDuration:.35 animations:^{
            tipView.alpha = 0.0;
            tipView.contentView.layer.transform = CATransform3DMakeTranslation(translationX, translationY, 0);
        } completion:^(BOOL finished) {
            [tipView removeFromSuperview];
            !self.completion ?: self.completion();
        }];
    };
}

@end
