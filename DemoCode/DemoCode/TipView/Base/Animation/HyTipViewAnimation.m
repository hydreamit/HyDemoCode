//
//  HyTipViewAnimation.m
//  DemoCode
//
//  Created by huangyi on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimation.h"
#import "HyTipViewProtocol.h"

@interface HyTipViewAnimation ()
@property (nonatomic,copy) void(^completion)(void);
@property (nonatomic,strong) id parameter;
@end

@implementation HyTipViewAnimation

+ (id<HyTipViewAnimationProtocol>)animationWithParameter:(nullable id)parameter
                                              completion:(void(^_Nullable)(void))completion {
    
    HyTipViewAnimation *animation = [[self alloc] init];
    animation.completion = [completion copy];
    animation.parameter = parameter;
    return animation;
}

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        !self.completion ?: self.completion();
    };
}

@end
