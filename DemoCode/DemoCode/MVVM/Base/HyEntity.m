//
//  HyEntity.m
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyEntity.h"
#import "HyModelParser.h"

@interface HyEntity ()
@property (nonatomic,strong) NSDictionary *parameter;
@end

@implementation HyEntity

+ (instancetype)entityWithParameter:(NSDictionary *)parameter {
    HyEntity *model = [[self alloc] init];
    model.parameter = parameter;
    [model hy_modelSetWithJSON:parameter];
    [model entityLoad];
    return model;
}

- (void)entityLoad {}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
