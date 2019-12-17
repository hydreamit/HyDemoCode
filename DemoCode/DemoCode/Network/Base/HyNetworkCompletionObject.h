//
//  HyNetworkCompletionObject.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkCompletionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define NetworkCompletionObject(response, error, task) HyNetworkCompletionObject.completionObject(response, error, task)

@interface HyNetworkCompletionObject : NSObject <HyNetworkCompletionProtocol>

+ (id<HyNetworkCompletionProtocol>(^)(id _Nullable, id _Nullable, id<HyNetworkMutipleTasksProtocol>))completionObject;

@end

NS_ASSUME_NONNULL_END
