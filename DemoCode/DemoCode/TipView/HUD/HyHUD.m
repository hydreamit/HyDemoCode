//
//  HyHUD.m
//  DemoCode
//
//  Created by huangyi on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyHUD.h"
#import "HyHUDView.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowNone.h"
#import "HyTipViewAnimationDismissNone.h"


@implementation HyHUD

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {
        
        if (self.tipView(forView)) { return ; }
        
        HyHUDView *hudView = [[HyHUDView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(hudView, 0.0);
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"center");
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationShowNone animationWithParameter:nil completion:completion];

        tipView.show(forView, postion, animation);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        UIView<HyTipViewProtocol> *tipView = self.tipView(forView);
        
        if (!tipView) { return ; }
        
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissNone animationWithParameter:nil completion:completion];
        tipView.dismiss(animation);
    };
}

@end
