//
//  AFNetwork.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "AFNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkTaskInfo.h"
#import "AFNetworkTask.h"
#import "AFMultipartFormDataObject.h"
#import "HyNetworkCacheProtocol.h"
#import <HyCategoriess/HyCategories.h>
#import "HyHUD.h"


@interface AFNetwork ()
@property (nonatomic,strong) id<HyNetworkCacheProtocol> networkCache;
@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,assign) HyNetworStatus currentNetworkStatus;
@property (nonatomic,strong) NSMutableDictionary<NSString *, HyNetworkStatusBlock> *networkStatusBlockDict;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkTaskProtocol>> *willResumeTasksArray;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkTaskProtocol>> *resumingTasksArray;
@end


@implementation AFNetwork

+ (instancetype)networkWithCache:(id<HyNetworkCacheProtocol>)cache {
    AFNetwork *netWork = [[self alloc] init];
    netWork.networkCache = cache;
    return netWork;
}

- (id<HyNetworkTaskProtocol>)getShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)postShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)postShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)headShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)putShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)patchShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)deleteShowHUD:(BOOL)showHUD
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

- (id<HyNetworkTaskProtocol>)requestType:(HyNetworRequestType)type
                                  showHUD:(BOOL)showHUD
                                    cache:(BOOL)cache
                                      url:(NSString *)url
                                parameter:(NSDictionary *)parameter
                            formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                             successBlock:(HyNetworkSuccessBlock)successBlock
                             failureBlock:(HyNetworkFailureBlock)failureBlock {
    
        if (showHUD) {
            ShowHUD(UIViewController.hy_currentViewController.view);
        }
    
         NSString *currentUrl = @"https://www.baidu.com";
         if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
             currentUrl = url;
         } else {
             if (url.length > 0 ) {
                 if ([currentUrl hasSuffix:@"/"] || [url hasSuffix:@"/"]) {
                      currentUrl = [NSString stringWithFormat:@"%@%@", currentUrl, url];
                 } else {
                      currentUrl = [NSString stringWithFormat:@"%@/%@", currentUrl, url];
                 }
             }
         }
    
      AFNetworkTaskInfo *taskInfo =[AFNetworkTaskInfo taskInfoWithRequestType:type
                                                                      showHUD:showHUD
                                                                        cache:cache
                                                                          url:url
                                                                    parameter:parameter
                                                                formDataBlock:formDataBlock
                                                                 successBlock:successBlock
                                                                 failureBlock:failureBlock];
       AFNetworkTask *task = [AFNetworkTask taskWithNetwork:self taskInfo:taskInfo];
           
        NSString *cacheKey  = @"";
        if (cache && currentUrl.length > 0) { cacheKey = currentUrl; }
        
        if (self.currentNetworkStatus == HyNetworStatusNotReachable ||
            self.currentNetworkStatus == HyNetworStatusUnKnown) {
            
            NSLog(@" 当前网络不可用 \n 请检查网络设置 ");
            
            if (self.willResumeTasksArray.count > 20) {
                [self.willResumeTasksArray removeObjectAtIndex:0];
            }
            [self.willResumeTasksArray addObject:task];
            
            BOOL isCacheAndHaveCacheDate = NO;
            if (cache) {
                id cacheDate = [self.networkCache getCacheForKey:cacheKey];
                isCacheAndHaveCacheDate = (BOOL)cacheDate;
                !cacheDate ?: (!successBlock ?: successBlock(cacheDate, task));
            }
            isCacheAndHaveCacheDate ?: (!failureBlock ?: failureBlock(nil, task));
            
            DismissHUD;

            return task;
        }
    
    task.taskInfo.taskStatus = HyNetworkTaskStatusResuming;
    [self.resumingTasksArray addObject:task];
    
    void (^success)(NSURLSessionDataTask *, id) =
    ^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject){
        DismissHUD;
        task.taskInfo.taskStatus = HyNetworkTaskStatusSuccess;
        !cache ?: [self.networkCache setCache:responseObject forKey:cacheKey];
        !successBlock ?: successBlock(responseObject, task);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(.1 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [self.resumingTasksArray removeObject:task];
        });
    };
    
    void (^failure)(NSURLSessionDataTask *, NSError *) =
    ^(NSURLSessionDataTask * _Nonnull sessionDataTask, NSError * _Nonnull error){
        DismissHUD;
        task.taskInfo.taskStatus = HyNetworkTaskStatusFailure;
        if (cache) {
            id cacheDate = [self.networkCache getCacheForKey:cacheKey];
            !cacheDate ? : (!successBlock ? : successBlock(cacheDate, task));
        }
        !failureBlock ?: failureBlock(error, task);
        
        [self handleNetworkError:error];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(.1 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [self.resumingTasksArray removeObject:task];
        });
    };

    switch (type) {
        case HyNetworRequestTypeGet:{
            task.sessionTask = [self.sessionManager GET:currentUrl
                                             parameters:parameter
                                               progress:nil
                                                success:success
                                                failure:failure];
        }break;
        case HyNetworRequestTypePost:{
            task.sessionTask = [self.sessionManager POST:currentUrl
                                              parameters:parameter
                                                progress:nil
                                                 success:success
                                                 failure:failure];
        }break;
        case HyNetworRequestTypePostFormData:{
            task.sessionTask =
            [self.sessionManager POST:currentUrl
                           parameters:parameter
            constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                !formDataBlock ?: formDataBlock([AFMultipartFormDataObject object:formData]);
            }
                             progress:nil
                              success:success
                              failure:failure];
        }break;
        case HyNetworRequestTypeHead:{
            task.sessionTask = [self.sessionManager HEAD:currentUrl
                                             parameters:parameter
                                                 success:^(NSURLSessionDataTask * _Nonnull sessionDataTask) {
                                                    task.taskInfo.taskStatus = HyNetworkTaskStatusSuccess;
                                                    !successBlock ?: successBlock(nil, task);
                                                    [self.resumingTasksArray removeObject:task];
                                                }
                                                failure:failure];
        }break;
        case HyNetworRequestTypePut:{
            task.sessionTask = [self.sessionManager PUT:currentUrl
                                             parameters:parameter
                                                success:success
                                                failure:failure];
        }break;
        case HyNetworRequestTypePatch:{
            task.sessionTask = [self.sessionManager PATCH:currentUrl
                                               parameters:parameter
                                                  success:success
                                                  failure:failure];
        }break;
        case HyNetworRequestTypeDelete:{
            task.sessionTask = [self.sessionManager DELETE:currentUrl
                                                parameters:parameter
                                                   success:success
                                                   failure:failure];
        }break;
        default:
        break;
    }
    return task;
}

