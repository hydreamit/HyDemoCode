//
//  HyTipViewAnimationProtocol.h
//  DemoCode
//
//  Created by huangyi on 2017/12/4.
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

@required
- (void(^)(UIView<HyTipViewProtocol> *))animation;

@end

NS_ASSUME_NONNULL_END
