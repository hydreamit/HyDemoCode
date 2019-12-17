//
//  HyNetworkBaseTaskInfoProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkTypedef.h"

typedef NS_ENUM(NSUInteger, HyNetworRequestType) {
    HyNetworRequestTypeGet,
    HyNetworRequestTypePost,
    HyNetworRequestTypePostFormData,
    HyNetworRequestTypeHead,
    HyNetworRequestTypePut,
    HyNetworRequestTypePatch,
    HyNetworRequestTypeDelete
};

typedef NS_ENUM(NSUInteger, HyNetworkTaskStatus) {
    HyNetworkTaskStatusNoResume,
    HyNetworkTaskStatusResuming,
    HyNetworkTaskStatusSuccess,
    HyNetworkTaskStatusFailure,
    HyNetworkTaskStatusResumedNoNetwork
};

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkBaseTaskInfoProtocol <NSObject>

+ (instancetype)taskInfoWithRequestType:(HyNetworRequestType)type
                                  cache:(BOOL)cache
                                    url:(NSString *)url
                              parameter:(nullable id)parameter
                          formDataBlock:(HyNetworkFormDataBlock)formDataBlock;

- (BOOL)cache;
- (NSString *)url;
- (NSDictionary *)parameter;
- (HyNetworRequestType)requestType;
- (HyNetworkFormDataBlock)formData;

@property (nonatomic,assign) HyNetworkTaskStatus taskStatus;

@end


NS_ASSUME_NONNULL_END
