//
//  HyViewModel_RAC.m
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyViewModel_RAC.h"
#import "HyModel_RAC.h"
#import "HyModelParser.h"
#import <HyCategoriess/HyCategories.h>
#import "NSObject+HyProtocol.h"
#import "HyModelRACProtocol.h"
#import "HyViewControllerRACProtocol.h"


@interface HyViewModel_RAC()
@property (nonatomic,strong) id<HyModelRACProtocol> model;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACCommand *> *requestDataCommandDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACSubject *> *refreshViewSignalDict;
@end


@implementation HyViewModel_RAC
@dynamic model;
- (RACCommand * _Nonnull (^)(NSString * _Nonnull))requestDataCommand {
    @weakify(self);
    return ^RACCommand *(NSString *type){
        if (type.length) {
            @strongify(self);
            return
            self._objectForKey(self.requestDataCommandDict, type, ^{
                @strongify(self);
                return hy_command(self.modelEnabledSignal(type),
                                  self.commandInputHandler(type),
                                  self.modelSignal(type));
            });
        }
        return nil;
    };
}

- (RACSubject * _Nonnull (^)(NSString * _Nonnull))refreshViewSignal {
    @weakify(self);
    return ^RACSubject *(NSString *type){
        if (type.length) {
            @strongify(self);
            self._objectForKey(self.refreshViewSignalDict, type, ^{
                return [RACSubject subject];
            });
        }
        return nil;
    };
}

- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))modelEnabledSignal {
    return self.model.requestDataEnabledSignal;
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))modelSignal {
    return self.model.requestDataSignal;
}

- (typeof(void(^)(id _Nonnull)) (^)(NSString * _Nonnull))commandInputHandler {
    @weakify(self);
    return ^(NSString *type){
        return ^(id input) {
            @strongify(self);
            [self commandInputHandlerWithInput:input type:type];
        };
    };
}

- (void)commandInputHandlerWithInput:(id)input type:(NSString *)type {}

- (id (^)(NSMutableDictionary *, NSString *, id(^)(void)))_objectForKey {
    return ^(NSMutableDictionary *dict, NSString *key, id(^block)(void)){
        return [dict objectForKey:key] ?: ({
            id object = !block ? nil : block();
            if (object) {
                [dict setObject:object forKey:key];
            }
            object;
        });
    };
}

- (NSMutableDictionary<NSString *,RACCommand *> *)requestDataCommandDict {
    if (!_requestDataCommandDict) {
        _requestDataCommandDict = @{}.mutableCopy;
    }
    return _requestDataCommandDict;
}

- (NSMutableDictionary<NSString *,RACSubject *> *)refreshViewSignalDict {
    if (!_refreshViewSignalDict) {
        _refreshViewSignalDict = @{}.mutableCopy;
    }
    return _refreshViewSignalDict;
}

@end
