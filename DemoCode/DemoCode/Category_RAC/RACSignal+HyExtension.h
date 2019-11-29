//
//  RACSignal+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "RACCommand+HyExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACSignal (HyExtension)

+ (RACSignal *(^)(EmtyBlock excuteBlock))excuteSignal;
+ (RACSignal *(^)(NSArray<RACCommand *> *commands))completionSignal;

@end

NS_ASSUME_NONNULL_END
