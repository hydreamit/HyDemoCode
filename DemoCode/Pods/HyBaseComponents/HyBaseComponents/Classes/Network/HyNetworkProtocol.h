//
//  HyNetworkProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkCacheProtocol.h"
#import "HyNetworkTypedef.h"
#import "HyNetworkSingleTaskProtocol.h"
#import "HyNetworkMutipleTasksProtocol.h"
#import "HyNetworkSuccessProtocol.h"
#import "HyMultipartFormDataProtocol.h"
#import "HyNetworkFailureProtocol.h"
#import "HyNetworkCompletionProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkBaseTaskInfoProtocol;
@protocol HyNetworkProtocol<NSObject>
@optional

+ (instancetype)networkWithCache:(id<HyNetworkCacheProtocol>)cache;

- (id)sessionManager;
- (id<HyNetworkCacheProtocol>)networkCache;

- (id<HyNetworkSingleTaskProtocol>)getShowHUD:(BOOL)showHUD
                                      cache:(BOOL)cache
                                        url:(NSString *_Nullable)url
                                  parameter:(NSDictionary *_Nullable)parameter
                               successBlock:(HyNetworkSuccessBlock)successBlock
                               failureBlock:(HyNetworkFailureBlock)failureBlock;


- (id<HyNetworkSingleTaskProtocol>)postShowHUD:(BOOL)showHUD
                                       cache:(BOOL)cache
                                         url:(NSString *_Nullable)url
                                   parameter:(NSDictionary *_Nullable)parameter
                                successBlock:(HyNetworkSuccessBlock)successBlock
                                failureBlock:(HyNetworkFailureBlock)failureBlock;


- (id<HyNetworkSingleTaskProtocol>)postShowHUD:(BOOL)showHUD
                                       cache:(BOOL)cache
                                         url:(NSString *_Nullable)url
                                   parameter:(NSDictionary *_Nullable)parameter
                               formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                                successBlock:(HyNetworkSuccessBlock)successBlock
                                failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkSingleTaskProtocol>)headShowHUD:(BOOL)showHUD
                                       cache:(BOOL)cache
                                         url:(NSString *_Nullable)url
                                   parameter:(NSDictionary *_Nullable)parameter
                                successBlock:(HyNetworkSuccessBlock)successBlock
                                failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkSingleTaskProtocol>)putShowHUD:(BOOL)showHUD
                                       cache:(BOOL)cache
                                         url:(NSString *_Nullable)url
                                   parameter:(NSDictionary *_Nullable)parameter
                                successBlock:(HyNetworkSuccessBlock)successBlock
                                failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkSingleTaskProtocol>)patchShowHUD:(BOOL)showHUD
                                          cache:(BOOL)cache
                                            url:(NSString *_Nullable)url
                                      parameter:(NSDictionary *_Nullable)parameter
                                   successBlock:(HyNetworkSuccessBlock)successBlock
                                   failureBlock:(HyNetworkFailureBlock)failureBlock;

- (id<HyNetworkSingleTaskProtocol>)deleteShowHUD:(BOOL)showHUD
                                           cache:(BOOL)cache
                                             url:(NSString *_Nullable)url
                                       parameter:(NSDictionary *_Nullable)parameter
                                    successBlock:(HyNetworkSuccessBlock)successBlock
                                    failureBlock:(HyNetworkFailureBlock)failureBlock;



//- (id<HyNetworkSingleTaskInfoProtocol>)requestSignaTask:(id<HyNetworkSingleTaskInfoProtocol>)taskInfo;

- (id<HyNetworkSingleTaskInfoProtocol>)requestSignaTask:(void(^)(id<HyNetworkSingleTaskInfoProtocol> task))block;


- (id<HyNetworkMutipleTasksProtocol>)requestShowHUD:(BOOL)showHUD
                                          taskInfos:(NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)taskInfos
                                         completion:(HyNetworkMutipleTasksCompletionBlock)completion;


- (HyNetworStatus)networkStatus;
- (void)addNetworkStatusChangeBlock:(HyNetworkStatusBlock)block key:(NSString *)key;
- (void)removeNetworkStatusChangeBlockWithKey:(NSString *)key;

- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)resumingSingleTasks;
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)noResumeSingleTasks;
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)noNetworkResumedSingleTasks;
- (void)cancleAllResumingSingleTasks;


- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)resumingMutipleTasks;
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)noResumeMutipleTasks;
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)noNetworkResumedMutipleTasks;
- (void)cancleAllResumingResumedTasks;

@end

NS_ASSUME_NONNULL_END
