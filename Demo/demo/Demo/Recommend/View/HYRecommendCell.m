//
//  HYRecommendCell.m
//  HYBaseProject
//
//  Created by huangyi on 2017/11/28.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYRecommendCell.h"
#import "HYRecommendCellModel.h"

@interface HYRecommendCell ()
@property (nonatomic, strong) YYLabel *titleL;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) HYRecommendCellModel *cellModel;
@end

@implementation HYRecommendCell
@dynamic cellModel;
- (void)initConfigure {
    [super initConfigure];
    self.backgroundColor = [UIColor whiteColor];
    self.customSubViewsArray = @[self.icon, self.titleL];
}

- (void)reloadCellData {
    [super reloadCellData];
    self.titleL.text = self.cellModel.topicName;
    [self.icon fadeImageWithUrl:self.cellModel.iconUrl placeholder:nil];
}

- (YYLabel *)titleL {
    if (!_titleL) {
        _titleL = [[YYLabel alloc] init];
        _titleL.numberOfLines = 1;
        _titleL.displaysAsynchronously = YES;
        _titleL.fadeOnAsynchronouslyDisplay = NO;
        _titleL.fadeOnHighlight = NO;
        _titleL.textColor = TitleColor;
        _titleL.text = @"山东省";
        _titleL.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ;
        [_titleL sizeToFit];
        _titleL.width = self.icon.width;
        _titleL.left = self.icon.left;
        _titleL.top = self.icon.bottom + 5;
        _titleL.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _titleL.textAlignment = NSTextAlignmentCenter;
    }
    return _titleL;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.size = CGSizeMake(78, 78);
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}

@end
