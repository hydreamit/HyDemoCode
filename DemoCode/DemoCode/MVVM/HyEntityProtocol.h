//
//  HyEntityProtocol.h
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyEntityProtocol <NSObject>

@property (nonatomic,strong,readonly) NSDictionary *parameter;
+ (instancetype)entityWithParameter:(nullable NSDictionary *)parameter;
- (void)entityLoad;

@end

NS_ASSUME_NONNULL_END
