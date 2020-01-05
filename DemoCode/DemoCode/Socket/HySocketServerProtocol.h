//
//  HySocketServerProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HySocketProtocol.h"
#import "HySocketClientProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketServerProtocol <HySocketProtocol>

- (void)bindAndListenWithCompletion:(void(^_Nullable)(BOOL success))completion;

- (void)acceptWithHandler:(void(^_Nullable)(id socket))hander;

- (void)recvClientMessageWithHandler:(void(^_Nullable)(id<HySocketMessageProtocol> message, id socket))handler;

@end


@protocol HyServerClientSocketProtocol <NSObject>

@property (nonatomic,strong) id clientSocket;

@property(nonatomic, strong) NSDate *updateTime;

@property (nonatomic,copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
