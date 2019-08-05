//
//  HYBlockTableView.m
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTableView.h"

@interface HYBlockTableViewConfigure () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);
// cell
@property (nonatomic,copy) UITableViewCell *(^cellForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) CGFloat (^heightForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^didDeselectRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^willDisplayCell)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath);
// sectionHeader
@property (nonatomic,copy) CGFloat (^heightForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForHeaderInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayHeaderView)(UITableView *tableView,UIView *view,NSInteger section);
// sectionFooter
@property (nonatomic,copy) CGFloat (^heightForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) UIView *(^viewForFooterInSection)(UITableView *tableView,NSInteger section);
@property (nonatomic,copy) void (^willDisplayFooterView)(UITableView *tableView,UIView *view,NSInteger section);
//Edit
@property (nonatomic,copy) BOOL (^canEditRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) UITableViewCellEditingStyle
(^editingStyleForRowAtIndexPath)(UITableView *tableView, NSIndexPath * indexPath);
@property (nonatomic,copy) void (^commitEditingStyle)
(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSArray<UITableViewRowAction *> *
(^editActionsForRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^canMoveRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) BOOL (^shouldIndentWhileEditingRowAtIndexPath)(UITableView *tableView ,NSIndexPath * indexPath);
@property (nonatomic,copy) NSIndexPath *(^targetIndexPathForMoveFromRowAtIndexPath)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath);
@property (nonatomic,copy) void (^moveRowAtIndexPath)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath);
@end
@implementation HYBlockTableViewConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UITableView *tableView))block {
    self.numberOfSections = [block copy];
    return self;
}
- (instancetype)configNumberOfRowsInSection:(NSInteger (^)(UITableView *tableView, NSInteger section))block {
    self.numberOfRowsInSection = [block copy];
    return self;
}
- (instancetype)configCellForRowAtIndexPath:(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.cellForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.heightForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configDidSelectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.didSelectRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configDidDeselectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block {
    self.didDeselectRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configWillDisplayCell:(void (^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath))block {
    self.willDisplayCell = [block copy];
    return self;
}
- (instancetype)configHeightForHeaderInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block {
    self.heightForHeaderInSection = [block copy];
    return self;
}
- (instancetype)configViewForHeaderInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block {
    self.viewForHeaderInSection = [block copy];
    return self;
}
- (instancetype)configWillDisplayHeaderView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block {
    self.willDisplayHeaderView = [block copy];
    return self;
}
- (instancetype)configHeightForFooterInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block {
    self.heightForFooterInSection = [block copy];
    return self;
}
- (instancetype)configViewForFooterInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block {
    self.viewForFooterInSection = [block copy];
    return self;
}
- (instancetype)configWillDisplayFooterView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block {
    self.willDisplayFooterView = [block copy];
    return self;
}
- (instancetype)configCanEditRowAtIndexPath:(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.canEditRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configEditingStyleForRowAtIndexPath:(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.editingStyleForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configCommitEditingStyle:(UITableViewCellEditingStyle (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath))block {
    self.commitEditingStyle = [block copy];
    return self;
}
- (instancetype)configEditActionsForRowAtIndexPath:(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath))block {
    self.editActionsForRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configCanMoveRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.canMoveRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configShouldIndentWhileEditingRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block {
    self.shouldIndentWhileEditingRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath))block {
    self.targetIndexPathForMoveFromRowAtIndexPath = [block copy];
    return self;
}
- (instancetype)configMoveRowAtIndexPath:(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath))block {
    self.moveRowAtIndexPath = [block copy];
    return self;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return
    self.numberOfSections ?
    self.numberOfSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return
    self.numberOfRowsInSection ?
    self.numberOfRowsInSection(tableView, section) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.cellForRowAtIndexPath ?
    self.cellForRowAtIndexPath(tableView, indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.willDisplayCell ?
    self.willDisplayCell(tableView, cell, indexPath) : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return
    self.viewForHeaderInSection ?
    self.viewForHeaderInSection(tableView, section) : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return
    self.viewForFooterInSection ?
    self.viewForFooterInSection(tableView, section) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    self.willDisplayHeaderView ?
    self.willDisplayHeaderView(tableView, view,section) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view
       forSection:(NSInteger)section {
    self.willDisplayFooterView ?
    self.willDisplayFooterView(tableView, view, section) : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.heightForRowAtIndexPath ?
    self.heightForRowAtIndexPath(tableView, indexPath) : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return
    self.heightForHeaderInSection ?
    self.heightForHeaderInSection(tableView, section) : (tableView.sectionHeaderHeight > 0 ? tableView.sectionHeaderHeight : 0.001);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return
    self.heightForFooterInSection ?
    self.heightForFooterInSection(tableView, section) : (tableView.sectionFooterHeight > 0 ? tableView.sectionFooterHeight : 0.001);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didSelectRowAtIndexPath ?
    self.didSelectRowAtIndexPath(tableView, indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.didDeselectRowAtIndexPath ?
    self.didDeselectRowAtIndexPath(tableView, indexPath) : nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.canEditRowAtIndexPath ?
    self.canEditRowAtIndexPath(tableView, indexPath) : NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.editingStyleForRowAtIndexPath ?
    self.editingStyleForRowAtIndexPath(tableView, indexPath) : 0;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.commitEditingStyle ?
    self.commitEditingStyle(tableView, editingStyle, indexPath) : 0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.editActionsForRowAtIndexPath ?
    self.editActionsForRowAtIndexPath(tableView, indexPath) : 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollViewDidScrollBlock ?:
    self.scrollViewDidScrollBlock(scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.scrollViewDidZoomBlock ?:
    self.scrollViewDidZoomBlock(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDraggingBlock ?:
    self.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDeceleratingBlock ?:
    self.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewDidEndDeceleratingBlock ?:
    self.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.scrollViewDidEndScrollingAnimationBlock ?:
    self.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.viewForZoomingInScrollViewBlock ?
    self.viewForZoomingInScrollViewBlock(scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.scrollViewWillEndDraggingBlock ?
    self.scrollViewWillEndDraggingBlock(scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scrollViewDidEndDraggingBlock ?
    self.scrollViewDidEndDraggingBlock(scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.scrollViewWillBeginZoomingBlock ?
    self.scrollViewWillBeginZoomingBlock(scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.scrollViewDidEndZoomingBlock ?
    self.scrollViewDidEndZoomingBlock(scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.scrollViewShouldScrollToTopBlock ?
    self.scrollViewShouldScrollToTopBlock(scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.scrollViewDidScrollToTopBlock ?:
    self.scrollViewDidScrollToTopBlock(scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.scrollViewDidChangeAdjustedContentInsetBlock ?:
    self.scrollViewDidChangeAdjustedContentInsetBlock(scrollView);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.canMoveRowAtIndexPath ?
    self.canMoveRowAtIndexPath(tableView, indexPath) : NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.shouldIndentWhileEditingRowAtIndexPath ?
    self.shouldIndentWhileEditingRowAtIndexPath(tableView, indexPath) : YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return
    self.targetIndexPathForMoveFromRowAtIndexPath ?
    self.targetIndexPathForMoveFromRowAtIndexPath
    (tableView, sourceIndexPath, proposedDestinationIndexPath) : proposedDestinationIndexPath;
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    !self.moveRowAtIndexPath ?:
    self.moveRowAtIndexPath(tableView, sourceIndexPath, destinationIndexPath);
}
@end


@interface HYBlockTableView ()
@property (nonatomic, strong) HYBlockTableViewConfigure *configure;
@end


@implementation HYBlockTableView
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         configure:(HYBlockTableViewConfigure *)configure
             headerRefreshCallback:(void(^)(void))headerRefreshCallback
             footerRefreshCallback:(void(^)(void))footerRefreshCallback {
    
    HYBlockTableView *tableView = [[self alloc] initWithFrame:frame style:style];
    [tableView addRefreshWithHeaderRefreshCallback:headerRefreshCallback
                             footerRefreshCallback:footerRefreshCallback];
    tableView.configure = configure;
    [tableView initConfigure];
    return tableView;
}

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         configure:(HYBlockTableViewConfigure *)configure
                    refreshCommand:(RACCommand *(^)(BOOL isHeaderFresh))refreshCommand {
    
    HYBlockTableView *tableView = [[self alloc] initWithFrame:frame style:style];
    [tableView addRefreshWithHeaderRefreshCallback:refreshCommand(YES).bindExcuteEmtyBlock(tableView)
                             footerRefreshCallback:refreshCommand(NO).bindExcuteEmtyBlock(tableView)];
    tableView.configure = configure;
    [tableView initConfigure];
    return tableView;
}

- (void)initConfigure {
    
    if (self.configure) {
        self.dataSource = self.configure;
        self.delegate = self.configure;
    }
    
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.panGestureRecognizer.cancelsTouchesInView = NO;
    if (@available(iOS 11.0, *)){
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

@end