- (void)handleNetworkError:(NSError *)error {
    
    NSString *errorTitle = @"网络连接失败";
    switch (error.code) {
        case NSURLErrorCancelled:
        {
            errorTitle = nil;
        }break;
        case NSURLErrorBadURL:
        {
            errorTitle = @"链接URL错误";
        }break;
        case NSURLErrorTimedOut:
        {
            errorTitle = @"网络连接超时";
        }break;
        case NSURLErrorCannotFindHost:
        {
            errorTitle = @"找不到服务器";
        }break;
        case NSURLErrorCannotConnectToHost:
        {
            errorTitle = @"连接不上服务器";
        }break;
        default:
        break;
    }

    NSLog(@"error======%@", error.description);
}

- (NSArray<id<HyNetworkTaskProtocol>> *)resumingTasks {
    return self.resumingTasksArray;
}

- (NSArray<id<HyNetworkTaskProtocol>> *)willResumeTasks {
    return self.willResumeTasksArray;
}

- (void)cancleAllResumingTasks {
    [self.resumingTasksArray makeObjectsPerformSelector:@selector(cancel)];
}

- (void)removeAllWillResumeTasks {
    [self.willResumeTasksArray removeAllObjects];
}

- (HyNetworStatus)networkStatus {
    return self.currentNetworkStatus;
}

- (void)addNetworkStatusChangeBlock:(HyNetworkStatusBlock)block key:(NSString *)key {
    if (key.length && block && ![self.networkStatusBlockDict.allKeys containsObject:key]) {
        [self.networkStatusBlockDict setObject:block forKey:key];
    }
}

- (void)removeNetworkStatusChangeBlockWithKey:(NSString *)key {
    
    if (key.length && [self.networkStatusBlockDict.allKeys containsObject:key]) {
        [self.networkStatusBlockDict removeObjectForKey:key];
    }
}

- (void)networkStatusStartMonitoring {
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        HyNetworStatus lastStatus = self.currentNetworkStatus;
        if (status == AFNetworkReachabilityStatusNotReachable){
            self.currentNetworkStatus = HyNetworStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            self.currentNetworkStatus = HyNetworStatusUnKnown;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            self.currentNetworkStatus = HyNetworStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            self.currentNetworkStatus = HyNetworStatusReachbleViaWiFi;
        }
                
        for (HyNetworkStatusBlock block in self.networkStatusBlockDict.allValues) {
            block(self.currentNetworkStatus, lastStatus);
        }
    }];
    [reachabilityManager startMonitoring];
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager){
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 30;
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _sessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _sessionManager.responseSerializer.acceptableContentTypes =
         [NSSet setWithArray:@[@"application/json",
                               @"text/html",
                               @"text/json",
                               @"text/plain",
                               @"text/javascript",
                               @"text/xml",
                               @"image/*",
                               @"text/css",
                               @"text/html;charset=UTF-8",
                               @"application/x-www-form-urlencoded",
                               @"multipart/form-data"
                               ]];
        [self networkStatusStartMonitoring];
    }
    return _sessionManager;
}

- (NSMutableDictionary<NSString *,HyNetworkStatusBlock> *)networkStatusBlockDict {
    if (!_networkStatusBlockDict){
        _networkStatusBlockDict = @{}.mutableCopy;
    }
    return _networkStatusBlockDict;
}

- (NSMutableArray<id<HyNetworkTaskProtocol>> *)willResumeTasksArray {
    if (!_willResumeTasksArray){
        _willResumeTasksArray = @[].mutableCopy;
    }
    return _willResumeTasksArray;
}

- (NSMutableArray<id<HyNetworkTaskProtocol>> *)resumingTasksArray {
    if (!_resumingTasksArray){
        _resumingTasksArray = @[].mutableCopy;
    }
    return _resumingTasksArray;
}

@end
