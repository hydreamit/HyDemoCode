//
//  HyViewModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewModelProtocol.h"
#import "HyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyViewModel : NSObject <HyViewControllerJumpProtocol, HyViewModelFactoryProtocol, HyViewModelProtocol>

@end

NS_ASSUME_NONNULL_END
