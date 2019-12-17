//
//  HyTipBottomTool.m
//  DemoCode
//
//  Created by Hy on 2017/12/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipBottomTool.h"
#import "HyTipView.h"
#import "HyTipViewPosition.h"
#import "HyTipViewAnimationShowTranslation.h"
#import "HyTipViewAnimationDismissTranslation.h"


static NSMutableArray<Class> *_bottomContentViewClass;
@implementation HyTipBottomTool

+ (void (^)(UIView *forView, id parameter, void(^_Nullable completion)(void)))show {
    return ^(UIView *forView, id parameter, void(^_Nullable completion)(void)) {

        if (![parameter isKindOfClass:UIView.class]) {
            return ;
        }
        
        [self addContentViewClass:[parameter class]];
                  
        UIView<HyTipViewProtocol> *tipView = HyTipView.tipView(parameter, 0.5);
        id<HyTipViewPositionProtocol> postion = HyTipViewPosition.position(@"bottom");
        id<HyTipViewAnimationProtocol> animation = [HyTipViewAnimationShowTranslation animationWithParameter:@"bottom" completion:completion];
          
        tipView.show(self.forView(forView), postion, animation);
    };
}

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss {
    return ^(UIView *forView, void(^_Nullable completion)(void)){
        
        if (!self.showing(forView)) { return ; }
        
        id<HyTipViewAnimationProtocol> animation =
        [HyTipViewAnimationDismissTranslation animationWithParameter:@"bottom" completion:completion];
        [self.tipView(forView) enumerateObjectsUsingBlock:^(UIView<HyTipViewProtocol> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.dismiss(animation);
        }];
        
        [self removeAllContentViewClass];
    };
}

+ (void)addContentViewClass:(Class)class {
    if (![self.getContentViewClass containsObject:class]) {
        [self.getContentViewClass addObject:class];
    }
}

+ (void)removeAllContentViewClass {
    [self.getContentViewClass removeAllObjects];
}

+ (NSMutableArray<Class> *)getContentViewClass {
    if (!_bottomContentViewClass) {
        _bottomContentViewClass = @[].mutableCopy;
    }
    return _bottomContentViewClass;
}


@end
