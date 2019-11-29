//
//  MJRefreshViewHeader.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "MJRefreshViewHeader.h"
#import <MJRefresh/MJRefresh.h>


@interface MJRefreshViewHeader ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation MJRefreshViewHeader

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    MJRefreshViewHeader *header = [[MJRefreshViewHeader alloc] init];
    header.scrollView = scrollView;
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshAction];
    return header;
}

- (void)beginRefreshing {
    [self.scrollView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self.scrollView.mj_header endRefreshing];
}

- (void)setHidden:(BOOL)hidden {
    self.scrollView.mj_header.hidden = hidden;
}

@end
