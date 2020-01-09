//
//  HySocketConnectProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/1/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketConnectProtocol <NSObject>

- (void)connectBlock:(void(^)(void))cBlock disConnectBlock:(void(^)(void))dBlock;

@end

NS_ASSUME_NONNULL_END
