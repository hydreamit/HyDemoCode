//
//  RACSubject+HyExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACSubject+HyExtension.h"


@implementation RACSubject (HyExtension)

- (void (^)(id _Nonnull))sendWithInputBlock {
    @weakify(self);
    return ^(id input){
        @strongify(self);
        [self sendNext:input];
    };
}

- (typeof(void (^)(id _Nonnull))  _Nonnull (^)(id  _Nonnull (^ _Nullable)(id _Nonnull)))sendWithInputHandlerBlock {
    @weakify(self);
    return ^(id(^inputBlock)(id input)){
        return ^(id value){
            @strongify(self);
            [self sendNext:inputBlock ? inputBlock(value) : nil];
        };
    };
}

- (typeof(void (^)(void))  _Nonnull (^)(id _Nonnull))sendWithVoidBlock {
    return ^(id input){
        @weakify(self);
        return ^{
            @strongify(self);
            [self sendNext:input];
        };
    };
}

- (typeof(void (^)(void))  _Nonnull (^)(id  _Nonnull (^ _Nullable)(void)))sendWithVoidHandlerBlock {
    return ^(id(^handler)(void)) {
        @weakify(self);
        return ^{
            @strongify(self);
            [self sendNext:handler ? handler() : nil];
        };
    };
}

- (void (^)(id _Nullable))send {
    @weakify(self);
    return ^(id input){
        @strongify(self);
         [self sendNext:input];
    };
}

- (void (^)(RACSignal * _Nonnull, id  _Nonnull (^ _Nullable)(id _Nonnull)))sendFromSignal {
    return ^(RACSignal *signal, id(^inputBlock)(id)) {
        @weakify(self);
        signal.subscribeNext(^(id  _Nonnull value) {
            @strongify(self);
            self.send(inputBlock ? inputBlock(value) : value);
        });
    };
}

@end
