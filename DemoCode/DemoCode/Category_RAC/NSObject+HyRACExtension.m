//
//  NSObject+HyRACExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "NSObject+HyRACExtension.h"

@implementation NSObject (HyRACExtension)

- (RACSignal<RACTuple *> * _Nonnull (^)(SEL _Nonnull))signalForSelector {
    return ^(SEL sel) {
        return [self rac_signalForSelector:sel];
    };
}

- (RACSignal<RACTuple *> * _Nonnull (^)(SEL _Nonnull, Protocol * _Nonnull))signalForSelectorFromProtocol {
    return ^(SEL sel, Protocol *protocol) {
        return [self rac_signalForSelector:sel fromProtocol:protocol];
    };
}

- (RACSignal * _Nonnull (^)(SEL _Nonnull, NSArray<RACSignal *> * _Nonnull))liftSelectorWithSignals {
    return ^(SEL sel, NSArray<RACSignal *> *signals) {
        return [self rac_liftSelector:sel withSignalsFromArray:signals];
    };
}

@end
