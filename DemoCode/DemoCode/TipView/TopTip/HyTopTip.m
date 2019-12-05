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


@implementation HyTopTip

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {
        
        if (self.tipView(forView)) { return ; }
        
        CGFloat naviHeight = 64;
        if ([[UIApplication sharedApplication].keyWindow respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
           if (@available(iOS 11.0, *)) {
               if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.top) {
                   naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
               }
           }
        }
           
        HyTopTipView *topTipView = [HyTopTipView topTipViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, naviHeight + 44) text:parameter ?: @"刷新成功"];
                  
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(topTipView, 0.0).responseForInTipViews(@[topTipView]);
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"top");
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowTranslation animationWithParameter:@"top" completion:completion];
          
        tipView.show(forView, postion, animation);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        UIView<HyTipViewProtocol> *tipView = self.tipView(forView);
        
        if (!tipView) { return ; }
        
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissTranslation animationWithParameter:@"top" completion:completion];
        tipView.dismiss(animation);
    };
}

@end
