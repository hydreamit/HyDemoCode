//
//  HyViewController.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewControllerProtocol.h"
#import "HyViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyViewController<__covariant viewModelType: HyViewModel *> : UIViewController<HyViewControllerProtocol>

@property (nonatomic,strong,readonly) viewModelType viewModel;

@end

NS_ASSUME_NONNULL_END
