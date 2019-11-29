//
//  RACCommand+HyViewControllerJump.h
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "HyViewControllerJumpProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (HyViewControllerJump) <HyViewControllerJumpProtocol>

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))pushCommand;

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary * _Nullable parameter,
                   BOOL animated))presentCommand;

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))popCommand;

+ (RACCommand *(^)(NSDictionary *_Nullable parameter,
                   BOOL animated))dismissCommand;


+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))pushEnabledCommand;

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary * _Nullable parameter,
                   BOOL animated))presentEnabledCommand;

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))popEnabledCommand;

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))dismissEnabledCommand;

@end

NS_ASSUME_NONNULL_END
