//
//  HyNetworkMutipleTasksInfo.m
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkMutipleTasksInfo.h"

@interface HyNetworkMutipleTasksInfo ()
@property (nonatomic,assign) BOOL tasksShowHUD;
@property (nonatomic,strong) NSArray<id<HyNetworkBaseTaskInfoProtocol>> *tasksTask;
@property (nonatomic,copy) HyNetworkMutipleTasksCompletionBlock tasksCompletionBlock;
@end

@implementation HyNetworkMutipleTasksInfo
@synthesize taskStatus = _taskStatus;

+ (instancetype)taskInfoWithShowHUD:(BOOL)showHUD
                              tasks:(NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)tasks
                    completionBlock:(HyNetworkMutipleTasksCompletionBlock)completionBlock {
    
    HyNetworkMutipleTasksInfo *info = [[self alloc] init];
    info.tasksShowHUD = showHUD;
    info.tasksTask = tasks;
    info.tasksCompletionBlock = [completionBlock copy];
    return info;
}

- (BOOL)showHUD {
    return self.tasksShowHUD;
}

- (NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)tasks {
    return self.tasksTask;
}

- (HyNetworkMutipleTasksCompletionBlock)completionBlock {
    return self.tasksCompletionBlock;
}

@end
