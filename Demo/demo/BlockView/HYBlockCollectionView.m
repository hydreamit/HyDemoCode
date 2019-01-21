//
//  HYBlockCollectionView.m
//  Demo
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockCollectionView.h"


@interface HYBlockCollectionViewConfigure ()
@property (nonatomic,copy) NSInteger(^numberOfSectionsBlock)(UICollectionView *collectionView);
@property (nonatomic,copy) NSInteger(^numberOfItemsInSectionBlock)(UICollectionView *collectionView, NSInteger section);
// cell
@property (nonatomic,copy) UICollectionViewCell *(^cellForItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath * indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didSelectItemAtIndexPathBlock)(UICollectionView *collectionView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisplayCellBlock)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath);
@property (nonatomic,copy) UICollectionReusableView  *(^seactionHeaderFooterViewBlock)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisPlayHeaderFooterViewBlock)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath);

@property (nonatomic,copy) CGSize(^layoutSizeBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath);
@property (nonatomic,copy) UIEdgeInsets(^layoutInsetsBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGFloat(^layoutMinimumLineSpacingBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGFloat(^layoutMinimumInteritemSpacingBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGSize(^layoutReferenceSizeForHeaderBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@property (nonatomic,copy) CGSize(^layoutReferenceSizeForFooterBlock)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section);
@end
@implementation HYBlockCollectionViewConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UICollectionView *collectionView))block {
    self.numberOfSectionsBlock = [block copy];
    return self;
}
- (instancetype)configNumberOfItemsInSection:(NSInteger (^)(UICollectionView *collectionView, NSInteger section))block {
    self.numberOfItemsInSectionBlock = [block copy];
    return self;
}
// cell
- (instancetype)configCellForItemAtIndexPath:(UICollectionViewCell *(^)(UICollectionView *collectionView, NSIndexPath *indexPath))block {
    self.cellForItemAtIndexPathBlock = [block copy];
    return self;
}
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UICollectionView *collectionView, NSIndexPath *indexPath))block {
    self.heightForRowAtIndexPathBlock = [block copy];
    return self;
}
- (instancetype)configDidSelectItemAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.didSelectItemAtIndexPathBlock = [block copy];
    return self;
}
- (instancetype)configWillDisplayCell:(void(^)(UICollectionView *collectionView,UICollectionViewCell *cell, NSIndexPath * indexPath))block {
    self.willDisplayCellBlock = [block copy];
    return self;
}
// header footer
- (instancetype)configSeactionHeaderFooterView:(UICollectionReusableView *(^)(UICollectionView *collectionView,NSString *kind, NSIndexPath * indexPath))block {
    self.seactionHeaderFooterViewBlock = [block copy];
    return self;
}
- (instancetype)configWillDisPlayHeaderFooterView:(void (^)(UICollectionView *collectionView,UICollectionReusableView *view,NSString *kind, NSIndexPath * indexPath))block {
     self.willDisPlayHeaderFooterViewBlock = [block copy];
    return self;
}
- (instancetype)configLayoutSize:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSIndexPath *indexPath))block {
    self.layoutSizeBlock = [block copy];
    return self;
}
- (instancetype)configLayoutInsets:(UIEdgeInsets (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block {
    self.layoutInsetsBlock = [block copy];
    return self;
}
- (instancetype)configLayoutMinimumLineSpacing:(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block {
    self.layoutMinimumLineSpacingBlock = [block copy];
    return self;
}

- (instancetype)configLayoutMinimumInteritemSpacing:(CGFloat (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block{
    self.layoutMinimumInteritemSpacingBlock = [block copy];
    return self;
}
- (instancetype)configLayoutReferenceSizeForHeader:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block {
    self.layoutReferenceSizeForHeaderBlock = [block copy];
    return self;
}
- (instancetype)configLayoutReferenceSizeForFooter:(CGSize (^)(UICollectionView *collectionView, UICollectionViewLayout *layout, NSInteger section))block {
    self.layoutReferenceSizeForFooterBlock = [block copy];
    return self;
}
@end




@interface HYBlockCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) HYBlockCollectionViewConfigure *configure;
@end


@implementation HYBlockCollectionView
+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              configure:(HYBlockCollectionViewConfigure *)configure
                  headerRefreshCallback:(void(^)(void))headerRefreshCallback
                  footerRefreshCallback:(void(^)(void))footerRefreshCallback {
    HYBlockCollectionView *colletionView =
    [[self alloc] initWithFrame:frame collectionViewLayout:layout];
    [colletionView addRefreshWithHeaderRefreshCallback:headerRefreshCallback
                                 footerRefreshCallback:footerRefreshCallback];
    colletionView.configure = configure;
    colletionView.dataSource = colletionView;
    colletionView.delegate = colletionView;
    return colletionView;
}

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              configure:(HYBlockCollectionViewConfigure *)configure
                         refreshCommand:(RACCommand *(^)(BOOL isHeaderFresh))refreshCommand {
    HYBlockCollectionView *colletionView =
    [[self alloc] initWithFrame:frame collectionViewLayout:layout];
    [colletionView addRefreshWithHeaderRefreshCallback:refreshCommand(YES).bindExcuteEmtyBlock(colletionView)
                             footerRefreshCallback:refreshCommand(NO).bindExcuteEmtyBlock(colletionView)];
    colletionView.configure = configure;
    colletionView.dataSource = colletionView;
    colletionView.delegate = colletionView;
    return colletionView;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSLog(@"%@", self.configure.numberOfSectionsBlock);
    
    return
    self.configure.numberOfSectionsBlock ?
    self.configure.numberOfSectionsBlock(collectionView) : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return
    self.configure.numberOfItemsInSectionBlock ?
    self.configure.numberOfItemsInSectionBlock(collectionView, section) : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.cellForItemAtIndexPathBlock ?
    self.configure.cellForItemAtIndexPathBlock(collectionView, indexPath) : nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.configure.willDisplayCellBlock ?
    self.configure.willDisplayCellBlock(collectionView,cell, indexPath) : nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.seactionHeaderFooterViewBlock ?
    self.configure.seactionHeaderFooterViewBlock(collectionView, kind, indexPath) : nil;
}

- (void)collectionView:(UICollectionView *)collectionView
willDisplaySupplementaryView:(UICollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath {
    self.configure.willDisPlayHeaderFooterViewBlock ?
    self.configure.willDisPlayHeaderFooterViewBlock(collectionView,view, elementKind, indexPath) : nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.configure.didSelectItemAtIndexPathBlock ?
    self.configure.didSelectItemAtIndexPathBlock(collectionView, indexPath) : nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        size = layout.itemSize;
    }
    return
    self.configure.layoutSizeBlock ?
    self.configure.layoutSizeBlock(collectionView, collectionViewLayout, indexPath) : size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        insets = layout.sectionInset;
    }
    return
    self.configure.layoutInsetsBlock ?
    self.configure.layoutInsetsBlock(collectionView, collectionViewLayout, section) : insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat height = 0.0;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        height = layout.minimumLineSpacing;
    }
    return
    self.configure.layoutMinimumLineSpacingBlock ?
    self.configure.layoutMinimumLineSpacingBlock(collectionView, collectionViewLayout, section) : height;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat height = 0.0;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        height = layout.minimumInteritemSpacing;
    }
    return
    self.configure.layoutMinimumInteritemSpacingBlock ?
    self.configure.layoutMinimumInteritemSpacingBlock(collectionView, collectionViewLayout, section) : height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        size = layout.headerReferenceSize;
    }
    return
    self.configure.layoutReferenceSizeForHeaderBlock ?
    self.configure.layoutReferenceSizeForHeaderBlock(collectionView, collectionViewLayout, section) : size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        size = layout.headerReferenceSize;
    }
    return
    self.configure.layoutReferenceSizeForFooterBlock ?
    self.configure.layoutReferenceSizeForFooterBlock(collectionView, collectionViewLayout, section) : size;
}

@end













