//
//  HySocketReConnect.m
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySocketReConnect.h"


@interface HySocketReConnect ()
@property (nonatomic,assign) NSInteger reConnectCount;
@property (nonatomic,copy) void(^rBlock)(void);
@property (nonatomic,copy) void(^cBlock)(void);
@end


@implementation HySocketReConnect
- (void)reConnect {
    
    // 超过一分钟就不再重连 只会重连5次 2^5 = 64
    if (self.reConnectCount > 64) {
        !self.cBlock ?: self.cBlock();
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectCount * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   self.rBlock);
      
      // 重连时间2的指数级增长
      if (self.reConnectCount == 0) {
          self.reConnectCount = 2;
      } else {
          self.reConnectCount *= 2;
      }
}

- (void)resetReConnectCount {
    self.reConnectCount = 0;
}

- (void)reConnectBlock:(void(^_Nullable)(void))rBlock
         countOutBlock:(void(^_Nullable)(void))cBlock {
    self.rBlock = [rBlock copy];
    self.cBlock = [cBlock copy];
}

@end
