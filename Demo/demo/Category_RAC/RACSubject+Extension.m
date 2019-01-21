//
//  RACSubject+Extension.m
//  Demo
//
//  Created by huangyi on 2018/4/14.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACSubject+Extension.h"


@implementation RACSubject (Extension)

+ (subjectBlock)createSubject {
    return ^RACSubject *(subscribeBlock subscribe){
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:subscribe];
        return subject;
    };
}

- (EmtyBlock (^)(id input))bindSendEmtyBlock {
    @weakify(self);
    return ^EmtyBlock(id input) {
        return ^{
            @strongify(self);
            [self sendNext:input];
        };
    };
}

- (EmtyBlock (^)(ValueBlock block))bindSendEmtyValueBlock {
    @weakify(self);
    return ^EmtyBlock(ValueBlock block) {
        return ^{
            @strongify(self);
            [self sendNext:block ? block() : nil];
        };
    };
}

- (void (^)(id input))bindSendBlock {
    @weakify(self);
    return ^(id input){
        @strongify(self);
        [self sendNext:input];
    };
}

- (EmtyParamBlock (^)(ValueParamBlock block))bindSendValueBlock {
    @weakify(self);
    return ^EmtyParamBlock(ValueParamBlock block) {
        return ^(id input){
            @strongify(self);
            [self sendNext:block ? block(input) : nil];
        };
    };
}

- (void (^)(id input, RACSignal *signal))bindSendSignal {
    @weakify(self);
    return ^(id input, RACSignal *signal){
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self sendNext:input];
        }];
    };
}

- (RACSignal *(^)(id input, RACSignal *signal))bindFlattenMapSignal {
    @weakify(self);
    return ^RACSignal *(id input, RACSignal *signal) {
        @strongify(self);
        self.bindSendSignal(input, signal);
        return [signal flattenMap:^RACSignal *(id value) {
                return self;
        }];
    };
}

@end





