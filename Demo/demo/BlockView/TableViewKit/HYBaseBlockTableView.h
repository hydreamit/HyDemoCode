//
//  HYBaseBlockTableView.h
//  HYWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTableView.h"
#import "HYBaseTableViewModel.h"
#import "HYBaseTableCellModel.h"
#import "HYBaseTableSectionModel.h"

typedef NS_ENUM(NSUInteger, HYRefreshType) {
    HYRefreshTypeNone,           // 没有加载刷新控件
    HYRefreshTypePullDown,      // 只有下拉刷新
    HYRefreshTypePullUp,       // 只有上拉刷新
    HYRefreshTypePullDownAndUp// 既有下拉刷拉 又有上拉刷新
};

typedef NS_ENUM(NSUInteger, HYSeactionViewKinds) {
    SeactionHeaderView,  // seation 头部视图
    SeactionFooterView, // seation 尾部视图
};


@class HYBaseTableSectionModel, HYBaseTableCellModel, HYBaseTableViewCell, HYBaseTableViewHeaderFooterView;
@interface HYBaseBlockTableViewConfigure : HYBlockTableViewConfigure

- (instancetype)configEmptyViewConfigure:(configureBlock)configure;
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes;
- (instancetype)configSectionAndCellKey:(NSArray<NSString *> *(^)(void))block;
- (instancetype)configRegisterHeaderFooterViewClasses:(NSArray<Class> *(^)(HYSeactionViewKinds seactionViewKinds))block;

- (instancetype)configCellClassForRow:(Class(^)(HYBaseTableCellModel *cellModel, NSIndexPath * indexPath))block;
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseTableSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSUInteger section))block;

- (instancetype)configCell:(void(^)(HYBaseTableViewCell *cell,
                                    HYBaseTableCellModel *cellModel,
                                    NSIndexPath *indexPath))block;
- (instancetype)configHeaderFooterView:(void(^)(HYBaseTableViewHeaderFooterView *headerFooterView,
                                                HYBaseTableSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSUInteger section))block;
@end


typedef void(^RefreshAction)(void);
@interface HYBaseBlockTableView : HYBlockTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                       refreshType:(HYRefreshType)refreshType
                     refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                         viewModel:(HYBaseTableViewModel *)viewModel
                         configure:(HYBaseBlockTableViewConfigure *)configure;

- (void)reloadWithViewModel:(id)viewModel
                 sectionKey:(NSString *)sectionKey
                    cellKey:(NSString *)cellKey;


- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub;


- (void)showEmptyView;
- (void)dismissEmptyView;


/**
 插入cell
 
 @param cellModel cell的模型
 @param indexPath indexPath
 @param animation animation
 */
- (void)insertcellWithcellModel:(HYBaseTableCellModel *)cellModel
                        atIndexPath:(NSIndexPath *)indexPath
                   withRowAnimation:(UITableViewRowAnimation)animation;

/**
 删除Cell
 
 @param indexPaths indexPaths
 @param animation animation
 */
- (void)hy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation;


/**
 移动cell
 
 @param atIndexPath 从哪个位置indexPath
 @param toIndexPath 到哪个位置indexPath
 */
- (void)hy_moveRowAtIndexPath:(NSIndexPath *)atIndexPath
                  toIndexPath:(NSIndexPath *)toIndexPath;

@end












