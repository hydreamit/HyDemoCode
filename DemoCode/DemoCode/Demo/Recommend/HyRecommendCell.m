//
//  HyRecommendCell.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRecommendCell.h"
#import <HyCategoriess/HyCategories.h>
#import "HyModelProtocol.h"
#import <YYWebImage/YYWebImage.h>


@interface HyRecommendCell ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *icon;
@end


@implementation HyRecommendCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleL];
    }
    return  self;
}

- (void)hy_reloadCellData {
    
    NSObject<HyModelProtocol> *model = self.hy_cellData;
    self.titleL.text = model.parameter[@"topicName"];
    [self.icon yy_setImageWithURL:[NSURL URLWithString:model.parameter[@"iconUrl"]]
                   placeholder:nil
                       options:YYWebImageOptionSetImageWithFadeAnimation |
                    YYWebImageOptionProgressiveBlur           |
                    YYWebImageOptionShowNetworkActivity
                    completion:nil];
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.numberOfLines = 1;
        _titleL.textColor = UIColor.darkTextColor;;
        _titleL.text = @"山东省";
        _titleL.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f] ;
        [_titleL sizeToFit];
        _titleL.width = self.icon.width;
        _titleL.left = self.icon.left;
        _titleL.top = self.icon.bottom + 5;
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
