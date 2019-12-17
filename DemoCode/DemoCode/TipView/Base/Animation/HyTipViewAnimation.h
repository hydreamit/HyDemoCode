//
//  HyTipViewAnimation.h
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyTipViewAnimationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyTipViewAnimation : NSObject <HyTipViewAnimationProtocol>

@property (nonatomic,copy,readonly) void(^completion)(void);
@property (nonatomic,strong,readonly) id parameter;

@end

NS_ASSUME_NONNULL_END
