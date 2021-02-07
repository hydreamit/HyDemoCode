//
//  KafkaRefreshFactory.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "KafkaRefreshFactory.h"
#import "KafkaRefreshHeader.h"
#import "KafkaRefreshFooter.h"


@interface KafkaRefreshFactory ()
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,strong) id<HyRefreshViewProtocol> headerRefreshView;
@property (nonatomic,strong) id<HyRefreshViewProtocol> footerRefreshView;
@end


@implementation KafkaRefreshFactory

+ (instancetype)refreshViewFactoryWithScrollView:(UIScrollView *)scrollView
                             headerRefreshAction:(void(^)(void))headerRefreshAction
                             footerRefreshAction:(void(^)(void))footerRefreshAction {
    
    KafkaRefreshFactory *factory = [[self alloc] init];
    if (headerRefreshAction) {
        factory.headerRefreshView = [KafkaRefreshHeader refreshViewWithScrollView:scrollView refreshAction:headerRefreshAction];
    }
    if (headerRefreshAction) {
        factory.footerRefreshView = [KafkaRefreshFooter refreshViewWithScrollView:scrollView refreshAction:footerRefreshAction];
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
