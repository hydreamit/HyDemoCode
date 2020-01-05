//
//  HySocketProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HySocketMessage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketProtocol <NSObject>

+ (instancetype (^)(NSString *ip, NSString *port))socket;

- (void)sendMessage:(id<HySocketMessageProtocol>)message;

@end

NS_ASSUME_NONNULL_END
