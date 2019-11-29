//
//  AFNetworkTask.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFNetworkTask.h"
#import <objc/message.h>


@interface AFNetworkTask ()
@property (nonatomic,strong) id<HyNetworkTaskInfoProtocol> networkTaskInfo;
@property (nonatomic,weak) id<HyNetworkProtocol> netWork;
@end


@implementation AFNetworkTask

+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkTaskInfoProtocol>)taskInfo {
    AFNetworkTask *task = [[self alloc] init];
    task.netWork = netWork;
    task.networkTaskInfo = taskInfo;
    return task;
}

- (id<HyNetworkTaskInfoProtocol>)taskInfo {
    return self.networkTaskInfo;
}

- (void)resume {
    
    if (self.networkTaskInfo) {
        
        switch (self.networkTaskInfo.requestType) {
            case HyNetworRequestTypeGet: {
                [self.netWork getShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypePost: {
                [self.netWork postShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypePostFormData: {
                [self.netWork postShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                           formDataBlock:self.networkTaskInfo.formData
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypeHead: {
                [self.netWork headShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypePut: {
                [self.netWork putShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypePatch: {
                [self.netWork patchShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            case HyNetworRequestTypeDelete: {
                [self.netWork deleteShowHUD:self.networkTaskInfo.showHUD
                                   cache:self.networkTaskInfo.cache
                                     url:self.networkTaskInfo.url
                               parameter:self.networkTaskInfo.parameter
                            successBlock:self.networkTaskInfo.successBlock
                            failureBlock:self.networkTaskInfo.failureBlock];
            }break;
            default:
            break;
        }
        if ([self.netWork.willResumeTasks containsObject:self]) {
            [((NSMutableArray *)self.netWork.willResumeTasks) removeObject:self];
        }
    }
}

- (void)cancel{
    [self.sessionTask cancel];
    if ([self.netWork.willResumeTasks containsObject:self]) {
        [((NSMutableArray *)self.netWork.willResumeTasks) removeObject:self];
    }
}

@end
