//
//  RACSignal+Network.h
//  demo
//
//  Created by Hy on 2017/11/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "HyMultipartFormDataProtocol.h"
#import "HyNetworkManager.h"


NS_ASSUME_NONNULL_BEGIN

#define valueBlock(_value) ^{return _value;}
#define valueBlockType(_type) _type(^_Nullable)(void)
#define valueParamBlockType(_type, ...) _type(^_Nullable)(__VA_ARGS__)
#define executeBlock(_block, _return, ...) ({_block ? _block(__VA_ARGS__) :  _return;})


typedef void (^_Nullable RequestSignalBlock)(id<HyNetworkSuccessProtocol> successObject, id<RACSubscriber> subscriber);

@interface RACSignal (Network)

+ (instancetype)signalGetShowHUD:(valueBlockType(BOOL))showHUD
                           cache:(valueBlockType(BOOL))cache
                             url:(valueBlockType(NSString *))url
                       parameter:(valueBlockType(NSDictionary *_Nullable))parameter
                    handleSignal:(RequestSignalBlock)handleSignal;

+ (instancetype)signalPostShowHUD:(valueBlockType(BOOL))showHUD
                            cache:(valueBlockType(BOOL))cache
                              url:(valueBlockType(NSString *))url
                        parameter:(valueBlockType(NSDictionary *_Nullable))parameter
                     handleSignal:(RequestSignalBlock)handleSignal;

+ (instancetype)signalPostShowHUD:(valueBlockType(BOOL))showHUD
                            cache:(valueBlockType(BOOL))cache
                              url:(valueBlockType(NSString *))url
                        parameter:(valueBlockType(NSDictionary *_Nullable))parameter
                         formData:(HyNetworkFormDataBlock)formData
                     handleSignal:(RequestSignalBlock)handleSignal;

@end

NS_ASSUME_NONNULL_END
