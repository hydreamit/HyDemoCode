//
//  RACSubject+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACCommand+HyExtension.h"


typedef void (^subscribeBlock)(id _Nullable value);
typedef RACSubject *_Nullable(^subjectBlock)(subscribeBlock _Nullable subscribe);

NS_ASSUME_NONNULL_BEGIN

@interface RACSubject (HyExtension)

+ (subjectBlock)createSubject;

- (EmtyBlock (^)(id input))bindSendEmtyBlock;
- (EmtyBlock (^)(ValueBlock block))bindSendEmtyValueBlock;
- (void (^)(id input))bindSendBlock;
- (EmtyParamBlock (^)(ValueParamBlock block))bindSendValueBlock;

- (void (^)(id input, RACSignal *signal))bindSendSignal;
- (RACSignal *(^)(id input, RACSignal *signal))bindFlattenMapSignal;
@end

NS_ASSUME_NONNULL_END
