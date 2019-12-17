//
//  HyTipViewAnimationShowScale.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationShowScale.h"
#import "HyTipViewProtocol.h"

@implementation HyTipViewAnimationShowScale

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        CGFloat x = 1.0;
        CGFloat y = 1.0;
        NSTimeInterval duration = .5;
        if ([self.parameter isKindOfClass:NSString.class]) {
             NSString *type = ((NSString *)self.parameter).lowercaseString;
            if ([type isEqualToString:@"x"]) {
                x = 0.0;
            } else if ([type isEqualToString:@"y"]) {
                y = 0.0;
            } else if ([type isEqualToString:@"xy"]) {
                x = 0.5;
                y = 0.5;
                duration = .4;
            }
        }
        
         tipView.alpha = 0.0;
         tipView.contentView.layer.transform = CATransform3DMakeScale(x, y, 1);
         [UIView animateWithDuration:duration
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
