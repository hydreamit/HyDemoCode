//
//  HyMonitorManager.m
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyMonitorManager.h"
#import "HyFPSMonitor.h"
#import "HyPerformanceMonitor.h"


@interface HyMonitorManager ()
@property (nonatomic,strong) id<HyMonitorProtocol> fpsM;
@property (nonatomic,strong) id<HyMonitorProtocol> performanceM;
@end


@implementation HyMonitorManager

+ (instancetype)manager {
    
    static HyMonitorManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        _instance.fpsM = [[HyFPSMonitor alloc] init];
        _instance.performanceM = [[HyPerformanceMonitor alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (id<HyMonitorProtocol>)fpsMonitor {
    return [[self manager] fpsM];
}

+ (id<HyMonitorProtocol>)performanceMonitor {
    return [[self manager] performanceM];
}

@end
