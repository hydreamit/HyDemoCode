//
//  HyModelBaseProtocol.h
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewControllerJumpProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyModelBaseProtocol <HyViewControllerJumpProtocol>
@optional
+ (instancetype)modelWithParameter:(nullable NSDictionary *)parameter;
@property (nonatomic,strong,readonly) NSDictionary *parameter;
- (void)modelLoad;
@end

NS_ASSUME_NONNULL_END
