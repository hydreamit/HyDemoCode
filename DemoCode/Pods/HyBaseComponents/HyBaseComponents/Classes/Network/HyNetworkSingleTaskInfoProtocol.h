//
//  HyNetworkSingleTaskInfoProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
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
