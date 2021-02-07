//
//  HyRefreshViewManager.h
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyRefreshViewFactoryProtocol.h"


NS_ASSUME_NONNULL_BEGIN

#define KEY_MJRefresh @"MJRefresh"
#define KEY_KafkaRefresh @"KafkaRefresh"

@interface HyRefreshViewManager : NSObject

+ (nullable id<HyRefreshViewFactoryProtocol>)refreshViewFactoryWithFramework:(NSString *)framework
                                                                  scrollView:(UIScrollView *)scrollView
                                                         headerRefreshAction:(void(^_Nullable)(void))headerRefreshAction
                                                         footerRefreshAction:(void(^_Nullable)(void))footerRefreshAction;
@end

NS_ASSUME_NONNULL_END
