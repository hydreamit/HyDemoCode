//
//  HySocketConnect.m
//  DemoCode
//
//  Created by Hy on 2017/1/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySocketConnect.h"
#import "HyNetworkManager.h"
#import <UIKit/UIKit.h>


@interface HySocketConnect ()
@property (nonatomic,copy) void(^cBlock)(void);
@property (nonatomic,copy) void(^dBlock)(void);
@end


@implementation HySocketConnect

- (instancetype)init {
    self = [super init];
    if (self) {
        
         __weak typeof(self) _self = self;
        [HyNetworkManager.network addNetworkStatusChangeBlock:^(HyNetworStatus currentStatus, HyNetworStatus lastStatus) {
             __strong typeof(_self) self = _self;
              
               if ((lastStatus == HyNetworStatusUnKnown || lastStatus == HyNetworStatusNotReachable) &&
                   (currentStatus == HyNetworStatusReachableViaWWAN || currentStatus == HyNetworStatusReachbleViaWiFi)) {
                   
                   [self connect];
                   
               } else if ((lastStatus == HyNetworStatusReachableViaWWAN || lastStatus == HyNetworStatusReachbleViaWiFi) && (currentStatus == HyNetworStatusUnKnown || currentStatus == HyNetworStatusNotReachable)) {
                   
                   [self disConnect];
               }
            
        } key:NSStringFromClass(self.class)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)connectBlock:(void (^)(void))cBlock disConnectBlock:(void (^)(void))dBlock {
    self.cBlock = [cBlock copy];
    self.dBlock = [dBlock copy];
}

- (void)applicationDidBecomeActive {
    if (HyNetworkManager.network.networkStatus == HyNetworStatusReachableViaWWAN ||
        HyNetworkManager.network.networkStatus == HyNetworStatusReachbleViaWiFi) {
        [self connect];
    }
}

- (void)applicationDidEnterBackground {
    [self disConnect];
}

- (void)connect {
    !self.cBlock ?: self.cBlock();
}

- (void)disConnect {
   !self.dBlock ?: self.dBlock();
}

- (void)dealloc {
    
    [HyNetworkManager.network removeNetworkStatusChangeBlockWithKey:NSStringFromClass(self.class)];
}

@end
