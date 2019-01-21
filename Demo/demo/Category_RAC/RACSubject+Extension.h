//
//  RACSubject+Extension.h
//  Demo
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACSubject.h"
#import "RACCommand+Extension.h"
#import <ReactiveObjC/ReactiveObjC.h>


typedef void (^subscribeBlock)(id value);
typedef RACSubject *(^subjectBlock)(subscribeBlock subscribe);

@interface RACSubject (Extension)

+ (subjectBlock)createSubject;

- (EmtyBlock (^)(id input))bindSendEmtyBlock;
- (EmtyBlock (^)(ValueBlock block))bindSendEmtyValueBlock;
- (void (^)(id input))bindSendBlock;
- (EmtyParamBlock (^)(ValueParamBlock block))bindSendValueBlock;

- (void (^)(id input, RACSignal *signal))bindSendSignal;
- (RACSignal *(^)(id input, RACSignal *signal))bindFlattenMapSignal;

@end














