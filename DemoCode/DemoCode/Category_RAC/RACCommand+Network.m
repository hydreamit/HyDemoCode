//
//  RACCommand+Network.m
//  demo
//
//  Created by Hy on 2018/11/10.
//  Copyright © 2018年 Hy. All rights reserved.
//

#import "RACCommand+Network.h"
#import "RACSignal+Network.h"


BOOL requestShowHUD(id input, RequestShowHUDBlcok block) {
    return block ? block(input) : YES;
}

BOOL requestCache(id input, RequestCacheBlock block) {
    return block ? block(input) : YES;
}

id requestUrl(id input, RequestUrlBlock block) {
    return block ? block(input) : @"";
}

id requestParameter(id input, RequestParameterBlock block) {
    return block ? block(input) : input;
}

HyNetworkFormDataBlock requestFormData(id input, RequestFormDataBlock block) {
    return ^(id<HyMultipartFormDataProtocol> object){
        !block ?: block(input, object);
    };
}

RequestSignalBlock requestCommand(id input, RequestCommandBlock block) {
    return !block  ? nil :
    ^(id response, id<RACSubscriber> subscriber) {
        block(input, response, subscriber);
    };
}



@implementation RACCommand (Network)

+ (instancetype)commandGetShowHUD:(RequestShowHUDBlcok)showHUD
                            cache:(RequestCacheBlock)cache
                              url:(RequestUrlBlock)url
                        parameter:(RequestParameterBlock)parameter
                    handleCommand:(RequestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalGetShowHUD:requestShowHUD(input, showHUD)
                                     cache:requestCache(input, cache)
                                       url:requestUrl(input, url)
                                 parameter:requestParameter(input, parameter)
                              handleSignal:requestCommand(input, handleCommand)];
    }];
}



+ (instancetype)commandPostShowHUD:(RequestShowHUDBlcok)showHUD
                             cache:(RequestCacheBlock)cache
                               url:(RequestUrlBlock)url
                         parameter:(RequestParameterBlock)parameter
                     handleCommand:(RequestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalPostShowHUD:requestShowHUD(input, showHUD)
                                      cache:requestCache(input, cache)
                                        url:requestUrl(input, url)
                                  parameter:requestParameter(input, parameter)
                               handleSignal:requestCommand(input, handleCommand)];
    }];
}


+ (instancetype)commandPostShowHUD:(RequestShowHUDBlcok)showHUD
                             cache:(RequestCacheBlock)cache
                               url:(RequestUrlBlock)url
                         parameter:(RequestParameterBlock)parameter
                          formData:(RequestFormDataBlock)formData
                     handleCommand:(RequestCommandBlock)handleCommand {
    
    return [[self alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {;
        return [RACSignal signalPostShowHUD:requestShowHUD(input, showHUD)
                                      cache:requestCache(input, cache)
                                        url:requestUrl(input, url)
                                  parameter:requestParameter(input, parameter)
                                   formData:requestFormData(input, formData)
                               handleSignal:requestCommand(input, handleCommand)];
    }];
}

@end
