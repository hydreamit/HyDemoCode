//
//  HyTipViewPositionProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/4.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyTipViewProtocol.h"


NS_ASSUME_NONNULL_BEGIN


@protocol HyTipViewPositionProtocol <NSObject>

@optional
+ (id<HyTipViewPositionProtocol> (^)(id _Nullable parameter))position;
+ (id<HyTipViewPositionProtocol>)positionWithBlock:(void(^)(UIView<HyTipViewProtocol> *tipView))block;

@required
- (void(^)(UIView<HyTipViewProtocol> *))positionAction;

@end

NS_ASSUME_NONNULL_END
