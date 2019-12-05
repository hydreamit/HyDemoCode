//
//  HyTopTip.h
//  DemoCode
//
//  Created by huangyi on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyTipProtocol.h"

#define ShowTopTip(view) [HyTopTip showToView:view parameter:nil completion:nil];
#define DismissTopTip [HyTopTip dismissWithCompletion:nil];

NS_ASSUME_NONNULL_BEGIN

@interface HyTopTip : NSObject <HyTipProtocol>

@end

NS_ASSUME_NONNULL_END
