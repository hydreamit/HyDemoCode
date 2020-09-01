//
//  KafkaRefreshFooter.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "KafkaRefreshFooter.h"
#import <KafkaRefresh/KafkaRefresh.h>

@interface KafkaRefreshFooter ()
@property (nonatomic,weak) UIScrollView *scrollView;
@end


@implementation KafkaRefreshFooter

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^)(void))refreshAction {
    
    KafkaRefreshFooter *header = [[KafkaRefreshFooter alloc] init];
    header.scrollView = scrollView;
    [scrollView bindFootRefreshHandler:refreshAction
                            themeColor:UIColor.blueColor
                          refreshStyle:KafkaRefreshStyleReplicatorArc];
    scrollView.footRefreshControl.hidden = YES;
    return header;
}

- (void)beginRefreshing {
    [self.scrollView.footRefreshControl beginRefreshing];
}

- (void)endRefreshing {
    [self.scrollView.footRefreshControl endRefreshing];
}

- (void)setHidden:(BOOL)hidden {
    self.scrollView.footRefreshControl.hidden = NO;
    if (!hidden) {
        [self.scrollView.footRefreshControl resumeRefreshAvailable];
    } else {
        [self.scrollView.footRefreshControl endRefreshingAndNoLongerRefreshingWithAlertText:nil];
//        [self.scrollView.footRefreshControl
//        endRefreshingAndNoLongerRefreshingWithAlertText:@"————————  这是我的底线  ————————"];
    }
}

@end
