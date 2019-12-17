//
//  HyNetworkMutipleTasksProtocol.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkBaseTaskProtocol.h"
#import "HyNetworkMutipleTasksInfoProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkProtocol;
@protocol HyNetworkMutipleTasksProtocol <HyNetworkBaseTaskProtocol>

+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkMutipleTasksInfoProtocol>)taskInfo;

- (id<HyNetworkMutipleTasksInfoProtocol>)taskInfo;

@end

NS_ASSUME_NONNULL_END
