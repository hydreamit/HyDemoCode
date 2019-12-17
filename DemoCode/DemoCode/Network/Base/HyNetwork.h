//
//  HyNetwork.h
//  DemoCode
//
//  Created by huangyi on 2019/12/13.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyNetwork<__covariant HTTPSessionManagerType> : NSObject <HyNetworkProtocol>

- (HTTPSessionManagerType)sessionManager;

@end

NS_ASSUME_NONNULL_END
