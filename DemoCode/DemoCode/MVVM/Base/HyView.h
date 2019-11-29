//
//  HyView.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyView : UIView <HyViewControllerJumpProtocol, HyViewFactoryProtocol, HyViewProtocol>

@end

NS_ASSUME_NONNULL_END
