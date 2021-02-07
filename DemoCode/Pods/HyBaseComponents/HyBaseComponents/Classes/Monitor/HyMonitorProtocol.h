//
//  HyMonitorProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyMonitorProtocol <NSObject>

- (void)startMonitorWithHandler:(void (^_Nullable)(id _Nullable result))handler;

- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
