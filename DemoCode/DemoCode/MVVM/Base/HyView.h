//
//  HyView.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewProtocol.h"
#import "HyViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyView<__covariant viewModelType: id<HyViewModelFactoryProtocol, HyViewModelProtocol>> : UIView <HyViewControllerJumpProtocol, HyViewFactoryProtocol, HyViewProtocol>

@property (nonatomic,strong) viewModelType viewModel;

@end

NS_ASSUME_NONNULL_END
