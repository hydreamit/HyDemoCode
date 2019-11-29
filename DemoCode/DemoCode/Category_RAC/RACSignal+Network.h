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

typedef void (^_Nullable RequestSignalBlock)(id response, id<RACSubscriber> subscriber);

@interface RACSignal (Network)

+ (instancetype)signalGetShowHUD:(BOOL)showHUD
                            cache:(BOOL)cache
                              url:(NSString *)url
                        parameter:(NSDictionary *_Nullable)parameter
                     handleSignal:(RequestSignalBlock)handleSignal;

+ (instancetype)signalPostShowHUD:(BOOL)showHUD
                           cache:(BOOL)cache
                             url:(NSString *)url
                       parameter:(NSDictionary *_Nullable)parameter
                    handleSignal:(RequestSignalBlock)handleSignal;

+ (instancetype)signalPostShowHUD:(BOOL)showHUD
                            cache:(BOOL)cache
                              url:(NSString *)url
                        parameter:(NSDictionary *_Nullable)parameter
                         formData:(HyNetworkFormDataBlock)formData
                     handleSignal:(RequestSignalBlock)handleSignal;
@end

NS_ASSUME_NONNULL_END
