//
//  HYRecommendController.m
//  HYBaseProject
//
//  Created by huangyi on 2017/11/27.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYRecommendController.h"
#import "HYBaseBlockCollectionView.h"
#import "HYRecommendViewModel.h"
#import "HYRecommendCell.h"


@interface HYRecommendController ()
@property (nonatomic,strong) HYRecommendViewModel *viewModel;
@property (nonatomic,strong) HYBaseBlockCollectionView *collectionView;
@end


@implementation HYRecommendController
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)repeatClickTabbarItemAction {
    [self.collectionView scrollToTop];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title = @"新闻";
    self.view.backgroundColor = UIColorWhite;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = UIColorWhite;
}

- (HYBaseBlockCollectionView *)collectionView {
    return Hy_Lazy(_collectionView, ({
        
        CGFloat bottomMargin = self.navigationController.viewControllers.count > 1 ? 0 : (kTabBarHeight + kSafeAreaBottom);
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - kNavigationBarHeight - kSafeAreaTop - bottomMargin);
        [HYBaseBlockCollectionView colletionViewWithFrame:rect
                                                   layout:[[UICollectionViewFlowLayout alloc] init]
                                              refreshType:HYRefreshTypePullDown
                                            refreshAction:nil
                                                viewModel:self.viewModel
                                                configure:[self collectionViewConfigure]];
    }));
}

#define kRecommendPagerHeight 113
#define kRecommendItemWidth (ScreenW > 320 ? 98 : 86)
#define kRecommendItemHeight 102
#define kRecommendItemHorEdge (ScreenW > 320 ? 16 : 10)
#define kRecommendItemVerEdge 20
- (HYBaseBlockCollectionViewConfigure *)collectionViewConfigure {
    HYBaseBlockCollectionViewConfigure *configure = [HYBaseBlockCollectionViewConfigure new];
    [[[[[[[configure configRegisterCellClasses:@[HYRecommendCell.class]]
          configCellClassForRow:^Class(HYBaseCollectionCellModel *cellModel, NSIndexPath *indexPath) {
        return HYRecommendCell.class;
    }] configLayoutSize:^CGSize(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath) {
        return CGSizeMake(kRecommendItemWidth, kRecommendItemHeight);
    }] configLayoutMinimumLineSpacing:^CGFloat(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section) {
        return 35;
    }] configLayoutInsets:^UIEdgeInsets(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section) {
        return
        UIEdgeInsetsMake(kRecommendItemVerEdge,
                         kRecommendItemHorEdge,
                         kRecommendItemVerEdge,
                         kRecommendItemHorEdge);
    }] configLayoutMinimumInteritemSpacing:^CGFloat(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section) {
        return floor((CGRectGetWidth(collectionView.frame) -
                      3*kRecommendItemWidth - 2*kRecommendItemHorEdge)/2);
    }] configDidSelectItemAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
        [HYJumpConrollerTool pushViewControllerWithControllerName:@"testNoController"
                                                    viewModelName:nil
                                                           params:nil
                                                         animated:YES];
    }];
    return configure;
}


@end
