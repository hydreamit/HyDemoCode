//
//  HySocketClientProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HySocketProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketClientProtocol <HySocketProtocol>

@property (nonatomic,copy) NSString *ID;

- (void)connectWithCompletion:(void(^_Nullable)(BOOL success))completion;

- (void)recvMessageWithHandler:(void(^_Nullable)(id<HySocketMessageProtocol> message))handler;

- (void)disConnect;

@end

NS_ASSUME_NONNULL_END
