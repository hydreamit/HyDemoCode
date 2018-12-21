//
//  HYBaseCollectionHeaderFooterView.m
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseCollectionHeaderFooterView.h"


@interface HYBaseCollectionHeaderFooterView ()
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) NSIndexPath *indexPath;
@end


@implementation HYBaseCollectionHeaderFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfig];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)headerFooterViewWithCollectionView:(UICollectionView *)collectionView
                                         indexPath:(NSIndexPath *)indexPath
                                          isHeader:(BOOL)isHeader
                                         viewModel:(HYBaseCollectionViewModel *)viewModel {
    HYBaseCollectionHeaderFooterView *headerFooterView = [collectionView
                                                          dequeueReusableSupplementaryViewOfKind:(isHeader ? UICollectionElementKindSectionHeader : UICollectionElementKindSectionFooter) withReuseIdentifier:NSStringFromClass(self) forIndexPath:indexPath];
    headerFooterView.isHeader = isHeader;
    headerFooterView.indexPath = indexPath;
    headerFooterView.viewModel = viewModel;
    return headerFooterView;
}

- (void)initConfig {self.backgroundColor = [UIColor whiteColor];}
- (void)reloadHeaderFooterViewData {}
@end













