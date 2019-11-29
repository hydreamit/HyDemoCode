//
//  RACSignal+Network.m
//  demo
//
//  Created by Hy on 2018/11/10.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "RACSignal+Network.h"


HyNetworkSuccessBlock subscribSuccesss(id<RACSubscriber> subscriber,  RequestSignalBlock signalBlock) {
    return ^(id response, id<HyNetworkTaskProtocol> networkTask) {
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

HyNetworkFailureBlock subscribFailure(id<RACSubscriber>  _Nonnull subscriber) {
    return ^(NSError *_Nullable error, id<HyNetworkTaskProtocol> networkTask) {
        [subscriber sendError:error];
    };
}

typedef void(^DisposableBlock)(void);
DisposableBlock taskDisposableBlock(id<HyNetworkTaskProtocol> networkTask) {
    return ^{
        [networkTask cancel];
    };
}


@implementation RACSignal (Network)

+ (instancetype)signalGetShowHUD:(BOOL)showHUD
                           cache:(BOOL)cache
                             url:(NSString *)url
                       parameter:(NSDictionary *_Nullable)parameter
                    handleSignal:(RequestSignalBlock)handleSignal {
    
    return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HyNetworkManager.network getShowHUD:showHUD
                                                cache:cache
                                                  url:url
                                            parameter:parameter
                                         successBlock:subscribSuccesss(subscriber, handleSignal)
                                         failureBlock:subscribFailure(subscriber)])];
    }];
}

+ (instancetype)signalPostShowHUD:(BOOL)showHUD
                           cache:(BOOL)cache
                             url:(NSString *)url
                       parameter:(NSDictionary *_Nullable)parameter
                     handleSignal:(RequestSignalBlock)handleSignal {
    
      return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
          return [RACDisposable disposableWithBlock:taskDisposableBlock
                  ([HyNetworkManager.network postShowHUD:showHUD
                                                   cache:cache
                                                     url:url
                                               parameter:parameter
                                            successBlock:subscribSuccesss(subscriber, handleSignal)
                                            failureBlock:subscribFailure(subscriber)])];
      }];
}

+ (instancetype)signalPostShowHUD:(BOOL)showHUD
                            cache:(BOOL)cache
                              url:(NSString *)url
                        parameter:(NSDictionary *_Nullable)parameter
                         formData:(void(^_Nullable)(id<HyMultipartFormDataProtocol>))formData
                     handleSignal:(RequestSignalBlock)handleSignal {
    
   return [self createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        return [RACDisposable disposableWithBlock:taskDisposableBlock
                ([HyNetworkManager.network postShowHUD:showHUD
                                                 cache:cache
                                                   url:url
                                             parameter:parameter
                                         formDataBlock:formData
                                          successBlock:subscribSuccesss(subscriber, handleSignal)
                                          failureBlock:subscribFailure(subscriber)])];
    }];
}

@end
