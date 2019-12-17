//
//  HyTipViewAnimationDismissScale.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationDismissScale.h"
#import "HyTipViewProtocol.h"


@implementation HyTipViewAnimationDismissScale

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        CGFloat x = 1.0;
        CGFloat y = 1.0;
        NSTimeInterval duration = .35;
        if ([self.parameter isKindOfClass:NSString.class]) {
             NSString *type = ((NSString *)self.parameter).lowercaseString;
            if ([type isEqualToString:@"x"]) {
                x = 0.1;
            } else if ([type isEqualToString:@"y"]) {
                y = 0.1;
            } else if ([type isEqualToString:@"xy"]) {
                x = 0.7;
                y = 0.7;
                duration = .25;
            }
        }
        
        [UIView animateWithDuration:duration animations:^{
            tipView.alpha = 0.0;
            tipView.contentView.layer.transform = CATransform3DMakeScale(x, y, 1);
        } completion:^(BOOL finished) {
            [tipView removeFromSuperview];
            !self.completion ?: self.completion();
        }];
    };
}

@end
