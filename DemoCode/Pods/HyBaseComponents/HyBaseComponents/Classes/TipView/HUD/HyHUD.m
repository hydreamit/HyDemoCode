//
//  HyHUD.m
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyHUD.h"
#import "HyHUDView.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowNone.h"
#import "HyTipViewAnimationDismissFade.h"


@implementation HyHUD

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {
        
        if (self.showing(forView)) { return ; }
        
        HyHUDView *hudView = [[HyHUDView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(hudView, 0.0);
        
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"center");
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationShowNone animationWithParameter:nil completion:completion];

        tipView.show(self.forView(forView), postion, animation);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        if (!self.showing(forView)) { return ; }

        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissFade animationWithParameter:nil completion:completion];
        [self.tipView(forView) enumerateObjectsUsingBlock:^(UIView<HyTipViewProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            HyHUDView *hudView = (HyHUDView *)obj.contentView;
            [hudView stop];
            obj.dismiss(animation);

        }];
    };
}

+ (NSArray<Class> *)tipViewOfContentViewClass {
    return @[HyHUDView.class];
}

@end
