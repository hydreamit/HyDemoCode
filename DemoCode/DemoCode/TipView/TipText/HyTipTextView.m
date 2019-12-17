//
//  HyTipTextView.m
//  DemoCode
//
//  Created by Hy on 2017/12/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipTextView.h"


@interface HyTipTextView ()
@property (nonatomic,strong) UIVisualEffectView *backV;
@property (nonatomic,strong) UILabel *label;
@end


@implementation HyTipTextView

+ (instancetype)tipTextViewWithText:(NSString *)text {
    
    HyTipTextView *view = [[self alloc] init];
    view.frame = CGRectMake(0, 0, 200, 200);
    
    UIVisualEffectView *backV = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backV.backgroundColor = UIColor.blackColor;
//    backV.alpha = .8;
    backV.layer.cornerRadius = 8.0;
    backV.layer.masksToBounds = YES;
    [view addSubview:backV];
    view.backV = backV;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    if (text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,
                                 NSForegroundColorAttributeName: UIColor.whiteColor,
                                 NSParagraphStyleAttributeName : paragraphStyle };
        label.attributedText  = [[NSAttributedString alloc]initWithString:text attributes:attrs];
    }
    [view addSubview:label];
    view.label = label;
    
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSAttributedString *attributedText =  self.label.attributedText;
    CGFloat labelWidth = [attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil].size.width;
    if (labelWidth > self.frame.size.width) {
        labelWidth = self.frame.size.width;
    }
    CGFloat labelHeight = [attributedText boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil].size.height + 30;
    
    self.label.frame = CGRectMake((self.frame.size.width - labelWidth) / 2, (self.frame.size.height - labelHeight) / 2, labelWidth, labelHeight);
    
    CGFloat backVWidth = labelWidth + 40;
    self.backV.frame = CGRectMake((self.frame.size.width - backVWidth) / 2, (self.frame.size.height - labelHeight) / 2, backVWidth, labelHeight);
    
}

@end
