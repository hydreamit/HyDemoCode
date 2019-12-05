//
//  HyHUD.h
//  DemoCode
//
//  Created by huangyi on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyTipProtocol.h"

#define ShowHUD(view) [HyHUD showToView:view parameter:nil completion:nil];
#define DismissHUD [HyHUD dismissWithCompletion:nil];

NS_ASSUME_NONNULL_BEGIN

@interface HyHUD : NSObject <HyTipProtocol>


@end

NS_ASSUME_NONNULL_END
