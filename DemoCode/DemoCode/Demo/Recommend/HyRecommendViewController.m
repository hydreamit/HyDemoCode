//
//  HyRecommendViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRecommendViewController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyRecommendViewModel.h"
#import "HyRecommendCell.h"
#import "HyCollectionView.h"
#import "RACCommand+Network.h"
#import "RACSignal+Network.h"
#import "HyNetworkManager.h"


@interface HyRecommendViewController ()
@property (nonatomic,strong) HyCollectionView *collectionView;
@property (nonatomic,strong) HyRecommendViewModel *viewModel;
@end


@implementation HyRecommendViewController
@dynamic viewModel;
- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewModelDidLoad {
    
    [self.collectionView headerBeginRefreshing];
//    [self.viewModel requestListDataWithInput:nil type:0];
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
                                                     delegateConfigure:^(HyCollectionViewDelegateConfigure * _Nonnull configure) {
            [configure configEmtyView:^(UICollectionView *collectionView, UIView *emtyContainerView) {
                UILabel *label = UILabel.new;
                label.text = @"暂无数据";
                label.frame = emtyContainerView.bounds;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = UIColor.darkTextColor;
                [emtyContainerView addSubview:label];
            }];
        }];
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
    NSLog(@"=========%s", __func__);
}
@end
