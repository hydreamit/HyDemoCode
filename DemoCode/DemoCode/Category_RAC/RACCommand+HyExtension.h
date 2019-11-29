//
//  RACCommand+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>


typedef void (^EmtyBlock)(void);
typedef void (^EmtyParamBlock)(id value);

typedef id (^ValueBlock)(void);
typedef id (^ValueParamBlock)(id value);


typedef void (^CommandInputBlock)(id input);
typedef RACSignal *(^CommandSignalInputBlock)(id input);
typedef RACCommand *(^EmtyCommandBloack)(CommandInputBlock inputBlock);
typedef RACCommand *(^EmtyEnabledCommandBloack)(RACSignal *enabledSignal ,CommandInputBlock inputBlock);
typedef RACCommand *(^CommandBloack)(RACSignal *signal, CommandInputBlock inputBlock);
typedef RACCommand *(^BlockCommandBloack)(CommandSignalInputBlock signalBlock, CommandInputBlock inputBlock);

typedef RACCommand *(^EnabledcommandBloack)(RACSignal *signal,RACSignal *enabledSignal ,CommandInputBlock inputBlock);
typedef RACCommand *(^EnabledBlockCommandBloack)(RACSignal *enabledSignal , CommandSignalInputBlock signalBlock,CommandInputBlock inputBlock);

NS_ASSUME_NONNULL_BEGIN

@interface RACCommand (HyExtension)


/**
 空信号的Command

 @return 设值的block
 */
+ (EmtyCommandBloack)emptyCommand;


/**
  空信号的控制enabled的Command

 @return 设值的block
 */
+ (EmtyEnabledCommandBloack)emptyEnabledCommand;


/**
 正常的command

 @return 设值的block
 */
+ (CommandBloack)command;
+ (BlockCommandBloack)blockCommand;

/**
 正常控制的enabled的Command
 
 @return 设值的block
 */
+ (EnabledcommandBloack)enabledcommand;
+ (EnabledBlockCommandBloack)enabledBlockCommand;

// block 执行 command
- (EmtyBlock (^)(id input))bindExcuteEmtyBlock;
- (EmtyBlock (^)(ValueBlock block))bindExcuteEmtyValueBlock;
- (void (^)(id input))bindExcuteBlock;
- (EmtyParamBlock (^)(ValueParamBlock block))bindExcuteValueBlock;
// signal 执行 command
- (void (^)(id input, RACSignal *signal))bindExcuteSignal;
// signal FlattenMap command
- (RACSignal *(^)(id input, RACSignal *signal))bindFlattenMapSignal;


// 方法简写
- (RACSignal *)signal;
- (RACDisposable *)subscribeNext:(void (^)(id value))nextBlock;
- (RACDisposable *)subscribeError:(void (^)(NSError *error))errorBlock;
- (RACDisposable *)subscribeCompleted:(void (^)(id value))completedBlock;
- (NSArray<RACDisposable *> *)subscribeNext:(void (^)(id value))nextBlock
                                      error:(void (^)(NSError *error))errorBlock
                                  completed:(void (^)(id value))completedBlock;

@end

NS_ASSUME_NONNULL_END
