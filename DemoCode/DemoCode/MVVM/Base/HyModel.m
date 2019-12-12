//
//  HyModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyModel.h"
#import <MJExtension/MJExtension.h>

@implementation HyModel
@synthesize parameter = _parameter;

+ (NSObject<HyModelProtocol> *)modelWithParameter:(NSDictionary *)parameter {
    
    NSObject<HyModelProtocol> *model = [[self alloc] init];
    model.parameter = parameter;
    model = [model mj_setKeyValues:parameter];
    [model modelLoad];
    return model;
}

- (void)modelLoad {}

@end
