//
//  HyNetworkProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkTaskProtocol.h"
#import "HyMultipartFormDataProtocol.h"
#import "HyNetworkCacheProtocol.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyNetworStatus) {
    HyNetworStatusReachableViaWWAN,
    HyNetworStatusReachbleViaWiFi,
    HyNetworStatusUnKnown,
    HyNetworStatusNotReachable
};

typedef void (^_Nullable HyNetworkStatusBlock)(HyNetworStatus currentStatus, HyNetworStatus lastStatus);
typedef void (^_Nullable HyNetworkFormDataBlock)(id<HyMultipartFormDataProtocol> formData);
typedef void (^_Nullable HyNetworkSuccessBlock)(id _Nullable response, id<HyNetworkTaskProtocol> task);
typedef void (^_Nullable HyNetworkFailureBlock)(NSError *_Nullable error, id<HyNetworkTaskProtocol> task);

@protocol HyNetworkProtocol <NSObject>

+ (instancetype)networkWithCache:(id<HyNetworkCacheProtocol>)cache;

- (id<HyNetworkTaskProtocol>)getShowHUD:(BOOL)showHUD
                                  cache:(BOOL)cache
                                    url:(NSString *_Nullable)url
                              parameter:(NSDictionary *_Nullable)parameter
                           successBlock:(HyNetworkSuccessBlock)successBlock
                           failureBlock:(HyNetworkFailureBlock)failureBlock;


- (id<HyNetworkTaskProtocol>)postShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;


- (id<HyNetworkTaskProtocol>)postShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                           formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkTaskProtocol>)headShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkTaskProtocol>)putShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkTaskProtocol>)patchShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkTaskProtocol>)deleteShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *_Nullable)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock;


- (HyNetworStatus)networkStatus;
- (void)addNetworkStatusChangeBlock:(HyNetworkStatusBlock)block key:(NSString *)key;
- (void)removeNetworkStatusChangeBlockWithKey:(NSString *)key;

- (NSArray<id<HyNetworkTaskProtocol>> *)resumingTasks;
- (NSArray<id<HyNetworkTaskProtocol>> *)willResumeTasks;
- (void)cancleAllResumingTasks;
- (void)removeAllWillResumeTasks;


@end

NS_ASSUME_NONNULL_END
