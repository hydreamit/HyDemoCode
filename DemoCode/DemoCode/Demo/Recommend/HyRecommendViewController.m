//
//  HyRecommendViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRecommendViewController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyRecommendCell.h"
#import "HyCollectionView.h"
#import "HyNetworkManager.h"


@interface HyRecommendViewController ()
@property (nonatomic,strong) HyCollectionView *collectionView;
@end


@implementation HyRecommendViewController
- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    [self.view addSubview:self.collectionView];

    @weakify(self);
    [HyNetworkManager.network addNetworkStatusChangeBlock:^(HyNetworStatus currentStatus, HyNetworStatus lastStatus) {
        @strongify(self);
        if ((lastStatus == HyNetworStatusUnKnown || lastStatus == HyNetworStatusNotReachable) &&
            (currentStatus == HyNetworStatusReachableViaWWAN || currentStatus == HyNetworStatusReachbleViaWiFi)) {
            [self.collectionView headerBeginRefreshing];
        }
    } key:NSStringFromClass(self.class)];
}

- (void)viewModelDidLoad {
    [self.viewModel requestListDataWithInput:nil type:0];
}

- (void)scrollToTop {
    [self.collectionView hy_scrollToTopAnimated:YES];
}

- (HyCollectionView *)collectionView {
    if (!_collectionView){
        _collectionView = [HyCollectionView hy_collectionViewWithFrame:self.view.bounds
                                                                layout:self.layout
                                                    collectionViewData:self.viewModel
                                                           cellClasses:@[HyRecommendCell.class]
                                                     headerViewClasses:nil
                                                     footerViewClasses:nil
                                                     delegateConfigure:nil];
        [_collectionView configRefreshFramework:KEY_KafkaRefresh
                                    refreshType:HyListViewRefreshTypePullDown
                            refreshRequestInput:nil
                            refreshCustomAction:nil];
        if (@available(iOS 11.0, *)){
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

#define kRecommendPagerHeight 113
#define kRecommendItemWidth (Hy_ScreenW > 320 ? 98 : 86)
#define kRecommendItemHeight 102
#define kRecommendItemHorEdge (Hy_ScreenW > 320 ? 16 : 10)
#define kRecommendItemVerEdge 20
- (UICollectionViewFlowLayout *)layout {
    UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
    layout.sectionInset =  UIEdgeInsetsMake(kRecommendItemVerEdge,
                            kRecommendItemHorEdge,
                            kRecommendItemVerEdge,
                            kRecommendItemHorEdge);
    layout.itemSize = CGSizeMake(kRecommendItemWidth, kRecommendItemHeight);
    layout.minimumInteritemSpacing = floor((Hy_ScreenW - 3*kRecommendItemWidth - 2*kRecommendItemHorEdge)/2);
    layout.minimumLineSpacing = 35;
    return layout;
}

- (void)dealloc {
    
    [HyNetworkManager.network removeNetworkStatusChangeBlockWithKey:NSStringFromClass(self.class)];
    
    NSLog(@"%s", __func__);
}
@end
