//
//  HYRecommendViewModel.m
//  demo
//
//  Created by huangyi on 2018/11/12.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYRecommendViewModel.h"

@implementation HYRecommendViewModel
- (void)handleViewModel {
    [super handleViewModel];
 
    self.isGetRequest = YES;
}

- (requestUrlBlock)configtUrl {
    return ^NSString *(id input){
        return @"http://i.play.163.com/news/topicOrderSource/list";
    };
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary * (id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            return @{
                     CellModelClassKey : [HYRecommendCellModel class],
                     CellModelDataKey : response[@"info"]
                     };
        } else {
            return nil;
        }
    };
}

@end
