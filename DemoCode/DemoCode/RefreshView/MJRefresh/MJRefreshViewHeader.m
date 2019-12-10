//
//  MJRefreshViewHeader.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "MJRefreshViewHeader.h"
#import <MJRefresh/MJRefresh.h>
#import "HyRefreshAnimationView.h"

@interface MJRefreshViewCustomHeader : MJRefreshHeader
@property (nonatomic,strong) HyRefreshAnimationView *animationView;
@end
@implementation MJRefreshViewCustomHeader
- (void)placeSubviews {
    [super placeSubviews];
    self.animationView.frame = CGRectMake((self.mj_w - 30)/ 2, (self.mj_h - 28) / 2, 30, 28);
}
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    if (state == MJRefreshStateIdle ||
        state == MJRefreshStatePulling) {
        [self.animationView stopAnimating];
    }  else if (state == MJRefreshStateRefreshing) {
        [self.animationView startAnimating];
    }
}
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    [self.animationView changeWithPercent:pullingPercent];
}
- (HyRefreshAnimationView *)animationView {
    if (!_animationView){
        _animationView = [[HyRefreshAnimationView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
        [self addSubview:_animationView];
    }
    return _animationView;
}
@end


@interface MJRefreshViewHeader ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation MJRefreshViewHeader

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    MJRefreshViewHeader *header = [[MJRefreshViewHeader alloc] init];
    header.scrollView = scrollView;
    scrollView.mj_header = [MJRefreshViewCustomHeader headerWithRefreshingBlock:refreshAction];
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
