//
//  HyModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyModel : NSObject <HyViewControllerJumpProtocol, HyModelFactoryProtocol, HyModelProtocol>

@end

NS_ASSUME_NONNULL_END
