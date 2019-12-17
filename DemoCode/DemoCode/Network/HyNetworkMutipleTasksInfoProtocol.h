//
//  HyNetworkMutipleTasksInfoProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkBaseTaskInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkMutipleTasksInfoProtocol <NSObject>

+ (instancetype)taskInfoWithShowHUD:(BOOL)showHUD
                              tasks:(NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)tasks
                    completionBlock:(HyNetworkMutipleTasksCompletionBlock)completionBlock;

- (BOOL)showHUD;

- (NSArray<id<HyNetworkBaseTaskInfoProtocol>> *)tasks;

- (HyNetworkMutipleTasksCompletionBlock)completionBlock;

@property (nonatomic,assign) HyNetworkTaskStatus taskStatus;

@end

NS_ASSUME_NONNULL_END
