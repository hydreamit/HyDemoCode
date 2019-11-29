//
//  MJRefreshViewFactory.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "MJRefreshViewFactory.h"
#import "MJRefreshViewHeader.h"
#import "MJRefreshViewFooter.h"


@interface MJRefreshViewFactory ()
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,strong) id<HyRefreshViewProtocol> headerRefreshView;
@property (nonatomic,strong) id<HyRefreshViewProtocol> footerRefreshView;
@end


@implementation MJRefreshViewFactory

+ (instancetype)refreshViewFactoryWithScrollView:(UIScrollView *)scrollView
                             headerRefreshAction:(void(^)(void))headerRefreshAction
                             footerRefreshAction:(void(^)(void))footerRefreshAction {
    
    MJRefreshViewFactory *factory = [[self alloc] init];
    if (headerRefreshAction) {
        factory.headerRefreshView = [MJRefreshViewHeader refreshViewWithScrollView:scrollView refreshAction:headerRefreshAction];
    }
    if (headerRefreshAction) {
        factory.footerRefreshView = [MJRefreshViewFooter refreshViewWithScrollView:scrollView refreshAction:footerRefreshAction];
    }
    return factory;
}

- (id<HyRefreshViewProtocol>)getHeaderRefreshView {
    return self.headerRefreshView;
}

- (id<HyRefreshViewProtocol>)getFooterRefreshView {
    return self.footerRefreshView;
}

@end
