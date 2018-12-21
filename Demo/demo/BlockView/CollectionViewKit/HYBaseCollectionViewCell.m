//
//  HYBaseCollectionViewCell.m
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseCollectionViewCell.h"


@interface HYBaseCollectionViewCell ()
@property (nonatomic, strong) NSIndexPath *indexPath;
@end


@implementation HYBaseCollectionViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfigure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfigure];
    }
    return  self;
}

+ (instancetype)cellWithColletionView:(UICollectionView *)collectionView
                            indexPath:(NSIndexPath *)indexPath
                            viewModel:(HYBaseCollectionViewModel *)viewModel {
    
    HYBaseCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self)
                                              forIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.indexPath = indexPath;
    return cell;
}

- (void)initConfigure {}
- (void)reloadCellData {};
- (void)setCustomSubViewsArray:(NSArray<UIView *> *)customSubViewsArray {
    _customSubViewsArray = customSubViewsArray;
    for (UIView *subView in customSubViewsArray) {
        [self.contentView addSubview:subView];
    }
}

@end







