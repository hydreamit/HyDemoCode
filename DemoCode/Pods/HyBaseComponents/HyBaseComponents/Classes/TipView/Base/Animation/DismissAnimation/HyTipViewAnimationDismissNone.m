//
//  HyTipViewAnimationDismissNone.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimationDismissNone.h"
#import "HyTipViewProtocol.h"

@implementation HyTipViewAnimationDismissNone

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        [tipView removeFromSuperview];
        !self.completion ?: self.completion();
    };
}

@end
