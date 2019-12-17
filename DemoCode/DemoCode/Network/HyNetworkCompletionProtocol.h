//
//  HyNetworkCompletionProtocol.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkMutipleTasksProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkCompletionProtocol <NSObject>

@property (nonatomic,strong,nullable) id response;

@property (nonatomic,strong,nullable) id error;

@property (nonatomic,strong) id<HyNetworkMutipleTasksProtocol> task;

@end

NS_ASSUME_NONNULL_END
