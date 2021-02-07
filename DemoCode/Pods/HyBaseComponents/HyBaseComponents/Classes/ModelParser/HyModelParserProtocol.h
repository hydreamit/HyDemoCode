//
//  HyModelParserProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/1/7.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyModelParserProtocol <NSObject>

+ (nullable instancetype)hy_modelWithJSON:(id)json;
+ (NSArray *)hy_modelArrayWithJSON:(id)json;
- (void)hy_modelSetWithJSON:(id)json;

- (nullable id)hy_modelToJSONObject;
- (nullable NSData *)hy_modelToJSONData;
- (nullable NSString *)hy_modelToJSONString;


+ (nullable NSArray<NSString *> *)hy_modelPropertyBlacklist;
+ (nullable NSArray<NSString *> *)hy_modelPropertyWhitelist;
+ (nullable NSDictionary<NSString *, id> *)hy_modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)hy_modelContainerPropertyGenericClass;
- (void)hy_modelDidParsedWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
