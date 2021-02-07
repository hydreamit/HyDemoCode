//
//  HyListEntity.m
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyListEntity.h"

@implementation HyListEntity
@synthesize entityArray = _entityArray;

- (id<HyListEntityProtocol>  _Nonnull (^)(NSUInteger))sectionEntity {
    __weak typeof(self) _self = self;
    return ^id<HyListEntityProtocol> (NSUInteger section){
        __strong typeof(_self) self = _self;
        if (section >= self.entityArray.count) {return nil;}
        return self.entityArray[section];
    };
}

- (id<HyEntityProtocol>  _Nonnull (^)(NSIndexPath * _Nonnull))cellEntity {
    __weak typeof(self) _self = self;
    return ^id<HyEntityProtocol> (NSIndexPath *indexPath) {
        __strong typeof(_self) self = _self;
        if (!indexPath) { return nil;}
        id<HyListEntityProtocol> sectionEntity = self.sectionEntity(indexPath.section);
        if (sectionEntity && indexPath.row < sectionEntity.entityArray.count) {
            return sectionEntity.entityArray[indexPath.row];
        }
        return nil;
    };
}

- (NSMutableArray<id<HyListEntityProtocol>> *)entityArray {
    if (!_entityArray) {
        _entityArray = @[].mutableCopy;
    }
    return _entityArray;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
