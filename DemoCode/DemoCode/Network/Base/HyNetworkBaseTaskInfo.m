//
//  HyNetworkBaseTaskInfo.m
//  DemoCode
//
//  Created by Hy on 2017/12/13.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkBaseTaskInfo.h"


@interface HyNetworkBaseTaskInfo ()
@property (nonatomic,assign) BOOL taskCache;
@property (nonatomic,copy) NSString *taskUrl;
@property (nonatomic,strong) NSDictionary *taskParameter;
@property (nonatomic,copy) HyNetworkFormDataBlock taskFormDataBlock;
@property (nonatomic,assign) HyNetworRequestType taskRequestType;
@end


@implementation HyNetworkBaseTaskInfo
@synthesize taskStatus = _taskStatus;

+ (instancetype)taskInfoWithRequestType:(HyNetworRequestType)type
                                  cache:(BOOL)cache
                                    url:(NSString *)url
                              parameter:(nullable id)parameter
                          formDataBlock:(HyNetworkFormDataBlock)formDataBlock {
    
   HyNetworkBaseTaskInfo *info = [[self alloc] init];
   info.taskRequestType = type;
   info.taskCache = cache;
   info.taskUrl = [info handleURLWithUrl:url];
   info.taskParameter = parameter;
   info.taskFormDataBlock = [formDataBlock copy];
   return info;
}

- (NSString *)handleURLWithUrl:(NSString *)url {
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
    return currentUrl;
}

- (HyNetworRequestType)requestType {
    return self.taskRequestType;
}

- (BOOL)cache {
    return self.taskCache;
}

- (NSString *)url {
    return self.taskUrl;
}

- (NSDictionary *)parameter {
    return self.taskParameter;
}

- (HyNetworkFormDataBlock)formData {
    return self.taskFormDataBlock;
}

@end
