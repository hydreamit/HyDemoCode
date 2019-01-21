//
//  HYNewsViewModel.m
//  demo
//
//  Created by huangyi on 2018/11/10.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "HYNewsViewModel.h"

@implementation HYNewsViewModel

- (void)handleViewModel {
    [super handleViewModel];
    self.pageNumber = 0;
}

- (requestUrlBlock)configtUrl {
    return ^NSString *(id input){
        NSString *url = @"http://i.play.163.com/user/article/list";
        NSString *string =
        [NSString stringWithFormat:@"%@/%d/%zd", url, [self getLoadDataPageNumber] * self.pageSize, self.pageSize];
        return string;
    };
}

- (tableViewDataAnalyzeBlock)configDataParams {
    return ^ NSDictionary * (id response){
        if ([response isKindOfClass:[NSDictionary class]]) {
            return @{
                     CellModelClassKey : [HYNewsCellModel class],
                     CellModelDataKey : response[@"info"]
                     };
        } else {
            return nil;
        }
    };
}

@end
