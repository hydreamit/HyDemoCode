//
//  HyNetworkSingleTaskInfoProtocol.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkBaseTaskInfoProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkSingleTaskInfoProtocol <HyNetworkBaseTaskInfoProtocol>

- (void)setShowHUD:(BOOL)showHUD
      successBlock:(HyNetworkSuccessBlock)successBlock
      failureBlock:(HyNetworkFailureBlock)failureBlock;

- (BOOL)showHUD;

- (HyNetworkSuccessBlock)successBlock;

- (HyNetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
