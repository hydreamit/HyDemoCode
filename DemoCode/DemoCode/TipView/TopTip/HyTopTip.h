//
//  HyTopTip.h
//  DemoCode
//
//  Created by huangyi on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTip.h"


#define ShowTopTip(view) HyTopTip.show(view, nil, nil);
#define DismissTopTip HyTopTip.dismiss(view, nil);

NS_ASSUME_NONNULL_BEGIN

@interface HyTopTip : HyTip

@end

NS_ASSUME_NONNULL_END
