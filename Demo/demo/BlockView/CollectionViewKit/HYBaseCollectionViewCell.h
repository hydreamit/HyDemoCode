//
//  HYBaseCollectionViewCell.h
//  Demo
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseCollectionCellModel.h"
#import "HYBaseCollectionViewModel.h"

@interface HYBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray<UIView *> *customSubViewsArray;
@property (nonatomic, strong) HYBaseCollectionViewModel *viewModel;
@property (nonatomic, strong) HYBaseCollectionCellModel *cellModel;


- (void)initConfigure;
- (void)reloadCellData;
+ (instancetype)cellWithColletionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                            viewModel:(HYBaseCollectionViewModel *)viewModel;
@end
