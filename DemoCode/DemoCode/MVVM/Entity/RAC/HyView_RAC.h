//
//  HyView_RAC.h
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewRACProtocol.h"
#import "HyBaseView.h"
#import "HyViewModel_RAC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyView_RAC<__covariant viewModelType:  HyViewModel_RAC*,
                      __covariant viewDataProviderType: id<HyViewDataProtocol>,
                      __covariant viewEventHandlerType: id<HyViewEventProtocol>> : HyBaseView<HyViewRACProtocol>

@property (nonatomic,strong,readonly) viewModelType viewModel;
@property (nonatomic,weak,readonly) viewDataProviderType dataProvider;
@property (nonatomic,weak,readonly) viewEventHandlerType eventHandler;

@end

NS_ASSUME_NONNULL_END
