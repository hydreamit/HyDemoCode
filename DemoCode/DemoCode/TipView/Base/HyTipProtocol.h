//
//  HyTipProtocol.h
//  DemoCode
//
//  Created by huangyi on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyTipViewProtocol;
@protocol HyTipProtocol <NSObject>

+ (void)showToView:(UIView *)view
         parameter:(nullable id)parameter
        completion:(void(^_Nullable)(void))completion;

+ (void)dismissWithCompletion:(void(^_Nullable)(void))completion;

+ (BOOL)showing;

+ (nullable UIView<HyTipViewProtocol> *)tipView;

@end

NS_ASSUME_NONNULL_END
