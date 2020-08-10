//
//  HyNewsModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsModel.h"
#import "HyNewsCellEntity.h"

@implementation HyNewsModel

- (void)configListReuestConfigure:(ListRequestConfigure *)configure {
    
    NSInteger pageIndex = self.getPageIndex(configure.type, configure.key);
    NSInteger pageSize = self.getPageSize(configure.key);
    configure.url = [NSString stringWithFormat:@"http://i.play.163.com/user/article/list/%ld/%ld", pageIndex * pageSize, (long)pageSize];
    configure.cellDataHandler = ^NSArray * _Nonnull(id  _Nullable input, NSDictionary * _Nonnull sectionData, NSUInteger section, HyListActionType type) {
        return @[sectionData[@"info"], HyNewsCellEntity.class];
    };
}

@end
