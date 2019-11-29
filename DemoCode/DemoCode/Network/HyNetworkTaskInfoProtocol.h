//
//  HyNetworkTaskInfoProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkProtocol.h"

NS_ASSUME_NONNULL_BEGIN

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
    HyNetworkTaskStatusWillResume,
    HyNetworkTaskStatusResuming,
    HyNetworkTaskStatusSuccess,
    HyNetworkTaskStatusFailure
};


@protocol HyNetworkTaskProtocol;
@protocol HyNetworkTaskInfoProtocol <NSObject>

+ (instancetype)taskInfoWithRequestType:(HyNetworRequestType)type
                                showHUD:(BOOL)showHUD
                                  cache:(BOOL)cache
                                    url:(NSString *)url
                              parameter:(nullable id)parameter
                          formDataBlock:(HyNetworkFormDataBlock)formDataBlock
                           successBlock:(HyNetworkSuccessBlock)successBlock
                           failureBlock:(HyNetworkFailureBlock)failureBlock;

- (HyNetworRequestType)requestType;

- (BOOL)cache;
- (BOOL)showHUD;

- (NSString *)url;
- (NSDictionary *)parameter;
- (HyNetworkFormDataBlock)formData;

- (HyNetworkSuccessBlock)successBlock;
- (HyNetworkFailureBlock)failureBlock;

@property (nonatomic,assign) HyNetworkTaskStatus taskStatus;

@end

NS_ASSUME_NONNULL_END
