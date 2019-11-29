//
//  HyRefreshViewManager.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRefreshViewManager.h"
#import "MJRefreshViewFactory.h"
#import "KafkaRefreshFactory.h"


@implementation HyRefreshViewManager

+ (id<HyRefreshViewFactoryProtocol>)refreshViewFactoryWithFramework:(NSString *)framework
                                                         scrollView:(UIScrollView *)scrollView
                                                headerRefreshAction:(void(^)(void))headerRefreshAction
                                                footerRefreshAction:(void(^)(void))footerRefreshAction {
    
    if ([framework isEqualToString:KEY_MJRefresh]) {

        return [MJRefreshViewFactory refreshViewFactoryWithScrollView:scrollView
                                                  headerRefreshAction:headerRefreshAction
                                                  footerRefreshAction:footerRefreshAction];
    } else
    if ([framework isEqualToString:KEY_KafkaRefresh]) {
        
        return [KafkaRefreshFactory refreshViewFactoryWithScrollView:scrollView
                                                 headerRefreshAction:headerRefreshAction
                                                 footerRefreshAction:footerRefreshAction];
    }
    
    return nil;
}


@end
