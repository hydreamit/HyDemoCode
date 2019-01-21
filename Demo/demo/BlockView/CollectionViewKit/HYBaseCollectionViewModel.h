//
//  HYBaseCollectionViewModel.h
//  Demo
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseViewModel.h"
#import "HYBaseTableViewModel.h"
#import "HYBaseCollectionCellModel.h"
#import "HYBaseCollectionSectionModel.h"


typedef NS_ENUM(NSUInteger, HYCollectionViewLoadDataType) {
    HYCollectionViewLoadDataTypeFirst,   // 一进页面获取数据 有HUD
    HYCollectionViewLoadDataTypeNew,    // 下拉刷新 刷新最新数据
    HYCollectionViewLoadDataTypeMore,  // 上拉刷新 加载更多
};



@interface HYBaseCollectionViewModel : HYBaseViewModel
typedef NSDictionary *(^collectionViewDataAnalyzeBlock)(NSDictionary *respose);
typedef RACCommand *(^collectionViewCommandBlock)(HYCollectionViewLoadDataType type);


@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic,assign) HYCollectionViewLoadDataType currentLoadDataType;
@property (nonatomic, strong) NSMutableArray<HYBaseCollectionSectionModel *> *sectionModels;


- (NSInteger)getLoadDataPageNumber;
- (requestUrlBlock)configtUrl;
- (requestParamsBlock)configParams;
- (requestCommandBlock)configrequestCommand;
- (collectionViewDataAnalyzeBlock)configDataParams;
- (collectionViewCommandBlock)collectionViewExecuteCommand;

- (HYBaseCollectionSectionModel *)getSectionModelAtSection:(NSInteger)section;
- (HYBaseCollectionCellModel *)getCellModelAtIndexPath:(NSIndexPath *)indexPath;

@end
