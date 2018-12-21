//
//  HYBaseCollectionHeaderFooterView.h
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseCollectionViewModel.h"
#import "HYBaseCollectionSectionModel.h"


@interface HYBaseCollectionHeaderFooterView : UICollectionReusableView

@property (nonatomic, assign, readonly) BOOL isHeader;
@property (nonatomic, assign, readonly) NSIndexPath *indexPath;
@property (nonatomic,strong) HYBaseCollectionViewModel *viewModel;
@property (nonatomic,strong) HYBaseCollectionSectionModel *sectionModel;


- (void)initConfig;
- (void)reloadHeaderFooterViewData;
+ (instancetype)headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                         indexPath:(NSIndexPath *)indexPath
                                          isHeader:(BOOL)isHeader
                                         viewModel:(HYBaseCollectionViewModel *)viewModel;
@end
