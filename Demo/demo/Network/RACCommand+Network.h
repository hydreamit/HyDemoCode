//
//  RACCommand+Network.h
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

// 处理执行command的block
typedef void (^requestCommandBlock)(id input, id response,  id<RACSubscriber> subscriber);

// 处理执行command的input来改变请求参数的paramsblock
typedef id _Nonnull (^requestParamsBlock)(id input);

// 处理执行command的input来改变请求Url
typedef id _Nonnull (^requestUrlBlock)(id input);

@interface RACCommand (Network)


// Get
+ (instancetype)commandGetWithUrl:(requestUrlBlock)url
                           params:(requestParamsBlock)params
                    handleCommand:(requestCommandBlock)handleCommand;

// Get 缓存
+ (instancetype)commandGetCacheWithUrl:(requestUrlBlock)url
                                params:(requestParamsBlock)params
                         handleCommand:(requestCommandBlock)handleCommand;

// Post
+ (instancetype)commandPostWithUrl:(requestUrlBlock)url
                            params:(requestParamsBlock)params
                     handleCommand:(requestCommandBlock)handleCommand;


// Post 缓存
+ (instancetype)commandPostCacheWithUrl:(requestUrlBlock)url
                                 params:(requestParamsBlock)params
                          handleCommand:(requestCommandBlock)handleCommand;


@end

NS_ASSUME_NONNULL_END
