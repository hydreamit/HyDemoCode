//
//  HyNetwork.h
//  DemoCode
//
//  Created by Hy on 2017/12/13.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyNetwork<__covariant HTTPSessionManagerType> : NSObject <HyNetworkProtocol>

- (HTTPSessionManagerType)sessionManager;

@end

NS_ASSUME_NONNULL_END
