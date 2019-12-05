//
//  HyNewsImageCell.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsImageCell.h"
#import "HyNewsModel.h"
#import <HyCategoriess/HyCategories.h>
#import <YYWebImage/YYWebImage.h>

@interface HyNewsImageCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UIImageView *newsImageView;
@end


@implementation HyNewsImageCell

- (void)hy_cellLoad {
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.newsTitleLabel];
    [self.contentView addSubview:self.newsImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)hy_reloadCellData {
    self.newsTitleLabel.attributedText = ((HyNewsModel *)self.hy_cellData).titleAttr;
    [self.newsImageView yy_setImageWithURL:[NSURL URLWithString:((HyNewsModel *)self.hy_cellData).imageUrlStr]
                    placeholder:nil
                        options:YYWebImageOptionSetImageWithFadeAnimation |
                     YYWebImageOptionProgressiveBlur           |
                     YYWebImageOptionShowNetworkActivity
                     completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.newsTitleLabel.height = self.height - 130;
    self.newsImageView.bottom = self.height - 10;
    self.lineView.bottom = self.height;
}

- (UIImageView *)newsImageView {
    if (!_newsImageView) {
        _newsImageView = [[UIImageView alloc] init];
        _newsImageView.size = CGSizeMake(Hy_ScreenW - 20,  100);
        _newsImageView.left = 10;
        _newsImageView.clipsToBounds = YES;
        _newsImageView.layer.cornerRadius = 2.5;
        _newsImageView.layer.masksToBounds = YES;
        _newsImageView.backgroundColor = Hy_ColorWithRGB(239, 244, 254);
        _newsImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _newsImageView;
}

- (UILabel *)newsTitleLabel {
    if (!_newsTitleLabel) {
        _newsTitleLabel = [[UILabel alloc] init];
        _newsTitleLabel.numberOfLines = 0;
        _newsTitleLabel.textColor = UIColor.darkTextColor;
        _newsTitleLabel.top = 10;
        _newsTitleLabel.left = 10;
        _newsTitleLabel.width = Hy_ScreenW - 20;
    }
    return _newsTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
         _lineView.backgroundColor = Hy_ColorWithRGB(239, 244, 254);
        _lineView.height = .5;
        _lineView.width = Hy_ScreenW;
        _lineView.bottom = 150;
    }
    return _lineView;
}
@end
