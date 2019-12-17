//
//  HyTipStatus.m
//  DemoCode
//
//  Created by Hy on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipStatus.h"
#import "HyTipStatusView.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowTranslation.h"
#import "HyTipViewAnimationDismissTranslation.h"


@implementation HyTipStatus

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {

        if (![parameter isKindOfClass:NSString.class] || !((NSString *)parameter).length) {
            return ;
        }
        
        CGFloat naviHeight = 64;
        if ([self.forView(nil) respondsToSelector:NSSelectorFromString(@"safeAreaInsets")]) {
           if (@available(iOS 11.0, *)) {
               if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.top) {
                   naviHeight = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top + 44;
               }
           }
        }
           
        HyTipStatusView *tipStatusView = [HyTipStatusView tipStatusViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, naviHeight) text:parameter];
                  
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(tipStatusView, 0.0).responseForInTipViews(@[tipStatusView]);
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"top");
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowTranslation animationWithParameter:@"top" completion:completion];
          
        tipView.show(self.forView(nil), postion, animation);
        
        void (^dismiss)(void) = ^{
            id<HyTipViewAnimationProtocol> animation =
            [HyTipViewAnimationDismissTranslation animationWithParameter:@"top" completion:completion];
            tipView.dismiss(animation);
        };
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(),
                       dismiss);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        if (!self.showing(nil)) { return ; }
        
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissTranslation animationWithParameter:@"top" completion:completion];
        [self.tipView(nil) enumerateObjectsUsingBlock:^(UIView<HyTipViewProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.dismiss(animation);
        }];
    };
}

+ (NSArray<Class> *)tipViewOfContentViewClass {
    return @[HyTipStatusView.class];
}

@end
