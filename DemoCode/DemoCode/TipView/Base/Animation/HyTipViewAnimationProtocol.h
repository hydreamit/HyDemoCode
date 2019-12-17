//
//  HyTipViewAnimationProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyTipViewProtocol;
@protocol HyTipViewAnimationProtocol <NSObject>

@optional
+ (id<HyTipViewAnimationProtocol>)animationWithParameter:(nullable id)parameter
                                              completion:(void(^_Nullable)(void))completion;

+ (id<HyTipViewAnimationProtocol>)animationWithBlock:(void(^)(UIView<HyTipViewProtocol> *tipView))block;

@required
- (void(^)(UIView<HyTipViewProtocol> *))animation;

@end

NS_ASSUME_NONNULL_END
