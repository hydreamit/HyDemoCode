//
//  HyRefreshViewFactoryProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyRefreshViewProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyRefreshViewFactoryProtocol <NSObject>

+ (instancetype)refreshViewFactoryWithScrollView:(UIScrollView *)scrollView
                             headerRefreshAction:(void(^_Nullable)(void))headerRefreshAction
                             footerRefreshAction:(void(^_Nullable)(void))footerRefreshAction;

- (id<HyRefreshViewProtocol>)getHeaderRefreshView;

- (id<HyRefreshViewProtocol>)getFooterRefreshView;

@end

NS_ASSUME_NONNULL_END
