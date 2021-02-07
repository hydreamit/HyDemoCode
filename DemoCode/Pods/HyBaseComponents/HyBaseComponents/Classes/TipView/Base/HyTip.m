//
//  HyTip.m
//  DemoCode
//
//  Created by Hy on 2017/12/5.
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

+ (nullable NSArray<UIView<HyTipViewProtocol> *> *(^)(UIView *forView))tipView {
    return ^NSArray<UIView<HyTipViewProtocol> *> *(UIView *forView) {
        NSMutableArray<UIView<HyTipViewProtocol> *> *array = @[].mutableCopy;
        for (UIView *subview in [self.forView(forView).subviews reverseObjectEnumerator]) {
            if ([subview conformsToProtocol:@protocol(HyTipViewProtocol)] &&
                [subview respondsToSelector:@selector(contentView)]) {
                if ([self.tipViewOfContentViewClass containsObject:((UIView<HyTipViewProtocol> *)subview).contentView.class]) {
                    [array addObject:(UIView<HyTipViewProtocol> *)subview];
                }
            }
        }
        return array.count ? [NSArray arrayWithArray:array] : nil;
    };
}

+ (BOOL (^)(UIView *forView))showing {
    return ^BOOL(UIView *forView){
       return self.tipView(forView) ? YES : NO;
    };
}

+ (UIView *(^)(UIView *_Nullable view))forView {
    return ^UIView *(UIView *_Nullable view){
        return view ?: self.keyWindow;
    };
}

+ (NSArray<Class> *)tipViewOfContentViewClass {
    return @[UIView.class];
}

+ (UIWindow *)keyWindow {
    
    UIWindow *keyW = UIApplication.sharedApplication.windows.firstObject;
//    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
//    if ([delegate respondsToSelector:@selector(window)]){
//        keyW = [delegate performSelector:@selector(window)];
//    } else {
//        keyW = [[UIApplication sharedApplication] keyWindow];
//    }
    return keyW;
}

@end
