//
//  HyMonitorManager.h
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyMonitorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyMonitorManager : NSObject

+ (id<HyMonitorProtocol>)fpsMonitor;

+ (id<HyMonitorProtocol>)performanceMonitor;

@end

NS_ASSUME_NONNULL_END
