//
//  HYBaseCollectionSectionModel.h
//  Demo
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseModel.h"
#import "HYBaseCollectionCellModel.h"

@interface HYBaseCollectionSectionModel : HYBaseModel
@property (nonatomic,strong) NSMutableArray<HYBaseCollectionCellModel *> *cellModels;
- (instancetype)handleModel;
@end
