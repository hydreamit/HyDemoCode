//
//  HYNewsImageCell.m
//  HYBaseProject
//
//  Created by huangyi on 2017/11/10.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYNewsImageCell.h"
#import "HYNewsCellModel.h"
#import <YYKit/YYKit.h>
#import "UIImageView+HYExtension.h"


@interface HYNewsImageCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YYLabel *newsTitleLabel;
@property (nonatomic, strong) UIImageView *newsImageView;
@property (nonatomic, strong) HYNewsCellModel *cellModel;
@end


@implementation HYNewsImageCell
@dynamic cellModel;
- (void)initConfigure {
    [super initConfigure];
    self.customSubViewsArray = @[
                                 self.newsTitleLabel,
                                 self.newsImageView,
                                 self.lineView];
}

- (void)reloadCellData {
    self.newsTitleLabel.attributedText = self.cellModel.titleAttr;
    [self.newsImageView fadeImageWithUrl:self.cellModel.imageUrlStr
                             placeholder:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.newsImageView.bottom = self.height - 10;
    self.lineView.bottom = self.height;
}

- (UIImageView *)newsImageView {
    if (!_newsImageView) {
        _newsImageView = [[UIImageView alloc] init];
        _newsImageView.size = CGSizeMake(ScreenW - 20,  100);
        _newsImageView.left = 10;
        _newsImageView.bottom = 140;
        _newsImageView.clipsToBounds = YES;
        _newsImageView.layer.cornerRadius = 2.5;
        _newsImageView.layer.masksToBounds = YES;
        _newsImageView.backgroundColor = PageColor;
        _newsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _newsImageView;
}

- (YYLabel *)newsTitleLabel {
    if (!_newsTitleLabel) {
        _newsTitleLabel = [[YYLabel alloc] init];
        _newsTitleLabel.numberOfLines = 2;
        _newsTitleLabel.displaysAsynchronously = YES;
        _newsTitleLabel.fadeOnAsynchronouslyDisplay = NO;
        _newsTitleLabel.fadeOnHighlight = NO;
        _newsTitleLabel.textColor = TitleColor;
        _newsTitleLabel.top = 10;
        _newsTitleLabel.left = 10;
        _newsTitleLabel.width = self.newsImageView.width;
        _newsTitleLabel.height = 100;
        _newsTitleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _newsTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = PageColor;
        _lineView.height = .5;
        _lineView.width = ScreenW;
        _lineView.bottom = 150;
    }
    return _lineView;
}

@end
