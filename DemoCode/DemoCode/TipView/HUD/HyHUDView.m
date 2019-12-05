//
//  HyHUDView.m
//  DemoCode
//
//  Created by huangyi on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyHUDView.h"

@implementation HyHUDView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.color = UIColor.orangeColor;
        CGSize initialSize = view.bounds.size;
        CGFloat scale = frame.size.width / initialSize.width;
        view.transform = CGAffineTransformMakeScale(scale, scale);
        [self addSubview:view];
        view.frame = self.bounds;
        [view startAnimating];
    }
    return self;
}

@end
