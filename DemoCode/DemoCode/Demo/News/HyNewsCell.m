//
//  HyNewsCell.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsCell.h"
#import "HyNewsModel.h"
#import <HyCategoriess/HyCategories.h>
#import <YYWebImage/YYWebImage.h>
#import "HyNewsCellEntity.h"

@interface HyNewsCell ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *newsTitleLabel;
@property (nonatomic, strong) UIImageView *newsImageView;
@end


@implementation HyNewsCell

- (void)hy_cellLoad {
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.newsImageView];
    [self.contentView addSubview:self.newsTitleLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)hy_reloadCellData {
    self.newsTitleLabel.attributedText = ((HyNewsCellEntity *)self.hy_cellData).titleAttr;
    [self.newsImageView yy_setImageWithURL:[NSURL URLWithString:((HyNewsCellEntity *)self.hy_cellData).imageUrlStr]
                               placeholder:nil
                                   options:YYWebImageOptionSetImageWithFadeAnimation |
                   YYWebImageOptionProgressiveBlur           |
                   YYWebImageOptionShowNetworkActivity
                                completion:nil];
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
        _newsImageView.backgroundColor = Hy_ColorWithRGB(239, 244, 254);
    }
    return _newsImageView;
}

- (UILabel *)newsTitleLabel {
    if (!_newsTitleLabel) {
        _newsTitleLabel = [[UILabel alloc] init];
        _newsTitleLabel.numberOfLines = 2;
        _newsTitleLabel.textColor = UIColor.darkTextColor;
        _newsTitleLabel.width = Hy_ScreenW - 30 - self.newsImageView.width;
        _newsTitleLabel.height = self.newsImageView.height;
        _newsTitleLabel.top = self.newsImageView.top;
        _newsTitleLabel.left = self.newsImageView.right + 10;
    }
    return _newsTitleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = Hy_ColorWithRGB(239, 244, 254);
        _lineView.height = .5;
        _lineView.width = Hy_ScreenW;
        _lineView.bottom = 80;
    }
    return _lineView;
}

@end
