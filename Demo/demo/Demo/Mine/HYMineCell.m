//
//  HYMineCell.m
//  demo
//
//  Created by huangyi on 2019/1/22.
//  Copyright © 2019年 huangyi. All rights reserved.
//

#import "HYMineCell.h"

@interface HYMineCell ()
@property (nonatomic,strong) QMUIButton *detailButton;
@property (nonatomic,strong) UIImageView *arrow;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *line;
@end

@implementation HYMineCell

- (void)initConfig {
    
    UIView *view = [UIView new];
    view.backgroundColor = UIColorMakeWithHex(@"#F0F3F8");
    self.selectedBackgroundView = view;
    
    [self configLayout];
}

- (void)reloadCellData {
    
   
    
}

- (void)configLayout {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(self.detailButton.mas_left).offset(-5);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.arrow setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisHorizontal];
    [self.arrow  setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                 forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_left).offset(-3);
        make.centerY.equalTo(self.arrow);
        make.height.mas_greaterThanOrEqualTo(1);
    }];
    
    [self.detailButton setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
    [self.detailButton  setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                        forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(.5);
    }];
}

#pragma mark - Getter & Setter
- (UILabel *)titleLabel{
    return Hy_Lazy(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorGray;
        [self.contentView addSubview:label];
        label;
    }));
}
- (QMUIButton *)detailButton {
    return Hy_Lazy(_detailButton, ({
        
        QMUIButton *button = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorMakeWithHex(@"#A1A8B1") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.imagePosition = QMUIButtonImagePositionRight;
        button.spacingBetweenImageAndTitle = 8;
        button.clipsToBounds = YES;
        button.userInteractionEnabled = NO;
        [self.contentView addSubview:button];
        button;
    }));
}
- (UIImageView *)arrow{
    return Hy_Lazy(_arrow,({
        UIImageView *arrow = [UIImageView new];
        arrow.image = UIImageMake(@"1.0.0_Bin_SettingArrow");
        [self.contentView addSubview:arrow];
        arrow;
    }));
}
- (UIView *)line{
    return Hy_Lazy(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorMakeWithHex(@"#D5DCE4");
        [self.contentView addSubview:view];
        view;
    }));
}

@end
