//
//  HyModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyModel.h"
#import "HyModelParser.h"

@implementation HyModel
@synthesize parameter = _parameter;

+ (id<HyModelProtocol>)modelWithParameter:(NSDictionary *)parameter {
    
    id<HyModelProtocol> model = [[self alloc] init];
    model.parameter = parameter;
    [((NSObject<HyModelProtocol> *)model) hy_modelSetWithJSON:parameter];
    [model modelLoad];
    return model;
}

- (void)modelLoad {}

@end
