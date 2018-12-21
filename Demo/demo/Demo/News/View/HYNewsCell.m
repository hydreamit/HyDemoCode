//
//  HYNewsCell.m
//  HYBaseProject
//
//  Created by huangyi on 17/9/27.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYNewsCell.h"
#import "HYNewsCellModel.h"
#import "UIImageView+HYExtension.h"


@interface HYNewsCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YYLabel *newsTitleLabel;
@property (nonatomic, strong) UIImageView *newsImageView;
@property (nonatomic, strong) HYNewsCellModel *cellModel;
@end

@implementation HYNewsCell
@dynamic cellModel;
- (void)initConfigure {
    [super initConfigure];
    self.customSubViewsArray = @[self.newsImageView,
                                 self.newsTitleLabel,
                                 self.lineView];
}

- (void)reloadCellData {
    self.newsTitleLabel.attributedText = self.cellModel.titleAttr;
    [self.newsImageView fadeImageWithUrl:self.cellModel.imageUrlStr
                             placeholder:nil];
}

- (UIImageView *)newsImageView {
    if (!_newsImageView) {
        _newsImageView = [[UIImageView alloc] init];
        _newsImageView.size = CGSizeMake(80,  60);
        _newsImageView.top = 10;
        _newsImageView.left = 10;
        _newsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _newsImageView.clipsToBounds = YES;
        _newsImageView.layer.cornerRadius = 2.5;
        _newsImageView.layer.masksToBounds = YES;
        _newsImageView.backgroundColor = PageColor;
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
        _newsTitleLabel.width = ScreenW - 30 - self.newsImageView.width;
        _newsTitleLabel.height = self.newsImageView.height;
        _newsTitleLabel.top = self.newsImageView.top;
        _newsTitleLabel.left = self.newsImageView.right + 10;
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
        _lineView.bottom = 80;
    }
    return _lineView;
}

@end
