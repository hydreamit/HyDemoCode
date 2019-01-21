//
//  HYBaseTableViewModel.h
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseViewModel.h"
#import "HYBaseTableCellModel.h"
#import "HYBaseTableSectionModel.h"
#define CellModelDataKey @"cellModelData"
#define CellModelClassKey @"cellModelClass"
#define SectionModelDataKey @"sectionModelData"
#define SectionModelClassKey @"sectionModelClass"


typedef NS_ENUM(NSUInteger, HYTableViewLoadDataType) {
    HYTableViewLoadDataTypeFirst,   // 一进页面获取数据 有HUD
    HYTableViewLoadDataTypeNew,    // 下拉刷新 刷新最新数据
    HYTableViewLoadDataTypeMore,  // 上拉刷新 加载更多
};


@interface HYBaseTableViewModel : HYBaseViewModel
typedef NSDictionary *(^tableViewDataAnalyzeBlock)(NSDictionary *respose);
typedef RACCommand *(^tableViewCommandBlock)(HYTableViewLoadDataType type);


@property (nonatomic,assign) BOOL isGetRequest;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) HYTableViewLoadDataType currentLoadDataType;
@property (nonatomic, strong) NSMutableArray<HYBaseTableSectionModel *> *sectionModels;


- (NSInteger)getLoadDataPageNumber;
- (requestUrlBlock)configtUrl;
- (requestParamsBlock)configParams;
- (requestCommandBlock)configrequestCommand;
- (tableViewDataAnalyzeBlock)configDataParams;
- (tableViewCommandBlock)tableViewExecuteCommand;

- (HYBaseTableSectionModel *)getSectionModelAtSection:(NSInteger)section;
- (HYBaseTableCellModel *)getCellModelAtIndexPath:(NSIndexPath *)indexPath;

@end



















