//
//  HyBaseModel.m
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyBaseModel.h"
#import "HyModelParser.h"

@interface HyBaseModel ()
@property (nonatomic,strong) NSDictionary *parameter;
@end

@implementation HyBaseModel

+ (instancetype)modelWithParameter:(NSDictionary *)parameter {
    
    HyBaseModel *model = [[self alloc] init];
    model.parameter = parameter;
    [model hy_modelSetWithJSON:parameter];
    [model modelLoad];
    return model;
}

- (void)modelLoad {}

@end
