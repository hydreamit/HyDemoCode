//
//  AFNetworkTask.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFMultipartFormDataObject.h"
#import "HyNetworkSuccessObject.h"
#import "HyNetworkFailureObject.h"
#import "AFNetworkSingleTask.h"
#import "HyNetworkProtocol.h"
#import "HyTipText.h"
#import "HyHUD.h"
#import "NSObject+HyNetwork.h"


@interface AFNetworkSingleTask ()
@property (nonatomic,assign) BOOL haveResumeObject;
@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;
@property (nonatomic,strong) id<HyNetworkSingleTaskInfoProtocol> networkTaskInfo;
@property (nonatomic,weak) id<HyNetworkProtocol> netWork;
@end


@implementation AFNetworkSingleTask
@synthesize successObject = _successObject, failureObject = _failureObject;

+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkSingleTaskInfoProtocol>)taskInfo {
    
    AFNetworkSingleTask *task = [[self alloc] init];
    task.netWork = netWork;
    task.networkTaskInfo = taskInfo;
    return task;
}

- (id<HyNetworkSingleTaskInfoProtocol>)taskInfo {
    return self.networkTaskInfo;
}

- (instancetype)resume {
  return  self.resumeAtObjcet(nil);
}

- (instancetype (^)(NSObject *object))resumeAtObjcet {
    return ^(NSObject *object) {
        
        if (self.taskInfo.taskStatus == HyNetworkTaskStatusResuming) {
            return self;
        }
        
        if (object) {
            self.haveResumeObject = YES;
            [object.hy_networkTaskContainer.tasks addObject:self];
        }

        //UIView *hudForView = UIViewController.hy_currentViewController.view;
        UIView *hudForView = nil;
        NSString *cacheKey  = @"";
        if (self.taskInfo.cache && self.taskInfo.url.length > 0) { cacheKey = self.taskInfo.url; }
        
        if (self.netWork.networkStatus == HyNetworStatusNotReachable ||
            self.netWork.networkStatus == HyNetworStatusUnKnown) {
            ShowTipText(@"当前网络不可用\n请检查网络设置");
            
            self.taskInfo.taskStatus = HyNetworkTaskStatusResumedNoNetwork;
            
            if (self.netWork.noNetworkResumedSingleTasks.count > 20) {
                [self.netWork.noNetworkResumedSingleTasks removeObjectAtIndex:0];
            }
            
            if ([self.netWork.noNetworkResumedSingleTasks containsObject:self]) {
                [self.netWork.noNetworkResumedSingleTasks removeObject:self];
            }
            [self.netWork.noNetworkResumedSingleTasks addObject:self];
            
            if (!self.haveResumeObject || object) {
                
                BOOL isCacheAndHaveCacheDate = NO;
                if (self.taskInfo.cache) {
                   id cacheDate = [self.netWork.networkCache getCacheForKey:cacheKey];
                   isCacheAndHaveCacheDate = (BOOL)cacheDate;
                   if (isCacheAndHaveCacheDate) {
                       self.successObject = NetworkSuccessObject(cacheDate, self);
                   }
               }
               if (!isCacheAndHaveCacheDate) {
                   self.failureObject = NetworkFailureObject(nil, self);
               }
               
               isCacheAndHaveCacheDate ?
               (!self.taskInfo.successBlock ?: self.taskInfo.successBlock(self.successObject)) :
               (!self.taskInfo.failureBlock ?: self.taskInfo.failureBlock(self.failureObject));
                
                if (object) {
                    [object.hy_networkTaskContainer.tasks removeObject:self];
                }
            }
           
            
            if ([self.netWork.noResumeSingleTasks containsObject:self]) {
                [self.netWork.noResumeSingleTasks removeObject:self];
            }
            
            return self;
        }
        
        if (self.taskInfo.showHUD) {
            ShowHUD(hudForView);
        }

        void (^success)(NSURLSessionDataTask *, id) =
           ^(NSURLSessionDataTask * _Nonnull sessionDataTask, id  _Nullable responseObject){
               DismissHUD(hudForView);
               !self.taskInfo.cache ?: [self.netWork.networkCache setCache:responseObject forKey:cacheKey];
               self.taskInfo.taskStatus = HyNetworkTaskStatusSuccess;
               self.successObject = NetworkSuccessObject(responseObject, self);
               if (!self.haveResumeObject || object) {
                   !self.taskInfo.successBlock ?: self.taskInfo.successBlock(self.successObject);
                   if (object) {
                       [object.hy_networkTaskContainer.tasks removeObject:self];
                   }
               }
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                             (int64_t)(.1 * NSEC_PER_SEC)),
               dispatch_get_main_queue(), ^{
                   [self.netWork.resumingSingleTasks removeObject:self];
               });
           };

           void (^failure)(NSURLSessionDataTask *, NSError *) =
           ^(NSURLSessionDataTask * _Nonnull sessionDataTask, NSError * _Nonnull error){
               DismissHUD(hudForView);
               
               self.taskInfo.taskStatus = HyNetworkTaskStatusFailure;
               self.failureObject = NetworkFailureObject(error, self);
               
               if (self.taskInfo.cache) {
                   id cacheDate = [self.netWork.networkCache getCacheForKey:cacheKey];
                   self.successObject = NetworkSuccessObject(cacheDate, self);
                   if (!self.haveResumeObject || object) {
                       !cacheDate ?: (!self.taskInfo.successBlock ?: self.taskInfo.successBlock(self.successObject));
                   }
               }
               if (!self.haveResumeObject || object) {
                   !self.taskInfo.failureBlock ?: self.taskInfo.failureBlock(self.failureObject);
               }
               
               if (object) {
                   [object.hy_networkTaskContainer.tasks removeObject:self];
               }

               [self handleNetworkError:error];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                             (int64_t)(.1 * NSEC_PER_SEC)),
               dispatch_get_main_queue(), ^{
                   [self.netWork.resumingSingleTasks removeObject:self];
               });
           };
        
        self.taskInfo.taskStatus = HyNetworkTaskStatusResuming;
        
        switch (self.taskInfo.requestType) {
            case HyNetworRequestTypeGet:{
                self.sessionTask =
               [self.netWork.sessionManager GET:self.taskInfo.url
                                     parameters:self.taskInfo.parameter
                                        headers:nil
                                       progress:nil
                                        success:success
                                        failure:failure];
            }break;
            case HyNetworRequestTypePost:{
                self.sessionTask =
                [self.netWork.sessionManager POST:self.taskInfo.url
                                      parameters:self.taskInfo.parameter
                                          headers:nil
                                        progress:nil
                                         success:success
                                         failure:failure];
            }break;
            case HyNetworRequestTypePostFormData:{
                self.sessionTask =
                [self.netWork.sessionManager POST:self.taskInfo.url
                                      parameters:self.taskInfo.parameter
                                          headers:nil
                        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                        !self.taskInfo.formData ?: self.taskInfo.formData([AFMultipartFormDataObject object:formData]);
                    }
                                        progress:nil
                                         success:success
                                         failure:failure];
            }break;
            case HyNetworRequestTypeHead:{
                self.sessionTask =
                [self.netWork.sessionManager HEAD:self.taskInfo.url
                                       parameters:self.taskInfo.parameter
                                          headers:nil
                                          success:^(NSURLSessionDataTask * _Nonnull sessionDataTask) {
                        self.taskInfo.taskStatus = HyNetworkTaskStatusSuccess;
                        !self.taskInfo.successBlock ?: self.taskInfo.successBlock(NetworkSuccessObject(nil, self));
                       [self.netWork.resumingSingleTasks removeObject:self];
                   }
                   failure:failure];
            }break;
            case HyNetworRequestTypePut:{
                self.sessionTask =
                 [self.netWork.sessionManager PUT:self.taskInfo.url
                                       parameters:self.taskInfo.parameter
                                          headers:nil
                                          success:success
                                          failure:failure];
            }break;
            case HyNetworRequestTypePatch:{
                self.sessionTask =
                [self.netWork.sessionManager PATCH:self.taskInfo.url
                                        parameters:self.taskInfo.parameter
                                           headers:nil
                                           success:success
                                           failure:failure];
            }break;
            case HyNetworRequestTypeDelete:{
                self.sessionTask =
                [self.netWork.sessionManager DELETE:self.taskInfo.url
                                         parameters:self.taskInfo.parameter
                                            headers:nil
                                            success:success
                                            failure:failure];
            }break;
            default:
            break;
        }
        
        if (![self.netWork.resumingSingleTasks containsObject:self]) {
            [self.netWork.resumingSingleTasks addObject:self];
        }
        if ([self.netWork.noResumeSingleTasks containsObject:self]) {
            [self.netWork.noResumeSingleTasks removeObject:self];
        }
        if ([self.netWork.noNetworkResumedSingleTasks containsObject:self]) {
            [self.netWork.noNetworkResumedSingleTasks removeObject:self];
        }
       
        return self;
    };
}

- (void)cancel {
    if (self.taskInfo.taskStatus == HyNetworkTaskStatusResuming) {
        if (self.sessionTask.state != NSURLSessionTaskStateCanceling &&
            self.sessionTask.state != NSURLSessionTaskStateCompleted) {
            [self.sessionTask cancel];
        }
    }
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
    ShowTipText(errorTitle);
}

@end
