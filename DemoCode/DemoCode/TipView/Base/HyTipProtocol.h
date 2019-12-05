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

+ (void (^)(UIView *forView, id _Nullable parameter, void(^_Nullable completion)(void)))show;

+ (void (^)(UIView *forView, void(^_Nullable completion)(void)))dismiss;

+ (nullable UIView<HyTipViewProtocol> *(^)(UIView *forView))tipView;

+ (BOOL (^)(UIView *forView))showing;

@end

NS_ASSUME_NONNULL_END
