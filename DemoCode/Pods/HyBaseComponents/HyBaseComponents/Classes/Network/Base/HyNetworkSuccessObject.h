//
//  HyNetworkSuccessObject.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkSuccessProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#define NetworkSuccessObject(response, task) HyNetworkSuccessObject.successObject(response, task)

@interface HyNetworkSuccessObject : NSObject <HyNetworkSuccessProtocol>

+ (id<HyNetworkSuccessProtocol>(^)(id _Nullable, id<HyNetworkSingleTaskProtocol>))successObject;

@end

NS_ASSUME_NONNULL_END
