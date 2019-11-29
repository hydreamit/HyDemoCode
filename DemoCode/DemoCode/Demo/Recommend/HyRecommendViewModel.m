//
//  HyRecommendViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRecommendViewModel.h"

@implementation HyRecommendViewModel

- (void)viewModelLoad {
    [super viewModelLoad];
    
    [self configRequestIsGet:YES url:^NSString * _Nonnull(id  _Nullable input, HyListViewRequestDataType type) {
        return @"http://i.play.163.com/news/topicOrderSource/list";
    } parameter:nil sectionDataHandler:nil cellDataHandler:^NSArray<id> * _Nonnull(id  _Nullable input, NSDictionary * _Nonnull sectionData, NSUInteger section, HyListViewRequestDataType type) {
        return @[sectionData[@"info"]];
    }];
}

@end
