//
//  HYBlockTableView.h
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBlockScrollView.h"


@interface HYBlockTableViewConfigure : HYBlockScrollViewConfigure
- (instancetype)configNumberOfSections:(NSInteger (^)(UITableView *tableView))block;
- (instancetype)configNumberOfRowsInSection:(NSInteger (^)(UITableView *tableView, NSInteger section))block;
// cell
- (instancetype)configCellForRowAtIndexPath:(UITableViewCell *(^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configHeightForRowAtIndexPath:(CGFloat (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configDidSelectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configDidDeselectRowAtIndexPath:(void (^)(UITableView *tableView, NSIndexPath *indexPath))block;
- (instancetype)configWillDisplayCell:(void(^)(UITableView *tableView,UITableViewCell *cell, NSIndexPath * indexPath))block;
// sectionHeader
- (instancetype)configHeightForHeaderInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configViewForHeaderInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configWillDisplayHeaderView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block;
// sectionFooter
- (instancetype)configHeightForFooterInSection:(CGFloat (^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configViewForFooterInSection:(UIView *(^)(UITableView *tableView,NSInteger section))block;
- (instancetype)configWillDisplayFooterView:(void (^)(UITableView *tableView,UIView *view,NSInteger section))block;
//Edit
- (instancetype)configCanEditRowAtIndexPath:(BOOL (^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configEditingStyleForRowAtIndexPath:(UITableViewCellEditingStyle (^)(UITableView *tableView, NSIndexPath * indexPath))block;
- (instancetype)configCommitEditingStyle:(UITableViewCellEditingStyle (^)(UITableView *tableView,UITableViewCellEditingStyle editingStyle ,NSIndexPath * indexPath))block;
- (instancetype)configEditActionsForRowAtIndexPath:(NSArray<UITableViewRowAction *> * (^)(UITableView *tableView ,NSIndexPath * indexPath))block;

- (instancetype)configCanMoveRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block;

- (instancetype)configShouldIndentWhileEditingRowAtIndexPath:(BOOL(^)(UITableView *tableView, NSIndexPath * indexPath))block;

- (instancetype)configTargetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *(^)(UITableView *tableView, NSIndexPath *sourceIndexPath , NSIndexPath *toProposedIndexPath))block;

- (instancetype)configMoveRowAtIndexPath:(void(^)(UITableView *tableView, NSIndexPath * sourceIndexPath,  NSIndexPath * destinationIndexPath))block;


@end



@interface HYBlockTableView : UITableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         configure:(HYBlockTableViewConfigure *)configure
             headerRefreshCallback:(void(^)(void))headerRefreshCallback
             footerRefreshCallback:(void(^)(void))footerRefreshCallback;


+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         configure:(HYBlockTableViewConfigure *)configure
                    refreshCommand:(RACCommand *(^)(BOOL isHeaderFresh))refreshCommand;


- (void)refreshConfigure:(HYBlockTableViewConfigure *)configure;

@end





















