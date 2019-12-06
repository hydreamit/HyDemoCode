//
//  HyTip.h
//  DemoCode
//
//  Created by huangyi on 2017/12/5.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyTipProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyTip : NSObject <HyTipProtocol>

+ (NSArray<Class> *)tipViewOfContentViewClass;

+ (UIView *(^)(UIView *_Nullable view))forView;

@end

NS_ASSUME_NONNULL_END
