//
//  HyNetworkTypedef.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#ifndef HyNetworkTypedef_h
#define HyNetworkTypedef_h

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyNetworStatus) {
    HyNetworStatusReachableViaWWAN,
    HyNetworStatusReachbleViaWiFi,
    HyNetworStatusUnKnown,
    HyNetworStatusNotReachable
};

@protocol HyNetworkSuccessProtocol,
          HyMultipartFormDataProtocol,
          HyNetworkFailureProtocol,
          HyNetworkCompletionProtocol;

typedef void (^_Nullable HyNetworkStatusBlock)(HyNetworStatus currentStatus, HyNetworStatus lastStatus);
typedef void (^_Nullable HyNetworkFormDataBlock)(id<HyMultipartFormDataProtocol> formData);
typedef void (^_Nullable HyNetworkSuccessBlock)(id<HyNetworkSuccessProtocol> successObject);
typedef void (^_Nullable HyNetworkFailureBlock)(id<HyNetworkFailureProtocol> failureObject);
typedef void (^_Nullable HyNetworkMutipleTasksCompletionBlock)(NSArray<id<HyNetworkCompletionProtocol>> * _Nullable completionObject, BOOL allSuccess);

NS_ASSUME_NONNULL_END

#endif /* HyNetworkTypedef_h */
