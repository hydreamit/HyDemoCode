//
//  HyNewsCellEntity.m
//  DemoCode
//
//  Created by huangyi on 2017/8/9.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsCellEntity.h"

@implementation HyNewsCellEntity

- (void)entityLoad {
    
    [self handleTitleAttr];
    [self handleImageUrlStr];
    [self handleCellHeight];
    [self handleCellClass];
}

- (void)handleTitleAttr {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:2];
    NSDictionary *attrs = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f] ,
                             NSForegroundColorAttributeName: [UIColor blackColor],
                             NSParagraphStyleAttributeName : paragraphStyle };
   
    self.titleAttr  = [[NSAttributedString alloc]initWithString:self.title attributes:attrs];
}

- (void)handleImageUrlStr {
    self.imageUrlStr = [NSString stringWithFormat:@"%@?w=750&h=20000&quality=75", self.imgsrc.firstObject];
}

- (void)handleCellHeight {
    if (self.showType != 2) {
        self.cellHeight = 80;
    } else {
        CGFloat titleHeight = [self.titleAttr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil].size.height;
        self.cellHeight = 100 + titleHeight + 30;
    }
}

- (void)handleCellClass {
    self.cellClass = NSClassFromString(self.showType == 2 ? @"HyNewsImageCell"
                                       : @"HyNewsCell");
}

@end
