//
//  HySocketReConnectProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketReConnectProtocol <NSObject>

- (void)reConnect;

- (void)resetReConnectCount;

- (void)reConnectBlock:(void(^_Nullable)(void))rBlock
         countOutBlock:(void(^_Nullable)(void))cBlock;

@end

NS_ASSUME_NONNULL_END
