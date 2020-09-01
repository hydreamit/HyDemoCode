//
//  KafkaRefreshHeader.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "KafkaRefreshHeader.h"
#import <KafkaRefresh/KafkaRefresh.h>

@interface KafkaRefreshHeader ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation KafkaRefreshHeader

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    KafkaRefreshHeader *header = [[KafkaRefreshHeader alloc] init];
    header.scrollView = scrollView;
    [scrollView bindHeadRefreshHandler:refreshAction
                            themeColor:UIColor.blueColor
                          refreshStyle:KafkaRefreshStyleReplicatorArc];
    return header;
}

- (void)beginRefreshing {
    [self.scrollView.headRefreshControl beginRefreshing];
}

- (void)endRefreshing {
    [self.scrollView.headRefreshControl endRefreshingWithAlertText:@"刷新成功" completion:nil];
}

- (void)setHidden:(BOOL)hidden {
    self.scrollView.headRefreshControl.hidden = NO;
}

@end
