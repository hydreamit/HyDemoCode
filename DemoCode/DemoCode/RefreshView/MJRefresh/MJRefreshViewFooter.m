//
//  MJRefreshViewFooter.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "MJRefreshViewFooter.h"
#import <MJRefresh/MJRefresh.h>


@interface MJRefreshViewFooter ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation MJRefreshViewFooter

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    MJRefreshViewFooter *footer = [[MJRefreshViewFooter alloc] init];
    footer.scrollView = scrollView;
    scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshAction];
    scrollView.mj_footer.hidden = YES;
    return footer;
}

- (void)beginRefreshing {
    [self.scrollView.mj_footer beginRefreshing];
}

- (void)endRefreshing {
    [self.scrollView.mj_footer endRefreshing];
}

- (void)setHidden:(BOOL)hidden {
    self.scrollView.mj_footer.hidden = hidden;
}

@end
