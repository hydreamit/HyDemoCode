//
//  HyTipCenterTool.m
//  DemoCode
//
//  Created by Hy on 2017/12/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipCenterTool.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowScale.h"
#import "HyTipViewAnimationDismissScale.h"


static NSMutableArray<Class> *_centerContentViewClass;
@implementation HyTipCenterTool

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {

        if (![parameter isKindOfClass:UIView.class]) {
            return ;
        }
        
        [self addContentViewClass:[parameter class]];
                  
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(parameter, 0.5);
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"center");
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowScale animationWithParameter:@"xy" completion:completion];
          
        tipView.show(self.forView(forView), postion, animation);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        if (!self.showing(forView)) { return ; }
        
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissScale animationWithParameter:@"xy" completion:completion];
        [self.tipView(forView) enumerateObjectsUsingBlock:^(UIView<HyTipViewProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.dismiss(animation);
        }];
        
        [self removeAllContentViewClass];
    };
}

static NSMutableArray<Class> * _contentViewClass;
+ (void)addContentViewClass:(Class)class {
    if (![self.getContentViewClass containsObject:class]) {
        [self.getContentViewClass addObject:class];
    }
}

+ (void)removeAllContentViewClass {
    [self.getContentViewClass removeAllObjects];
}

+ (NSMutableArray<Class> *)getContentViewClass {
    _contentViewClass = @[UIView.class].mutableCopy;
    return _contentViewClass;
}

+ (NSArray<Class> *)tipViewOfContentViewClass {
    return _contentViewClass;
}

@end
