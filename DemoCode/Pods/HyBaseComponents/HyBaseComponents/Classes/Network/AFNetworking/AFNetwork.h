//
//  AFNetwork.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "HyNetworkProtocol.h"
#import "HyNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFNetwork : HyNetwork<AFHTTPSessionManager *>

@end

NS_ASSUME_NONNULL_END
