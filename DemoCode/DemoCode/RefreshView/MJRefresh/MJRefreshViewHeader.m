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
@property (nonatomic, assign) BOOL isAutoRefreshing;
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
        
        NSTimeInterval delayInSeconds = self.isAutoRefreshing ? .3 : 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.animationView startAnimating];
        });
        self.isAutoRefreshing = NO;
    }
}
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
    
    if (self.isAutoRefreshing) {
        [self.animationView changeWithPercent:1.0];
    } else {
        [self.animationView changeWithPercent:pullingPercent];
    }
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
    ((MJRefreshViewCustomHeader *)self.scrollView.mj_header).isAutoRefreshing = YES;
    [self.scrollView.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self.scrollView.mj_header endRefreshing];
}

- (void)setHidden:(BOOL)hidden {
    self.scrollView.mj_header.hidden = hidden;
}

@end
