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
@property (nonatomic,assign) BOOL hasCountOut;
@end


@implementation HySocketReConnect
- (void)reConnect {
    
    // 只会重连6次
    if (self.reConnectCount > 1) {
        if (self.hasCountOut) {return;}
         NSLog(@"超过重连次数");
        !self.cBlock ?: self.cBlock();
        self.hasCountOut = YES;
        return;
    }
    
    // 重连时间隔 2^5 = 64
    NSTimeInterval time = self.reConnectCount ? pow(2, self.reConnectCount) : 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   self.rBlock);
      
    self.reConnectCount ++;
    
    NSLog(@"第%ld次重连", (long)self.reConnectCount);
}

- (void)resetReConnectCount {
    self.hasCountOut = NO;
    self.reConnectCount = 0;
}

- (void)reConnectBlock:(void(^_Nullable)(void))rBlock
         countOutBlock:(void(^_Nullable)(void))cBlock {
    self.rBlock = [rBlock copy];
    self.cBlock = [cBlock copy];
}

@end
