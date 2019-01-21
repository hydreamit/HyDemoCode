//
//  HYBaseTableViewCell.h
//  Demo
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseTableViewModel.h"
#import "HYBaseTableViewCell.h"

@interface HYBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) HYBaseTableViewModel *viewModel;
@property (nonatomic, strong) HYBaseTableCellModel *cellModel;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;
@property (nonatomic, strong) NSArray<UIView *> *customSubViewsArray;


- (void)initConfigure;
- (void)reloadCellData;
+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                        viewModel:(HYBaseTableViewModel *)viewModel;

@end
