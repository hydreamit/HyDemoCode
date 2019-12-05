//
//  HyTopTip.m
//  DemoCode
//
//  Created by huangyi on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTopTip.h"
#import "HyTopTipView.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowTranslation.h"
#import "HyTipViewAnimationDismissTranslation.h"


@interface HyTopTip ()
@property (nonatomic,weak) UIView<HyTipViewProtocol> *tipV;
@end

@implementation HyTopTip
+ (instancetype)tip {
    static HyTopTip *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self tip];
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
    
    HyTopTip *tip = [HyTopTip tip];
    
    if (tip.tipV) { return; }
    
    CGFloat naviHeight = 64;
    if ([[UIApplication sharedApplication].keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
        if (@available(iOS 11.0, *)) {
            naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
        }
    }
    
    HyTopTipView *topTipView = [HyTopTipView topTipViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, naviHeight + 44) text:parameter ?: @"刷新成功"];
               
    UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(topTipView, 0.0).responseForInTipViews(@[topTipView]);
    id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"top");
    id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowTranslation animationWithParameter:@"top" completion:completion];
       
    tipView.show(view, postion, animation);
       
    tip.tipV = tipView;
}

+ (void)dismissWithCompletion:(void (^)(void))completion {
    
    HyTopTip *tip = [HyTopTip tip];
    
    if (!tip.tipV) {return;}
   
    id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationDismissTranslation animationWithParameter:@"top" completion:completion];
    tip.tipV.dismiss(animation);
}

+ (UIView<HyTipViewProtocol> *)tipView {
    return [[self tip] tipV];
}

+ (BOOL)showing {
    return [[self tip] tipV] ? YES : NO;
}

@end
