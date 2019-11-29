//
//  AFNetworkTaskInfo.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "AFNetworkTaskInfo.h"
#import <objc/message.h>


@interface AFNetworkTaskInfo ()
@property (nonatomic,assign) BOOL taskCache;
@property (nonatomic,assign) BOOL taskShowHUD;
@property (nonatomic,copy) NSString *taskUrl;
@property (nonatomic,strong) NSDictionary *taskParameter;
@property (nonatomic,copy) HyNetworkSuccessBlock taskSuccessBlock;
@property (nonatomic,copy) HyNetworkFailureBlock taskFailureBlock;
@property (nonatomic,copy) HyNetworkFormDataBlock taskFormDataBlock;
@property (nonatomic,assign) HyNetworRequestType taskRequestType;
@end


@implementation AFNetworkTaskInfo

+ (instancetype)taskInfoWithRequestType:(HyNetworRequestType)type
                                showHUD:(BOOL)showHUD
                                  cache:(BOOL)cache
                                    url:(NSString *)url
                              parameter:(nullable id)parameter
                          formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                           successBlock:(nullable HyNetworkSuccessBlock)successBlock
                           failureBlock:(nullable HyNetworkFailureBlock)failureBlock {
    
    AFNetworkTaskInfo *info = [[self alloc] init];
    info.taskRequestType = type;
    info.taskShowHUD = showHUD;
    info.taskCache = cache;
    info.taskUrl = url;
    info.taskParameter = parameter;
    info.taskFormDataBlock = [formDataBlock copy];
    info.taskSuccessBlock = [successBlock copy];
    info.taskFailureBlock = [failureBlock copy];
    return info;
}

- (HyNetworRequestType)requestType {
    return self.taskRequestType;
}

- (BOOL)cache {
    return self.taskCache;
}

- (BOOL)showHUD {
    return self.taskShowHUD;
}

- (NSString *)url {
    return self.taskUrl;
}

- (NSDictionary *)parameter {
    return self.taskParameter;
}

- (nullable HyNetworkSuccessBlock)successBlock {
    return self.taskSuccessBlock;
}

- (nullable HyNetworkFailureBlock)failureBlock {
    return self.taskFailureBlock;
}

- (void)setTaskStatus:(HyNetworkTaskStatus)taskStatus {
    objc_setAssociatedObject(self,
                             @selector(taskStatus),
                             [NSNumber numberWithInteger:taskStatus],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HyNetworkTaskStatus)taskStatus {
    HyNetworkTaskStatus status = HyNetworkTaskStatusWillResume;
    NSNumber *value = objc_getAssociatedObject(self, _cmd);
    if (value != NULL) {
        status = value.integerValue;
    }
    return status;
}

@end
