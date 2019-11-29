//
//  HyNetworkManager.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkProtocol.h"
#import "HyNetworkCacheProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyNetworkManager : NSObject

+ (id<HyNetworkProtocol>)network;

+ (id<HyNetworkCacheProtocol>)networkCache;

@end

NS_ASSUME_NONNULL_END
