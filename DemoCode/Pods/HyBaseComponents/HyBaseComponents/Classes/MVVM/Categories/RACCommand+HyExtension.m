//
//  RACCommand+HyExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACCommand+HyExtension.h"


@implementation RACCommand (HyExtension)

- (void (^)(id _Nonnull))executeWithInputBlock {
    @weakify(self);
    return ^(id input) {
        @strongify(self);
        [self execute:input];
    };
}

- (typeof(void (^)(id _Nonnull))  _Nonnull (^)(id  _Nonnull (^ _Nullable)(id _Nonnull)))executeWithInputHandlerBlock {
    @weakify(self);
    return ^(id(^inputBlock)(id input)) {
        return ^(id value) {
            @strongify(self);
            [self execute:inputBlock ? inputBlock(value) : nil];
        };
    };
}

- (typeof(void (^)(void))  _Nonnull (^)(id _Nonnull))executeWithVoidBlock {
    @weakify(self);
    return ^(id input){
        return ^{
            @strongify(self);
            [self execute:input];
        };
    };
}

- (typeof(void (^)(void))  _Nonnull (^)(id  _Nonnull (^ _Nullable)(void)))executeWithVoidHandlerBlock {
    @weakify(self);
    return ^(id(^handler)(void)){
        return ^{
            @strongify(self);
            [self execute:handler ? handler() : nil];
        };
    };
}

- (RACSignal * _Nonnull (^)(id _Nullable))execute {
    @weakify(self);
    return ^(id input){
        @strongify(self);
        return [self execute:input];
    };
}

- (RACSignal * _Nonnull (^)(RACSignal * _Nonnull, id  _Nonnull (^ _Nullable)(id _Nonnull)))executeFromSignal {
    @weakify(self);
    return ^(RACSignal *signal, id(^inputBlock)(id)) {
        return signal.flattenMap(^RACSignal * _Nonnull(id _Nonnull value) {
            @strongify(self);
            return self.execute(inputBlock ? inputBlock(value) : value);
        });
    };
}

- (RACSignal * _Nonnull (^)(id _Nonnull, RACSignal * _Nonnull (^ _Nonnull)(id _Nonnull)))executeToSignal {
    @weakify(self);
    return ^(id input, RACSignal *(^block)(id)) {
        @strongify(self);
        return self.execute(input).flattenMap(block);
    };
}

- (RACSignal * _Nonnull (^)(RACSignal * _Nonnull, id  _Nonnull (^ _Nullable)(id _Nonnull), RACSignal * _Nonnull (^ _Nonnull)(id _Nonnull)))executeFromToSignal {
    @weakify(self);
    return ^(RACSignal *fromSignal, id(^inputBlock)(id), RACSignal *(^toSignalBlock)(id)){
        @strongify(self);
        return self.executeFromSignal(fromSignal, inputBlock).flattenMap(toSignalBlock);
    };
}

- (RACSignal *)signal {
    return self.executionSignals.switchToLatest;
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))subscribeNext {
    @weakify(self);
    return ^(void (^block)(id)) {
        @strongify(self);
        return [self.signal.deliverOnMainThread subscribeNext:block];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(NSError * _Nonnull)))subscribeError {
    @weakify(self);
    return ^(void (^block)(NSError *)){
        @strongify(self);
        return [self.errors.deliverOnMainThread subscribeNext:block];
    };
}

- (RACDisposable * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull)))subscribeCompleted {
    @weakify(self);
    return ^(void (^block)(id)){
        @strongify(self);
        return [[self.executing skip:1].deliverOnMainThread subscribeNext:block];
    };
}

- (NSArray<RACDisposable *> * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull), void (^ _Nonnull)(NSError * _Nonnull), void (^ _Nonnull)(id _Nonnull)))subscribeAll {
    @weakify(self);
    return ^(void (^nextBlock)(id), void (^errorBlock)(NSError *), void (^completedBlock)(id)){
        @strongify(self);
        NSMutableArray *array = @[].mutableCopy;
        if (nextBlock) {
            [array addObject:self.subscribeNext(nextBlock)];
        } if (errorBlock) {
            [array addObject:self.subscribeError(errorBlock)];
        } if (completedBlock) {
            [array addObject:self.subscribeCompleted(completedBlock)];
        }
        return array.copy;
    };
}

@end
