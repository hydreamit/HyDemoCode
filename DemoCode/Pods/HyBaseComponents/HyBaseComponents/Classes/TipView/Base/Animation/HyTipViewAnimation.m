//
//  HyTipViewAnimation.m
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipViewAnimation.h"
#import "HyTipViewProtocol.h"

@interface HyTipViewAnimation ()
@property (nonatomic,copy) void(^animationBlock)(UIView<HyTipViewProtocol> *);
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

+ (id<HyTipViewAnimationProtocol>)animationWithBlock:(void(^)(UIView<HyTipViewProtocol> *tipView))block {
    HyTipViewAnimation *animation = [[self alloc] init];
    animation.animationBlock = [block copy];
    return animation;
}

- (void (^)(UIView<HyTipViewProtocol> *tipView))animation {
    __weak typeof(self) _self = self;
    return ^(UIView<HyTipViewProtocol> *tipView){
        __strong typeof(_self) self = _self;
        
        self.animationBlock ? self.animationBlock(tipView) :
        !self.completion ?: self.completion();
    };
}

@end
