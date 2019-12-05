//
//  HyNewsViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsViewController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyNewsViewModel.h"
#import "HyNewsImageCell.h"
#import "HyNetworkManager.h"
#import "HyTableView.h"
#import "HyNewsCell.h"


@interface HyNewsViewController ()
@property (nonatomic,strong) HyNewsViewModel *viewModel;
@property (nonatomic,strong) HyTableView *tableView;
@end


@implementation HyNewsViewController
@dynamic viewModel;
- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [HyNetworkManager.network addNetworkStatusChangeBlock:^(HyNetworStatus currentStatus, HyNetworStatus lastStatus) {
        @strongify(self);
        if ((lastStatus == HyNetworStatusUnKnown || lastStatus == HyNetworStatusNotReachable) &&
            (currentStatus == HyNetworStatusReachableViaWWAN || currentStatus == HyNetworStatusReachbleViaWiFi)) {
            [self.tableView headerBeginRefreshing];
        }
    } key:NSStringFromClass(self.class)];
}

- (void)viewModelDidLoad {
    [self.viewModel requestListDataWithInput:nil type:0];
}

- (void)scrollToTop {
    
    [self.tableView hy_scrollToTopAnimated:YES];
}

- (HyTableView *)tableView {
    if (!_tableView){
        @weakify(self);
        _tableView = [HyTableView hy_tableViewWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain
                                          tableViewData:self.viewModel
                                            cellClasses:@[HyNewsCell.class, HyNewsImageCell.class]
                                headerFooterViewClasses:nil
                                      delegateConfigure:^(HyTableViewDelegateConfigure *configure) {
            [[[configure configCellClassForRow:^Class(id cellData, NSIndexPath *indexPath) {
                return ((HyNewsModel *)cellData).cellClass;
            }] configHeightForRowAtIndexPath:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
                @strongify(self);
                return ((HyNewsModel *)self.viewModel.cellModel(indexPath)).cellHeight;
            }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
                @strongify(self);
                [self.class pushViewControllerWithName:@"HyRecommendViewController"
                                         viewModelName:@"HyRecommendViewModel"
                                             parameter:nil
                                              animated:YES
                                            completion:nil];
            }];
        }];
        [_tableView configRefreshFramework:nil
                               refreshType:HyListViewRefreshTypePullDownAndUp
                       refreshRequestInput:nil
                       refreshCustomAction:nil];
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _tableView;
}

- (void)dealloc {
    
    [HyNetworkManager.network removeNetworkStatusChangeBlockWithKey:NSStringFromClass(self.class)];
    
    NSLog(@"%s", __func__);
}
@end






