//
//  RACSignal+HyExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACSignal+HyExtension.h"


@implementation RACSignal (HyExtension)

- (RACSignal * _Nonnull (^)(RACSignal * _Nullable (^ _Nonnull)(id _Nullable)))flattenMap {
    @weakify(self);
    return ^RACSignal *(RACSignal * _Nullable (^block)(id _Nullable value)){
        @strongify(self);
        return [self flattenMap:block];
    };
}

- (RACDisposable * _Nonnull (^)(id<RACSubscriber> _Nonnull))subscribe {
    @weakify(self);
    return ^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self);
        return [self subscribe:subscriber];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))subscribeNext {
    @weakify(self);
    return ^RACDisposable *(void(^block)(id)){
        @strongify(self);
        return [self subscribeNext:block];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(NSError * _Nonnull)))subscribeError {
    @weakify(self);
    return ^RACDisposable *(void(^block)(NSError *)){
        @strongify(self);
        return [self subscribeError:block];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(void)))subscribeCompleted {
    @weakify(self);
    return ^RACDisposable *(void(^block)(void)){
        @strongify(self);
        return [self subscribeCompleted:block];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull), void (^ _Nonnull)(NSError * _Nonnull), void (^ _Nonnull)(void)))subscribeAll {
    @weakify(self);
    return ^RACDisposable *(void (^nextBlock)(id _Nonnull), void (^errorBlock)(id _Nonnull), void (^completedBlock)(void)){
        @strongify(self);
        return [self subscribeNext:nextBlock
                             error:errorBlock
                         completed:completedBlock];
    };
}

- (RACSignal * _Nonnull (^)(id  _Nonnull (^ _Nonnull)(id _Nonnull)))map {
    @weakify(self);
    return ^RACSignal *(id(^block)(id)){
        @strongify(self);
        return [self map:block];
    };
}

- (RACSignal * _Nonnull (^)(id _Nonnull))mapReplace {
    @weakify(self);
    return ^RACSignal *(id value){
        @strongify(self);
        return [self mapReplace:value];
    };
}

- (RACSignal * _Nonnull (^)(BOOL (^ _Nonnull)(id _Nonnull)))filter {
    @weakify(self);
    return ^RACSignal *(BOOL (^block)(id value)) {
        @strongify(self);
        return [self filter:block];
    };
}

- (RACSignal * _Nonnull (^)(id _Nonnull))ignore {
    @weakify(self);
    return ^RACSignal *(id value){
        @strongify(self);
        return [self ignore:value];
    };
}

- (RACSignal * _Nonnull (^)(RACReduceBlock _Nonnull))reduceEach {
    @weakify(self);
    return ^RACSignal *(RACReduceBlock block){
        @strongify(self);
        return [self reduceEach:block];
    };
}

- (RACSignal * _Nonnull (^)(id _Nonnull))startWith {
    @weakify(self);
    return ^RACSignal *(id value){
        @strongify(self);
        return [self startWith:value];
    };
}

- (RACSignal * _Nonnull (^)(NSUInteger))skip {
    @weakify(self);
    return ^RACSignal *(NSUInteger value) {
        @strongify(self);
        return [self skip:value];
    };
}

- (RACSignal * _Nonnull (^)(NSUInteger))take {
    @weakify(self);
    return ^RACSignal *(NSUInteger value) {
        @strongify(self);
        return [self take:value];
    };
}

- (RACSignal * _Nonnull (^)(NSTimeInterval))delay {
    @weakify(self);
    return ^(NSTimeInterval interval) {
        @strongify(self);
        return [self delay:interval];
    };
}

- (RACSignal * _Nonnull (^)(NSTimeInterval))throttle {
    @weakify(self);
    return ^(NSTimeInterval interval) {
        @strongify(self);
        return [self throttle:interval];
    };
}

- (RACSignal * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))doNext {
    @weakify(self);
    return ^(void(^block)(id value)) {
        @strongify(self);
        return [self doNext:block];
    };
}

- (RACSignal * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))doError {
    @weakify(self);
    return ^(void(^block)(id value)) {
        @strongify(self);
        return [self doError:block];
    };
}

- (RACSignal * _Nonnull (^)(void (^ _Nonnull)(void)))doCompleted {
    @weakify(self);
    return ^(void(^block)(void)) {
        @strongify(self);
        return [self doCompleted:block];
    };
}

@end
