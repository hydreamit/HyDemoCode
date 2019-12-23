//
//  HyNetworkSingleTaskProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkBaseTaskProtocol.h"
#import "HyNetworkSingleTaskInfoProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkProtocol;
@protocol HyNetworkSingleTaskProtocol <HyNetworkBaseTaskProtocol>

+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkSingleTaskInfoProtocol>)taskInfo;

- (id<HyNetworkSingleTaskInfoProtocol>)taskInfo;

@property (nonatomic,strong,nullable) id<HyNetworkSuccessProtocol> successObject;

@property (nonatomic,strong,nullable) id<HyNetworkFailureProtocol> failureObject;

@end

NS_ASSUME_NONNULL_END
