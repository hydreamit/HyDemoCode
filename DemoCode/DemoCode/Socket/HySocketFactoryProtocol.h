//
//  HySocketFactoryProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HySocketClientProtocol.h"
#import "HySocketServerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketFactoryProtocol <NSObject>

+ (instancetype (^)(NSString *ip, NSString *port))socketFactory;

- (id<HySocketClientProtocol>(^)(NSString *ID))client;

@optional
- (id<HySocketServerProtocol>)server;


@end

NS_ASSUME_NONNULL_END
