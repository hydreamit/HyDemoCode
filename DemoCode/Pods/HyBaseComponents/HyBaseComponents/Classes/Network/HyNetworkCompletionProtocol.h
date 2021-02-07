//
//  HyNetworkCompletionProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
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
