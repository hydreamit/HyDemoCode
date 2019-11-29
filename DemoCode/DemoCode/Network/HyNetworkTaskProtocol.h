//
//  HyNetworkTaskProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkTaskInfoProtocol, HyNetworkProtocol;
@protocol HyNetworkTaskProtocol <NSObject>

+ (instancetype)taskWithNetwork:(id<HyNetworkProtocol>)netWork
                       taskInfo:(id<HyNetworkTaskInfoProtocol>)taskInfo;

- (id<HyNetworkTaskInfoProtocol>)taskInfo;

- (void)resume;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
