//
//  HYBaseTableViewHeaderFooterView.h
//  Demo
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseTableSectionModel.h"
#import "HYBaseTableViewModel.h"

@interface HYBaseTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign, readonly) BOOL isHeader;
@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic,strong) HYBaseTableViewModel *viewModel;
@property (nonatomic,strong) HYBaseTableSectionModel *sectionModel;

- (void)initConfigure;
- (void)reloadHeaderFooterViewData;
+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView
                                      section:(NSInteger)section
                                     isHeader:(BOOL)isHeader
                                    viewModel:(HYBaseTableViewModel *)viewModel;

@end
