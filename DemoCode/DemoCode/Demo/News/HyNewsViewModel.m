//
//  HyNewsViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsViewModel.h"

@implementation HyNewsViewModel

- (void)viewModelLoad {
    [super viewModelLoad];
        
    @weakify(self);
    [self configRequestIsGet:YES url:^NSString * _Nonnull(id  _Nullable input, HyListViewRequestDataType type) {
        @strongify(self);
        return
        [NSString stringWithFormat:@"http://i.play.163.com/user/article/list/%ld/%ld", self.getRequestDataPageNumber(type) * self.getPageSize, (long)self.getPageSize];
    } parameter:nil sectionDataHandler:nil cellDataHandler:^NSArray<id> * _Nonnull(id  _Nullable input, NSDictionary * _Nonnull sectionData, NSUInteger section, HyListViewRequestDataType type) {
        return @[sectionData[@"info"], HyNewsModel.class];
    }];
}

@end
