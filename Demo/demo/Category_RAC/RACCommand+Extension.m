//
//  RACCommand+Extension.m
//  Demo
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACCommand+Extension.h"


typedef RACSignal *(^commandSignalBlock)(id input);
commandSignalBlock commandSignal(CommandSignalInputBlock signalBlock, CommandInputBlock inputBlock) {
    return ^RACSignal *(id input){
        !inputBlock ?: inputBlock(input);
        return (signalBlock ? signalBlock(input) : nil) ?: [RACSignal empty];
    };
}


@implementation RACCommand (Extension)
+ (EmtyCommandBloack)emptyCommand {
    return ^RACCommand *(CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithSignalBlock:commandSignal(nil, inputBlock)];
    };
}

+ (EmtyEnabledCommandBloack)emptyEnabledCommand {
    return ^RACCommand *(RACSignal *enabledSignal ,CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithEnabled:enabledSignal ?: [RACSignal return:@NO]
                                       signalBlock:commandSignal(nil, inputBlock)];
    };
}

+ (CommandBloack)command {
    @weakify(self);
    return ^ RACCommand *(RACSignal *signal, CommandInputBlock inputBlock){
        @strongify(self);
        return self.blockCommand(^RACSignal *(id input){
            return signal;
        }, inputBlock);
    };
    
}

+ (BlockCommandBloack)blockCommand {
    return ^ RACCommand *(CommandSignalInputBlock signalBlock, CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithSignalBlock:commandSignal(signalBlock, inputBlock)];
    };
}

+ (EnabledcommandBloack)enabledcommand {
    @weakify(self);
    return ^RACCommand *(RACSignal *enabledSignal ,RACSignal *signal, CommandInputBlock inputBlock){
        @strongify(self);
        return self.enabledBlockCommand(enabledSignal ,^RACSignal *(id input){
            return signal;
        }, inputBlock);
    };
}

+ (EnabledBlockCommandBloack)enabledBlockCommand {
    return ^RACCommand *(RACSignal *enabledSignal ,CommandSignalInputBlock signalBlock, CommandInputBlock inputBlock){
        return [[RACCommand alloc] initWithEnabled:enabledSignal ?: [RACSignal return:@YES]
                                       signalBlock:commandSignal(signalBlock, inputBlock)];
    };
}

- (EmtyBlock (^)(id input))bindExcuteEmtyBlock {
    @weakify(self);
    return ^EmtyBlock(id input) {
        return ^{
            @strongify(self);
            [self execute:input];
        };
    };
}

- (EmtyBlock (^)(ValueBlock block))bindExcuteEmtyValueBlock {
    @weakify(self);
    return ^EmtyBlock(ValueBlock block) {
        return ^{
            @strongify(self);
            [self execute:block ? block() : nil];
        };
    };
}

- (void (^)(id input))bindExcuteBlock {
    @weakify(self);
    return ^(id input){
        @strongify(self);
        [self execute:input];
    };
}

- (EmtyParamBlock (^)(ValueParamBlock block))bindExcuteValueBlock {
    @weakify(self);
    return ^EmtyParamBlock(ValueParamBlock block) {
        return ^(id input){
            @strongify(self);
            [self execute:block ? block(input) : nil];
        };
    };
}

- (void (^)(id input, RACSignal *signal))bindExcuteSignal {
    @weakify(self);
    return ^(id input, RACSignal *signal){
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self execute:input];
        }];
    };
}

- (RACSignal *(^)(id input, RACSignal *signal))bindFlattenMapSignal {
    @weakify(self);
    return ^RACSignal *(id input, RACSignal *signal) {
        @strongify(self);
        self.bindExcuteSignal(input, signal);
        return self.signal;
    };
}

- (RACSignal *)signal {
    return self.executionSignals.switchToLatest;
}

- (RACDisposable *)subscribeNext:(void (^)(id value))nextBlock {
    return
    [[self.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:nextBlock];
}

- (RACDisposable *)subscribeError:(void (^)(NSError *error))errorBlock {
    return
    [[self.errors deliverOnMainThread] subscribeNext:errorBlock];
}

- (RACDisposable *)subscribeCompleted:(void (^)(id value))completedBlock {
    return
    [[[self.executing skip:1] deliverOnMainThread] subscribeNext:completedBlock];
}

- (NSArray<RACDisposable *> *)subscribeNext:(void (^)(id value))nextBlock
                                      error:(void (^)(NSError *error))errorBlock
                                  completed:(void (^)(id value))completedBlock {
    NSMutableArray *array = @[].mutableCopy;
    if (nextBlock) {
        [array addObject:[self subscribeNext:nextBlock]];
    } if (errorBlock) {
        [array addObject:[self subscribeError:errorBlock]];
    } if (completedBlock) {
        [array addObject:[self subscribeCompleted:completedBlock]];
    }
    return array.copy;
}

@end











