//
//  NSObject+HyModelParser.m
//  DemoCode
//
//  Created by Hy on 2017/1/8.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "NSObject+HyModelParser.h"
#ifdef _YYMODEL
    #import <YYModel/YYModel.h>
#else
    #import <MJExtension/MJExtension.h>
#endif


@implementation NSObject (HyModelParser)

+ (nullable instancetype)hy_modelWithJSON:(id)json {
#ifdef _YYMODEL
    return [self yy_modelWithJSON:json];
#else
    return [self mj_objectWithKeyValues:json];
#endif
}

- (void)hy_modelSetWithJSON:(id)json {
#ifdef _YYMODEL
    [self yy_modelSetWithJSON:json];
#else
    [self mj_setKeyValues:json];
#endif
}

+ (NSArray *)hy_modelArrayWithJSON:(id)json {
#ifdef _YYMODEL
    return [NSArray yy_modelArrayWithClass:[self class] json:json];
#else
    return [self mj_objectArrayWithKeyValuesArray:json].copy;
#endif
}

- (nullable id)hy_modelToJSONObject {
#ifdef _YYMODEL
    return [self yy_modelToJSONObject];
#else
    return [self mj_JSONObject];
#endif
}

- (nullable NSData *)hy_modelToJSONData {
#ifdef _YYMODEL
    return [self yy_modelToJSONData];
#else
    return [self mj_JSONData];
#endif
}

- (nullable NSString *)hy_modelToJSONString {
#ifdef _YYMODEL
    return [self yy_modelToJSONString];
#else
    return [self mj_JSONString];
#endif
}


#ifdef _YYMODEL
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist {
    return [self hy_modelPropertyWhitelist];
}
+ (NSArray<NSString *> *)modelPropertyBlacklist {
    return [self hy_modelPropertyBlacklist];
}
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return [self hy_modelCustomPropertyMapper];
}
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return [self hy_modelContainerPropertyGenericClass];
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [self hy_modelDidParsedWithDictionary:dic];
    return YES;
}
#else
+ (NSArray *)mj_allowedPropertyNames {
    return [self hy_modelPropertyWhitelist];
}
+ (NSArray *)mj_ignoredPropertyNames {
    return [self hy_modelPropertyBlacklist];
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return [self hy_modelCustomPropertyMapper];
}
+ (NSDictionary *)mj_objectClassInArray {
    return [self hy_modelContainerPropertyGenericClass];
}
- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    [self hy_modelDidParsedWithDictionary:keyValues];
}
#endif


+ (nullable NSArray<NSString *> *)hy_modelPropertyBlacklist {return nil;}
+ (nullable NSArray<NSString *> *)hy_modelPropertyWhitelist {return nil;}
+ (nullable NSDictionary<NSString *, id> *)hy_modelCustomPropertyMapper {return nil;}
+ (nullable NSDictionary<NSString *, id> *)hy_modelContainerPropertyGenericClass {return nil;}
- (void)hy_modelDidParsedWithDictionary:(NSDictionary *)dictionary {}


@end
