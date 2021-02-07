//
//  AFNetwork.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "AFNetwork.h"
#import "AFNetworkSingleTask.h"
#import "HyNetworkCacheProtocol.h"
#import "HyTipText.h"
#import "HyHUD.h"


@interface AFNetwork ()
@property (nonatomic,strong) id<HyNetworkCacheProtocol> networkCache;
@property (nonatomic,strong) AFHTTPSessionManager *afnSessionManager;
@property (nonatomic,assign) HyNetworStatus currentNetworkStatus;
@property (nonatomic,strong) NSMutableDictionary<NSString *, HyNetworkStatusBlock> *networkStatusBlockDict;
@end


@implementation AFNetwork

- (id)sessionManager {
    return self.afnSessionManager;
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

- (AFHTTPSessionManager *)afnSessionManager {
    if (!_afnSessionManager){
        _afnSessionManager = [AFHTTPSessionManager manager];
        _afnSessionManager.requestSerializer.timeoutInterval = 30;
        _afnSessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _afnSessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _afnSessionManager.responseSerializer.acceptableContentTypes =
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
    return _afnSessionManager;
}

- (NSMutableDictionary<NSString *,HyNetworkStatusBlock> *)networkStatusBlockDict {
    if (!_networkStatusBlockDict){
        _networkStatusBlockDict = @{}.mutableCopy;
    }
    return _networkStatusBlockDict;
}

- (Class<HyNetworkSingleTaskProtocol>)signleTaskClass {
    return AFNetworkSingleTask.class;
}

@end
