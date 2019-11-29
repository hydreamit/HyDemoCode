//
//  RACSignal+HyExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACSignal+HyExtension.h"

@implementation RACSignal (HyExtension)

+ (RACSignal *(^)(EmtyBlock excuteBlock))excuteSignal {
    return ^RACSignal *(EmtyBlock excuteBlock) {
        return
        [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            !excuteBlock ?: excuteBlock();
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }];
    };
}

+ (RACSignal *(^)(NSArray<RACCommand *> *commands))completionSignal {
    return ^RACSignal *(NSArray<RACCommand *> *commands) {
        NSMutableArray<RACSignal *> *executingSignals = @[].mutableCopy;
        [commands enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [executingSignals addObject:[obj.executing skip:1]];
        }];
        return  executingSignals ?
        [[[RACSignal combineLatest:executingSignals] or] distinctUntilChanged] :
        [RACSignal empty];
    };
}

@end
