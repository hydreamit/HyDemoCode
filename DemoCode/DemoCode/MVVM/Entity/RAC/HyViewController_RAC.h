//
//  HyViewController_RAC.h
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewControllerRACProtocol.h"
#import "HyBaseViewController.h"
#import "HyViewModel_RAC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyViewController_RAC<__covariant viewModelType: HyViewModel_RAC *> : HyBaseViewController<HyViewControllerRACProtocol>

@property (nonatomic,strong,readonly) viewModelType viewModel;

@end

NS_ASSUME_NONNULL_END
