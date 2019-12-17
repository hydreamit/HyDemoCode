//
//  HyNetworkFailureObject.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkFailureProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define NetworkFailureObject(error, task) HyNetworkFailureObject.failureObject(error, task)

@interface HyNetworkFailureObject : NSObject <HyNetworkFailureProtocol>

+ (id<HyNetworkFailureProtocol>(^)(id _Nullable, id<HyNetworkSingleTaskProtocol>))failureObject;

@end

NS_ASSUME_NONNULL_END
