//
//  HyNetworkMutipleTasks.m
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkMutipleTasks.h"
#import "HyNetworkCompletionObject.h"
#import "HyNetworkSignleTaskInfo.h"
#import "HyNetworkProtocol.h"
#import "HyTipText.h"
#import "HyHUD.h"
#import "NSObject+HyNetwork.h"


@interface HyNetworkMutipleTasks ()
@property (nonatomic,assign) BOOL haveResumeObject;
@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;
@property (nonatomic,strong) id<HyNetworkMutipleTasksInfoProtocol> networkTaskInfo;
@property (nonatomic,strong) NSMutableArray<id<HyNetworkSingleTaskProtocol>> *singleTasks;
@property (nonatomic,weak) id<HyNetworkProtocol> netWork;
@end


@implementation HyNetworkMutipleTasks
@synthesize completionObject = _completionObject, allSuccess = _allSuccess;
+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkMutipleTasksInfoProtocol>)taskInfo {
    
    HyNetworkMutipleTasks *task = [[self alloc] init];
    task.netWork = netWork;
    task.networkTaskInfo = taskInfo;
    return task;
}

- (id<HyNetworkMutipleTasksInfoProtocol>)taskInfo {
    return self.networkTaskInfo;
}

- (instancetype)resume {
   return self.resumeAtObjcet(nil);
}

