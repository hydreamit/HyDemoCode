//
//  HyViewModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewModelProtocol.h"
#import "HyViewControllerJumpProtocol.h"
#import "HyViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyViewModel : NSObject <HyViewControllerJumpProtocol, HyViewModelProtocol, HyViewInvokerProtocol>

@end

NS_ASSUME_NONNULL_END
