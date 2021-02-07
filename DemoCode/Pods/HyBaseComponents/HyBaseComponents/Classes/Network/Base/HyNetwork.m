//
//  HyNetwork.m
//  DemoCode
//
//  Created by Hy on 2017/12/13.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetwork.h"
#import "HyNetworkCacheProtocol.h"
#import "HyNetworkSignleTaskInfo.h"
#import "HyNetworkMutipleTasksProtocol.h"
#import "HyNetworkMutipleTasksInfo.h"
#import "HyNetworkMutipleTasks.h"


@interface HyNetwork ()
@property (nonatomic,strong) id<HyNetworkCacheProtocol> networkCache;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkSingleTaskProtocol>> *resumingSingleTasksArray;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkSingleTaskProtocol>> *noResumeSingleTasksArray;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkSingleTaskProtocol>> *notWorkResumedSingleTasksArray;

@property (nonatomic,strong) NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *resumingMutipleTasksArray;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *noResumeMutipleTasksArray;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *notWorkResumedMutipleTasksArray;
@end


@implementation HyNetwork

+ (instancetype)networkWithCache:(id<HyNetworkCacheProtocol>)cache {
    HyNetwork *netWork = [[self alloc] init];
    netWork.networkCache = cache;
    return netWork;
}

- (id)sessionManager {
    return nil;
}

- (id<HyNetworkSingleTaskProtocol>)getShowHUD:(BOOL)showHUD
                                  cache:(BOOL)cache
                                    url:(NSString *)url
                              parameter:(NSDictionary *)parameter
                           successBlock:(HyNetworkSuccessBlock)successBlock
                           failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
    [self requestType:HyNetworRequestTypeGet
              showHUD:showHUD
                cache:cache
                  url:url
            parameter:parameter
        formDataBlock:nil
         successBlock:successBlock
         failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)postShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
    [self requestType:HyNetworRequestTypePost
         showHUD:showHUD
           cache:cache
             url:url
       parameter:parameter
   formDataBlock:nil
    successBlock:successBlock
    failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)postShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *_Nullable)parameter
                           formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock {
     return
     [self requestType:HyNetworRequestTypePostFormData
          showHUD:showHUD
            cache:cache
              url:url
        parameter:parameter
    formDataBlock:formDataBlock
     successBlock:successBlock
     failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)headShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
    [self requestType:HyNetworRequestTypeHead
         showHUD:showHUD
           cache:cache
             url:url
       parameter:parameter
   formDataBlock:nil
    successBlock:successBlock
    failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)putShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                           failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
     [self requestType:HyNetworRequestTypePut
          showHUD:showHUD
            cache:cache
              url:url
        parameter:parameter
    formDataBlock:nil
     successBlock:successBlock
     failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)patchShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                             failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
     [self requestType:HyNetworRequestTypePatch
          showHUD:showHUD
            cache:cache
              url:url
        parameter:parameter
    formDataBlock:nil
     successBlock:successBlock
     failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)deleteShowHUD:(BOOL)showHUD
                                   cache:(BOOL)cache
                                     url:(NSString *)url
                               parameter:(NSDictionary *_Nullable)parameter
                            successBlock:(HyNetworkSuccessBlock)successBlock
                            failureBlock:(HyNetworkFailureBlock)failureBlock {
    return
     [self requestType:HyNetworRequestTypeDelete
          showHUD:showHUD
            cache:cache
              url:url
        parameter:parameter
    formDataBlock:nil
     successBlock:successBlock
     failureBlock:failureBlock];
}

- (id<HyNetworkSingleTaskProtocol>)requestType:(HyNetworRequestType)type
                                  showHUD:(BOOL)showHUD
                                    cache:(BOOL)cache
                                      url:(NSString *)url
                                parameter:(NSDictionary *)parameter
                            formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                             successBlock:(HyNetworkSuccessBlock)successBlock
                             failureBlock:(HyNetworkFailureBlock)failureBlock {
    
    HyNetworkSignleTaskInfo *signleTask =
    [HyNetworkSignleTaskInfo taskInfoWithRequestType:type
                                               cache:cache
                                                 url:url
                                           parameter:parameter
                                       formDataBlock:formDataBlock];
    [signleTask setShowHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    id<HyNetworkSingleTaskProtocol> task = [self.signleTaskClass taskWithNetwork:self taskInfo:signleTask];
    [self.noResumeSingleTasksArray addObject:task];
    return task;
}

- (id<HyNetworkMutipleTasksProtocol>)requestShowHUD:(BOOL)showHUD
                                          taskInfos:(NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)taskInfos
                                         completion:(HyNetworkMutipleTasksCompletionBlock)completion {
    
    HyNetworkMutipleTasksInfo *info = [HyNetworkMutipleTasksInfo taskInfoWithShowHUD:showHUD tasks:taskInfos completionBlock:completion];
    HyNetworkMutipleTasks *task = [HyNetworkMutipleTasks taskWithNetwork:self taskInfo:info];
    task.signleTaskClass = self.signleTaskClass;
    [self.noResumeMutipleTasksArray addObject:task];
    return task;
}

- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)resumingSingleTasks {
    return self.resumingSingleTasksArray;
}
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)noResumeSingleTasks {
    return self.noResumeSingleTasksArray;
}
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)noNetworkResumedSingleTasks {
    return self.notWorkResumedSingleTasksArray;
}

- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)resumingMutipleTasks {
    return self.resumingMutipleTasksArray;
}
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)noResumeMutipleTasks {
    return self.noResumeMutipleTasksArray;
}
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)noNetworkResumedMutipleTasks {
    return self.notWorkResumedMutipleTasksArray;
}

- (void)cancleAllResumingSingleTasks {
    [self.resumingSingleTasksArray makeObjectsPerformSelector:@selector(cancel)];
}

- (void)cancleAllResumingResumedTasks {
    [self.resumingMutipleTasksArray makeObjectsPerformSelector:@selector(cancel)];
}

- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)noResumeSingleTasksArray {
    if (!_noResumeSingleTasksArray){
        _noResumeSingleTasksArray = @[].mutableCopy;
    }
    return _noResumeSingleTasksArray;
}
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)resumingSingleTasksArray {
    if (!_resumingSingleTasksArray){
        _resumingSingleTasksArray = @[].mutableCopy;
    }
    return _resumingSingleTasksArray;
}
- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)notWorkResumedSingleTasksArray {
    if (!_notWorkResumedSingleTasksArray){
        _notWorkResumedSingleTasksArray = @[].mutableCopy;
    }
    return _notWorkResumedSingleTasksArray;
}


- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)noResumeMutipleTasksArray {
    if (!_noResumeMutipleTasksArray){
        _noResumeMutipleTasksArray = @[].mutableCopy;
    }
    return _noResumeMutipleTasksArray;
}
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)resumingMutipleTasksArray {
    if (!_resumingMutipleTasksArray){
        _resumingMutipleTasksArray = @[].mutableCopy;
    }
    return _resumingMutipleTasksArray;
}
- (NSMutableArray<id<HyNetworkMutipleTasksProtocol>> *)notWorkResumedMutipleTasksArray {
    if (!_notWorkResumedMutipleTasksArray){
        _notWorkResumedMutipleTasksArray = @[].mutableCopy;
    }
    return _notWorkResumedMutipleTasksArray;
}

- (Class<HyNetworkSingleTaskProtocol>)signleTaskClass {
    return nil;
}

@end
