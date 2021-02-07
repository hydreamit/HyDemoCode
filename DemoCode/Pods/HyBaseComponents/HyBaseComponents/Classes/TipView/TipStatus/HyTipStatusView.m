//
//  HyTipStatusView.m
//  DemoCode
//
//  Created by Hy on 2017/12/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipStatusView.h"


@implementation HyTipStatusView

+ (instancetype)tipStatusViewWithFrame:(CGRect)frame text:(NSString *)text {
    
    HyTipStatusView *view = [[self alloc] initWithFrame:frame];
    
    UIView *backV = UIView.new;
    backV.backgroundColor = UIColor.orangeColor;
    backV.frame = CGRectMake(0, -30, frame.size.width, frame.size.height + 30);
    [view addSubview:backV];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;
    label.text = text;
    label.frame = CGRectMake(0, view.bounds.size.height - 44, view.bounds.size.width, 44);
    [view addSubview:label];
    
    return view;
}

@end
