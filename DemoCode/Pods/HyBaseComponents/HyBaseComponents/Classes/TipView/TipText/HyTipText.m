//
//  HyTipText.m
//  DemoCode
//
//  Created by Hy on 2017/12/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipText.h"
#import "HyTipTextView.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowScale.h"
#import "HyTipViewAnimationShowFade.h"
#import "HyTipViewAnimationDismissScale.h"


@implementation HyTipText

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {
        
        if (![parameter isKindOfClass:NSString.class] || !((NSString *)parameter).length) {
            return ;
        }
        
        HyTipTextView *tipTextView = [HyTipTextView tipTextViewWithText:parameter];
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(tipTextView, 0.0);
        tipView.userInteractionEnabled = NO;
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"center");
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowFade animationWithParameter:nil completion:completion];
          
        tipView.show(self.forView(nil), postion, animation);
        
        void (^dismiss)(void) = ^{
            id<HyTipViewAnimationProtocol> animation =
            [HyTipViewAnimationDismissScale animationWithParameter:@"xy" completion:completion];
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
        
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationDismissScale animationWithParameter:@"xy" completion:completion];
        [self.tipView(nil) enumerateObjectsUsingBlock:^(UIView<HyTipViewProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.dismiss(animation);
        }];
    };
}

+ (NSArray<Class> *)tipViewOfContentViewClass {
    return @[HyTipTextView.class];
}

@end
