//
//  HyViewController.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewControllerProtocol.h"
#import "HyViewControllerJumpProtocol.h"
#import <HyCategoriess/UIViewController+HyExtension.h>


NS_ASSUME_NONNULL_BEGIN

@interface HyViewController : UIViewController <HyViewControllerJumpProtocol, HyViewControllerFactoryProtocol, HyViewControllerProtocol>

@end

NS_ASSUME_NONNULL_END
