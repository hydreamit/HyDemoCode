//
//  HyRecommendModel.m
//  DemoCode
//
//  Created by huangyi on 2017/8/9.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyRecommendModel.h"

@implementation HyRecommendModel

- (void)configListReuestConfigure:(ListRequestConfigure *)configure {
    configure.url = @"http://i.play.163.com/news/topicOrderSource/list";
    configure.cellDataHandler = ^NSArray * _Nonnull(id  _Nullable input, NSDictionary * _Nonnull sectionData, NSUInteger section, HyListActionType type) {
            return @[sectionData[@"info"]];
    };
}

@end
