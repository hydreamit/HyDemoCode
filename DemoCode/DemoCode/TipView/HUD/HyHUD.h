//
//  HyHUD.h
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTip.h"

#define ShowHUD(view) HyHUD.show(view, nil, nil);
#define DismissHUD(view) HyHUD.dismiss(view, nil);

NS_ASSUME_NONNULL_BEGIN

@interface HyHUD : HyTip


@end

NS_ASSUME_NONNULL_END
