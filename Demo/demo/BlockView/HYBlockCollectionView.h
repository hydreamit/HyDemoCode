//
//  HYBlockCollectionView.h
//  Demo
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBlockScrollView.h"


@interface HYBlockCollectionViewConfigure : HYBlockScrollViewConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UICollectionView *collectionView))block;
- (instancetype)configNumberOfItemsInSection:(NSInteger (^)(UICollectionView *collectionView, NSInteger section))block;
// cell
- (instancetype)configCellForItemAtIndexPath:(UICollectionViewCell *(^)(UICollectionView *collectionView, NSIndexPath *indexPath))block;
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UICollectionView *collectionView, NSIndexPath *indexPath))block;
- (instancetype)configDidSelectItemAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configWillDisplayCell:(void(^)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath))block;
// header footer
- (instancetype)configSeactionHeaderFooterView:(UICollectionReusableView *(^)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath))block;
- (instancetype)configWillDisPlayHeaderFooterView:(void (^)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath))block;

// layout
- (instancetype)configLayoutSize:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath))block;
- (instancetype)configLayoutInsets:(UIEdgeInsets (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutMinimumLineSpacing:(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutMinimumInteritemSpacing:(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutReferenceSizeForHeader:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
- (instancetype)configLayoutReferenceSizeForFooter:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block;
@end


@interface HYBlockCollectionView : UICollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              configure:(HYBlockCollectionViewConfigure *)configure
                  headerRefreshCallback:(void(^)(void))headerRefreshCallback
                  footerRefreshCallback:(void(^)(void))footerRefreshCallback;

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              configure:(HYBlockCollectionViewConfigure *)configure
                         refreshCommand:(RACCommand *(^)(BOOL isHeaderFresh))refreshCommand;



@end















