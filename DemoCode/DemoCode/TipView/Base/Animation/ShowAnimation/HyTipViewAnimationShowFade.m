//
//  HyTipViewAnimationShowFade.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationShowFade.h"

@implementation HyTipViewAnimationShowFade

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        tipView.alpha = 0.0;
        [UIView animateWithDuration:.35 animations:^{
            tipView.alpha = 1.0;
        } completion:^(BOOL finished) {
            !self.completion ?: self.completion();
        }];
    };
}

@end
