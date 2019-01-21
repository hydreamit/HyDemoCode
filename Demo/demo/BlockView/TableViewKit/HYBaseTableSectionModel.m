//
//  HYBaseTableSectionModel.m
//  Demo
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseTableSectionModel.h"

@implementation HYBaseTableSectionModel
- (NSMutableArray<HYBaseTableCellModel *> *)cellModels {
    return Hy_Lazy(_cellModels, ({
        @[].mutableCopy;
    }));
}
@end
