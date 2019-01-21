//
//  HYBaseTableSectionModel.h
//  Demo
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseModel.h"
#import "HYBaseTableCellModel.h"

@interface HYBaseTableSectionModel : HYBaseModel

@property (nonatomic,strong) NSMutableArray<HYBaseTableCellModel *> *cellModels;

@end
