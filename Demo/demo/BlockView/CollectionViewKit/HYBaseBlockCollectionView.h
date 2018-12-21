//
//  HYBaseBlockCollectionView.h
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockCollectionView.h"
#import "HYBaseBlockCollectionView.h"
#import "HYBaseCollectionViewModel.h"
#import "HYBaseBlockTableView.h"


@class HYBaseCollectionSectionModel, HYBaseCollectionCellModel, HYBaseCollectionViewCell, HYBaseCollectionHeaderFooterView;
@interface HYBaseBlockCollectionViewConfigure : HYBlockCollectionViewConfigure

- (instancetype)configEmptyViewConfigure:(configureBlock)configure;
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes;
- (instancetype)configHeaderViewClasses:(NSArray<Class> *)classes;
- (instancetype)configFooterViewClasses:(NSArray<Class> *)classes;
- (instancetype)configSectionAndCellKey:(NSArray<NSString *> *(^)(void))block;

- (instancetype)configCellClassForRow:(Class(^)(HYBaseCollectionCellModel *cellModel, NSIndexPath * indexPath))block;
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseCollectionSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSIndexPath *indexPath))block;

- (instancetype)configCell:(void(^)(HYBaseCollectionViewCell *cell,
                                    HYBaseCollectionCellModel *cellModel,
                                    NSIndexPath *indexPath))block;
- (instancetype)configHeaderFooterView:(void(^)(HYBaseCollectionHeaderFooterView *headerFooterView,
                                                HYBaseCollectionSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSIndexPath *indexPath))block;
@end



@interface HYBaseBlockCollectionView : HYBlockCollectionView

+ (instancetype)colletionViewWithFrame:(CGRect)frame
                                layout:(UICollectionViewLayout *)layout
                           refreshType:(HYRefreshType)refreshType
                         refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                             viewModel:(id)viewModel
                             configure:(HYBaseBlockCollectionViewConfigure *)configure;

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub;

- (void)reloadWithViewModel:(id)viewModel
                 sectionKey:(NSString *)sectionKey
                    cellKey:(NSString *)cellKey;


- (void)showEmptyView;
- (void)dismissEmptyView;
- (id)getViewModel;

@end










