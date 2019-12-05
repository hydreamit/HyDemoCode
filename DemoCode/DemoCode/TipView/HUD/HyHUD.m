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


@interface HyHUD ()
@property (nonatomic,weak) UIView<HyTipViewProtocol> *tipV;
@end


@implementation HyHUD
+ (instancetype)hud {
    static HyHUD *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self hud];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (void)showToView:(UIView *)view
         parameter:(nullable id)parameter
        completion:(void(^)(void))completion {
    
    HyHUD *hud = [HyHUD hud];
    
    if (hud.tipV) {return;}
    
    HyHUDView *hudView = [[HyHUDView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(hudView, 0.0);
    id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"center");
    id<HyTipViewAnimationProtocol> animation =
    [HyTipViewAnimationShowNone animationWithParameter:nil completion:completion];
    
    tipView.show(view, postion, animation);
        
    hud.tipV = tipView;
}

+ (void)dismissWithCompletion:(void (^)(void))completion {
    
    HyHUD *hud = [HyHUD hud];
    
    if (!hud.tipV) {return;}
   
    id<HyTipViewAnimationProtocol> animation =
    [HyTipViewAnimationDismissNone animationWithParameter:nil completion:completion];
    hud.tipV.dismiss(animation);
}

+ (UIView<HyTipViewProtocol> *)tipView {
    return [[self hud] tipV];
}

+ (BOOL)showing {
    return [[self hud] tipV] ? YES : NO;
}

@end
