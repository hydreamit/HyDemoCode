//
//  RACSignal+Network.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACSignal+Network.h"
#import "HYAFNWorkingTool.h"

// 请求成功订阅函数
ResponseSuccess subscribSuccesss(id<RACSubscriber> subscriber,  requestSignalBlock signalBlock) {
    
    return ^(NSDictionary *response) {
        signalBlock ?
        signalBlock(response, subscriber) :
        ({
            NSString *status= [NSString stringWithFormat:@"%@",@"info"];
            if (![status isEqualToString:@"0"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            }
        });
    };
}

// 请求失败订阅函数
ResponseFail subscribfail(id<RACSubscriber>  _Nonnull subscriber) {

    return ^(NSError *error) {
        [subscriber sendError:error];
    };
}

// disposableBlock 函数
typedef void(^disposableBlock)(void);
disposableBlock taskDisposableBlock(NSURLSessionTask *task) {
    
    return ^{
        if (task.state != NSURLSessionTaskStateCanceling &&
            task.state != NSURLSessionTaskStateCompleted) {
            [task cancel];
        }
    };
}


@implementation RACSignal (Network)

// Get
+ (instancetype)signalGetWithUrl:(NSString *)url
                          params:(NSDictionary *)params
                    handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HYAFNWorkingTool getWithUrl:url
                                       params:params
                                      success:subscribSuccesss(subscriber, handleSignal)
                                      failure:subscribfail(subscriber)])];
    }];
}

// Get 缓存
+ (instancetype)signalGetCacheWithUrl:(NSString *)url
                               params:(NSDictionary *)params
                         handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HYAFNWorkingTool getCacheDataWithUrl:url
                                                params:params
                                               success:subscribSuccesss(subscriber, handleSignal)
                                               failure:subscribfail(subscriber)])];
    }];
}

// Post
+ (instancetype)signalPostWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                     handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HYAFNWorkingTool postWithUrl:url
                                        params:params
                                       success:subscribSuccesss(subscriber, handleSignal)
                                       failure:subscribfail(subscriber)])];
    }];
}

// Post 缓存
+ (instancetype)signalPostCacheWithUrl:(NSString *)url
                                params:(NSDictionary *)params
                          handleSignal:(requestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HYAFNWorkingTool postCacheDataWithUrl:url
                                                 params:params
                                                success:subscribSuccesss(subscriber, handleSignal)
                                                failure:subscribfail(subscriber)])];
    }];
}

@end
