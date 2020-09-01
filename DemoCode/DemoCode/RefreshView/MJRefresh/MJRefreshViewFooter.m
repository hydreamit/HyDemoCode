//
//  MJRefreshViewFooter.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "MJRefreshViewFooter.h"
#import <MJRefresh/MJRefresh.h>
#import "HyRefreshAnimationView.h"


@interface MJRefreshViewCustomFooter : MJRefreshAutoFooter
@property (nonatomic,strong) HyRefreshAnimationView *animationView;
@end

@implementation MJRefreshViewCustomFooter

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.animationView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.animationView startAnimating];
    }
}

- (void)placeSubviews {
    [super placeSubviews];
    self.animationView.frame = CGRectMake((self.mj_w - 30)/ 2, (self.mj_h - 28) / 2, 30, 28);
}

- (HyRefreshAnimationView *)animationView {
    if (!_animationView){
        _animationView = [[HyRefreshAnimationView alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
        [_animationView changeWithPercent:1.0];
        [self addSubview:_animationView];
    }
    return _animationView;
}

@end


@interface MJRefreshViewFooter ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation MJRefreshViewFooter

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    MJRefreshViewFooter *footer = [[MJRefreshViewFooter alloc] init];
    footer.scrollView = scrollView;
    scrollView.mj_footer = [MJRefreshViewCustomFooter footerWithRefreshingBlock:refreshAction];
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
