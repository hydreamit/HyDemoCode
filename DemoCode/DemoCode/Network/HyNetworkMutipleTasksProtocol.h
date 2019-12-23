//
//  HyNetworkMutipleTasksProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
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

@property (nonatomic,strong,nullable) NSArray<id<HyNetworkCompletionProtocol>> *completionObject;

@property (nonatomic,assign) BOOL allSuccess;


@end

NS_ASSUME_NONNULL_END