- (instancetype (^)(NSObject * object))resumeAtObjcet {
    return ^(NSObject * object){
        
        if (self.taskInfo.taskStatus == HyNetworkTaskStatusResuming) {
            return self;
        }
        
        if (object) {
            self.haveResumeObject = YES;
        }

        if (self.netWork.networkStatus == HyNetworStatusNotReachable ||
            self.netWork.networkStatus == HyNetworStatusUnKnown) {
            
            ShowTipText(@"当前网络不可用\n请检查网络设置");
            
            self.taskInfo.taskStatus = HyNetworkTaskStatusResumedNoNetwork;
            
            if (self.netWork.noNetworkResumedMutipleTasks.count > 10) {
                [self.netWork.noNetworkResumedMutipleTasks removeObjectAtIndex:0];
            }
            if ([self.netWork.noNetworkResumedMutipleTasks containsObject:self]) {
                [self.netWork.noNetworkResumedMutipleTasks removeObject:self];
            }
            [self.netWork.noNetworkResumedMutipleTasks addObject:self];
            
            if (!self.haveResumeObject || object) {
                BOOL allComletion = YES;
                NSMutableArray<id<HyNetworkCompletionProtocol>> *mArray = @[].mutableCopy;
                for (id<HyNetworkBaseTaskInfoProtocol> taskInfo in self.networkTaskInfo.tasks) {
                     NSString *cacheKey  = @"";
                     if (taskInfo.cache && taskInfo.url.length > 0) { cacheKey = taskInfo.url; }
                     id cacheDate = nil;
                     if (taskInfo.cache) {
                         cacheDate = [self.netWork.networkCache getCacheForKey:cacheKey];
                         if (!cacheDate) {
                             allComletion = NO;
                         }
                     } else {
                         allComletion = NO;
                     }
                    [mArray addObject:NetworkCompletionObject(cacheDate, nil, self)];
                }
                self.taskInfo.completionBlock ?: self.taskInfo.completionBlock(mArray, allComletion);
            }

            return self;
        }

       // UIView *hudForView = UIViewController.hy_currentViewController.view;
        if (self.taskInfo.showHUD) {
            ShowHUD(nil);
        }
        
        NSMutableArray<id<HyNetworkCompletionProtocol>> *completions = @[].mutableCopy;
        for (NSInteger index = 0; index < self.taskInfo.tasks.count; index ++) {
            [completions addObject:NetworkCompletionObject(nil, nil, self)];
        }
        
        __block BOOL allCompletion = YES;
        
        dispatch_group_t group = dispatch_group_create();
        HyNetworkSuccessBlock (^success)(NSInteger) = ^(NSInteger index){
            return ^(id<HyNetworkSuccessProtocol>  _Nullable successObject){
                        successObject.task.taskInfo.taskStatus = HyNetworkTaskStatusSuccess;
                        !successObject.task.taskInfo.cache ?: [self.netWork.networkCache setCache:successObject.response forKey:successObject.task.taskInfo.url];
                        [completions replaceObjectAtIndex:index withObject:NetworkCompletionObject(successObject.response, nil, self)];
                        dispatch_group_leave(group);
                    };
        };
        
        HyNetworkFailureBlock (^failure)(NSInteger) = ^(NSInteger index){
            return  ^(id<HyNetworkFailureProtocol>  _Nullable failureObject){
                        failureObject.task.taskInfo.taskStatus = HyNetworkTaskStatusFailure;
                        id cacheDate = nil;
                        if (failureObject.task.taskInfo.cache) {
                            cacheDate = [self.netWork.networkCache getCacheForKey:failureObject.task.taskInfo.url];
                        }
                        if (!cacheDate) { allCompletion = NO; }
                        [completions replaceObjectAtIndex:index withObject:NetworkCompletionObject(cacheDate, failureObject.error, self)];
                        dispatch_group_leave(group);
                    };
        };

        [self.singleTasks removeAllObjects];
        self.taskInfo.taskStatus = HyNetworkTaskStatusResuming;
        for (id<HyNetworkBaseTaskInfoProtocol> taskInfo in self.networkTaskInfo.tasks) {
            NSInteger index = [self.networkTaskInfo.tasks indexOfObject:taskInfo];
            HyNetworkSignleTaskInfo *signleTask =
            [HyNetworkSignleTaskInfo taskInfoWithRequestType:taskInfo.requestType
                                                     cache:taskInfo.cache
                                                       url:taskInfo.url
                                                 parameter:taskInfo.parameter
                                             formDataBlock:taskInfo.formData];
            [signleTask setShowHUD:NO successBlock:success(index) failureBlock:failure(index)];
            id<HyNetworkSingleTaskProtocol> task = [self.signleTaskClass taskWithNetwork:self.netWork taskInfo:signleTask];
            task.taskInfo.taskStatus = HyNetworkTaskStatusResuming;
            [self.singleTasks addObject:task];
            dispatch_group_enter(group);
            dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                task.resumeAtObjcet(object);
            });
        }
        
        if (![self.netWork.resumingMutipleTasks containsObject:self]) {
            [self.netWork.resumingMutipleTasks addObject:self];
        }
        if ([self.netWork.noResumeMutipleTasks containsObject:self]) {
            [self.netWork.noResumeMutipleTasks removeObject:self];
        }
        if ([self.netWork.noNetworkResumedMutipleTasks containsObject:self]) {
            [self.netWork.noNetworkResumedMutipleTasks removeObject:self];
        }
        
 
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            DismissHUD(nil);
            self.allSuccess = allCompletion;
            self.completionObject = [NSArray arrayWithArray:completions];
            self.taskInfo.taskStatus = allCompletion ? HyNetworkTaskStatusSuccess : HyNetworkTaskStatusFailure;
            if (!self.haveResumeObject || object) {
                self.taskInfo.completionBlock ?: self.taskInfo.completionBlock(self.completionObject, allCompletion);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                          (int64_t)(.1 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                [self.netWork.resumingMutipleTasks removeObject:self];
            });
        });
        
        return self;
    };
}

- (void)cancel {
    [self.singleTasks makeObjectsPerformSelector:@selector(cancel)];
    [self.singleTasks removeAllObjects];
}

- (NSMutableArray<id<HyNetworkSingleTaskProtocol>> *)singleTasks {
    if (!_singleTasks){
        _singleTasks = @[].mutableCopy;
    }
    return _singleTasks;
}

@end
