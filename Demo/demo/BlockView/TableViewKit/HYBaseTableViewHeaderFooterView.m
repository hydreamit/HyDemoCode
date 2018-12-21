//
//  HYBaseTableViewHeaderFooterView.m
//  HYWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseTableViewHeaderFooterView.h"


@interface HYBaseTableViewHeaderFooterView ()
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) NSInteger section;
@end

@implementation HYBaseTableViewHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initConfigure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfigure];
    }
    return self;
}

+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView
                                      section:(NSInteger)section
                                     isHeader:(BOOL)isHeader
                                    viewModel:(HYBaseTableViewModel *)viewModel {
    HYBaseTableViewHeaderFooterView *headerFooterView =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    headerFooterView.section = section;
    headerFooterView.isHeader = isHeader;
    headerFooterView.viewModel = viewModel;
    return headerFooterView;
}

- (void)initConfigure {self.contentView.backgroundColor = [UIColor whiteColor];}
- (void)reloadHeaderFooterViewData {}

@end










