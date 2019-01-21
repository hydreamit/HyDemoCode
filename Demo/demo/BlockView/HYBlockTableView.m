//
//  HYBlockTableView.m
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTableView.h"

@interface HYBlockTableViewConfigure ()
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
@end


@interface HYBlockTableView ()<UITableViewDataSource, UITableViewDelegate>
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
    tableView.dataSource = tableView;
    tableView.delegate = tableView;
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
    tableView.dataSource = tableView;
    tableView.delegate = tableView;
    return tableView;
}

- (void)refreshConfigure:(HYBlockTableViewConfigure *)configure {
    self.configure = configure;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return
    self.configure.numberOfSections ?
    self.configure.numberOfSections(tableView) : 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return
    self.configure.numberOfRowsInSection ?
    self.configure.numberOfRowsInSection(tableView, section) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.cellForRowAtIndexPath ?
    self.configure.cellForRowAtIndexPath(tableView, indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.configure.willDisplayCell ?
    self.configure.willDisplayCell(tableView, cell, indexPath) : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return
    self.configure.viewForHeaderInSection ?
    self.configure.viewForHeaderInSection(tableView, section) : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return
    self.configure.viewForFooterInSection ?
    self.configure.viewForFooterInSection(tableView, section) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
    self.configure.willDisplayHeaderView ?
    self.configure.willDisplayHeaderView(tableView, view,section) : nil;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view
       forSection:(NSInteger)section {
    self.configure.willDisplayFooterView ?
    self.configure.willDisplayFooterView(tableView, view, section) : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.heightForRowAtIndexPath ?
    self.configure.heightForRowAtIndexPath(tableView, indexPath) : tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return
    self.configure.heightForHeaderInSection ?
    self.configure.heightForHeaderInSection(tableView, section) : (tableView.sectionHeaderHeight > 0 ? tableView.sectionHeaderHeight : 0.001);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return
    self.configure.heightForFooterInSection ?
    self.configure.heightForFooterInSection(tableView, section) : (tableView.sectionFooterHeight > 0 ? tableView.sectionFooterHeight : 0.001);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.configure.didSelectRowAtIndexPath ?
    self.configure.didSelectRowAtIndexPath(tableView, indexPath) : nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.configure.didDeselectRowAtIndexPath ?
    self.configure.didDeselectRowAtIndexPath(tableView, indexPath) : nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.canEditRowAtIndexPath ?
    self.configure.canEditRowAtIndexPath(tableView, indexPath) : NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.editingStyleForRowAtIndexPath ?
    self.configure.editingStyleForRowAtIndexPath(tableView, indexPath) : 0;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                          forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.configure.commitEditingStyle ?
    self.configure.commitEditingStyle(tableView, editingStyle, indexPath) : 0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.editActionsForRowAtIndexPath ?
    self.configure.editActionsForRowAtIndexPath(tableView, indexPath) : 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollBlock ?:
    self.configure.scrollViewDidScrollBlock(scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.configure.scrollViewDidZoomBlock ?:
    self.configure.scrollViewDidZoomBlock(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDraggingBlock ?:
    self.configure.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDeceleratingBlock ?:
    self.configure.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndDeceleratingBlock ?:
    self.configure.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndScrollingAnimationBlock ?:
    self.configure.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.configure.viewForZoomingInScrollViewBlock ?
    self.configure.viewForZoomingInScrollViewBlock(scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.configure.scrollViewWillEndDraggingBlock ?
    self.configure.scrollViewWillEndDraggingBlock(scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.configure.scrollViewDidEndDraggingBlock ?
    self.configure.scrollViewDidEndDraggingBlock(scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.configure.scrollViewWillBeginZoomingBlock ?
    self.configure.scrollViewWillBeginZoomingBlock(scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.configure.scrollViewDidEndZoomingBlock ?
    self.configure.scrollViewDidEndZoomingBlock(scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.configure.scrollViewShouldScrollToTopBlock ?
    self.configure.scrollViewShouldScrollToTopBlock(scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollToTopBlock ?:
    self.configure.scrollViewDidScrollToTopBlock(scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidChangeAdjustedContentInsetBlock ?:
    self.configure.scrollViewDidChangeAdjustedContentInsetBlock(scrollView);
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.canMoveRowAtIndexPath ?
    self.configure.canMoveRowAtIndexPath(tableView, indexPath) : NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return
    self.configure.shouldIndentWhileEditingRowAtIndexPath ?
    self.configure.shouldIndentWhileEditingRowAtIndexPath(tableView, indexPath) : YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return
    self.configure.targetIndexPathForMoveFromRowAtIndexPath ?
    self.configure.targetIndexPathForMoveFromRowAtIndexPath
    (tableView, sourceIndexPath, proposedDestinationIndexPath) : proposedDestinationIndexPath;
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    !self.configure.moveRowAtIndexPath ?:
    self.configure.moveRowAtIndexPath(tableView, sourceIndexPath, destinationIndexPath);
}
@end














