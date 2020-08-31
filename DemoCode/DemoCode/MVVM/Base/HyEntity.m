//
//  HyEntity.m
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyEntity.h"
#import "HyModelParser.h"
#import <YYModel/YYModel.h>

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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}
- (NSUInteger)hash {
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
- (NSString *)description {
    return [self yy_modelDescription];
}
@end
