//
//  HyNetworkMutipleTasks.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkMutipleTasksProtocol.h"
#import "HyNetworkSingleTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyNetworkMutipleTasks : NSObject <HyNetworkMutipleTasksProtocol>

@property (nonatomic,strong) Class<HyNetworkSingleTaskProtocol> signleTaskClass;

@end

NS_ASSUME_NONNULL_END
