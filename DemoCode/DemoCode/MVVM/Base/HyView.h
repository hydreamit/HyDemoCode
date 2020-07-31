//
//  HyView.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewProtocol.h"
#import "HyViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyView<__covariant viewModelType: HyViewModel *,
                  __covariant viewDataProviderType: id<HyViewDataProtocol>,
                  __covariant viewEventHandlerType: id<HyViewEventProtocol>> : UIView <HyViewControllerJumpProtocol, HyViewProtocol>

@property (nonatomic,strong) viewModelType viewModel;
@property (nonatomic,weak,readonly) viewDataProviderType dataProvider;
@property (nonatomic,weak,readonly) viewEventHandlerType eventHandler;

@end

NS_ASSUME_NONNULL_END
