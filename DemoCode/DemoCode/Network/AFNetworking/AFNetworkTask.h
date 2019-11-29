//
//  AFNetworkTask.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkTaskProtocol.h"
#import "AFNetworkTaskInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkTask : NSObject <HyNetworkTaskProtocol>

@property (nonatomic,strong) NSURLSessionDataTask *sessionTask;

@end

NS_ASSUME_NONNULL_END
