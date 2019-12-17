//
//  HyNetworkSignleTaskInfo.m
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkSignleTaskInfo.h"

@interface HyNetworkSignleTaskInfo ()
@property (nonatomic,assign) BOOL taskShowHUD;
@property (nonatomic,copy) HyNetworkSuccessBlock taskSuccessBlock;
@property (nonatomic,copy) HyNetworkFailureBlock taskFailureBlock;
@end


@implementation HyNetworkSignleTaskInfo

- (void)setShowHUD:(BOOL)showHUD
      successBlock:(HyNetworkSuccessBlock)successBlock
      failureBlock:(HyNetworkFailureBlock)failureBlock {
    
    self.taskShowHUD = showHUD;
    self.taskSuccessBlock = [successBlock copy];
    self.taskFailureBlock = [failureBlock copy];
}

- (BOOL)showHUD {
    return self.taskShowHUD;
}

- (HyNetworkSuccessBlock)successBlock {
    return self.taskSuccessBlock;
}

- (HyNetworkFailureBlock)failureBlock {
    return self.taskFailureBlock;
}

@end
