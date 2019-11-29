//
//  RACSignal+HyViewControllerJump.h
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "HyViewControllerJumpProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (HyViewControllerJump) <HyViewControllerJumpProtocol>

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))pushSignal;

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary * _Nullable parameter,
                  BOOL animated))presentSignal;

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))popSignal;

+ (RACSignal *(^)(NSDictionary *_Nullable parameter,
                  BOOL animated))dismissSignal;

@end

NS_ASSUME_NONNULL_END
