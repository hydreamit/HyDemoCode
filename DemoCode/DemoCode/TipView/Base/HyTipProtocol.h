//
//  HyTipProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HyTipViewProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyTipProtocol <NSObject>

+ (void (^)(UIView *_Nullable forView, id _Nullable parameter, void(^_Nullable completion)(void)))show;

+ (void (^)(UIView *_Nullable forView, void(^_Nullable completion)(void)))dismiss;

+ (nullable NSArray<UIView<HyTipViewProtocol> *> *(^)(UIView *_Nullable forView))tipView;

+ (BOOL (^)(UIView *_Nullable forView))showing;

@end

NS_ASSUME_NONNULL_END
