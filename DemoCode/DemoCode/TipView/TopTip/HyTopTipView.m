//
//  HyTopTipView.m
//  DemoCode
//
//  Created by huangyi on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTopTipView.h"


@implementation HyTopTipView

+ (instancetype)topTipViewWithFrame:(CGRect)frame text:(NSString *)text {
    
    HyTopTipView *view = [[self alloc] initWithFrame:frame];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = UIColor.orangeColor;
    label.textColor = UIColor.whiteColor;
    label.alpha = .8;
    label.text = text;
    label.frame = CGRectMake(0, view.bounds.size.height - 44, view.bounds.size.width, 44);
    [view addSubview:label];
    
    return view;
}

@end
