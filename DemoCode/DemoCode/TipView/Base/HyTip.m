//
//  HyTip.m
//  DemoCode
//
//  Created by huangyi on 2017/12/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTip.h"
#import "HyTipView.h"

@implementation HyTip

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)){};
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){};
}

+ (nullable UIView<HyTipViewProtocol> *(^)(UIView *forView))tipView {
    return ^UIView<HyTipViewProtocol> *(UIView *forView){
        for (UIView *subview in [forView.subviews reverseObjectEnumerator]) {
            if ([subview isKindOfClass:HyTipView.class]) {
                return (UIView<HyTipViewProtocol> *)subview;
            }
        }
        return nil;
    };
}

+ (BOOL (^)(UIView *forView))showing {
    return ^BOOL(UIView *forView){
       return self.tipView(forView) ? YES : NO;
    };
}

@end
