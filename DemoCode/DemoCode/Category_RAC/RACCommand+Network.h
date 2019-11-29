//
//  RACCommand+Network.h
//  demo
//
//  Created by Hy on 2017/11/10.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "HyMultipartFormDataProtocol.h"


NS_ASSUME_NONNULL_BEGIN

typedef BOOL  (^_Nullable RequestShowHUDBlcok)(id _Nullable input);
typedef BOOL  (^_Nullable RequestCacheBlock)(id _Nullable input);
typedef void  (^_Nullable RequestFormDataBlock)(id<HyMultipartFormDataProtocol> formData, id _Nullable input);

typedef NSString  * _Nullable  (^_Nullable RequestUrlBlock)(id _Nullable input);
typedef id  _Nullable (^_Nullable RequestParameterBlock)(id _Nullable input);
typedef void (^_Nullable RequestCommandBlock)(id _Nullable input, id response,  id<RACSubscriber> subscriber);


@interface RACCommand (Network)


+ (instancetype)commandGetShowHUD:(RequestShowHUDBlcok)showHUD
                            cache:(RequestCacheBlock)cache
                              url:(RequestUrlBlock)url
                        parameter:(RequestParameterBlock)parameter
                    handleCommand:(RequestCommandBlock)handleCommand;


+ (instancetype)commandPostShowHUD:(RequestShowHUDBlcok)showHUD
                             cache:(RequestCacheBlock)cache
                               url:(RequestUrlBlock)url
                         parameter:(RequestParameterBlock)parameter
                     handleCommand:(RequestCommandBlock)handleCommand;


+ (instancetype)commandPostShowHUD:(RequestShowHUDBlcok)showHUD
                             cache:(RequestCacheBlock)cache
                               url:(RequestUrlBlock)url
                         parameter:(RequestParameterBlock)parameter
                          formData:(RequestFormDataBlock)formData
                     handleCommand:(RequestCommandBlock)handleCommand;


@end

NS_ASSUME_NONNULL_END
