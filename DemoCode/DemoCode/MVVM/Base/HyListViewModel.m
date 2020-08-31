//
//  HyListViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/21.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyListViewModel.h"
#import "HyViewController.h"
#import "HyModelProtocol.h"
#import <objc/runtime.h>
#import "NSObject+HyProtocol.h"
#import "HyNetworkManager.h"

@interface HyBlockObject : NSObject<HyBlockProtocol>
@property (nonatomic,copy) id bk;
@property (nonatomic,copy) void(^releaseB)(void);
@end


@interface HyListViewModel ()
@property (nonatomic, strong) id<HyListModelProtocol> model;
@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(id _Nonnull, HyListActionType)> *listActionBlockDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull, id _Nonnull, HyListActionType, BOOL)> *> *listSuccessHandlerDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull, NSError *, HyListActionType)> *> *listFailureHandlerDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull)> *> *refreshListViewBlockDict;
#pragma mark - RAC
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACCommand *> *listCommandDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACSubject *> *refreshListViewSignalDict;
@end


@implementation HyListViewModel
@dynamic model;

- (void)viewModelLoad {
    [super viewModelLoad];

    if (self.model) {
        __weak typeof(self) _self = self;
        self.model.listActionSuccess = ^typeof(void (^)(id _Nonnull, id _Nonnull, HyListActionType, BOOL)) (NSString *key){
            return ^(id _Nonnull input, id _Nonnull data, HyListActionType type, BOOL noMore){
                __strong typeof(_self) self = _self;
                NSArray<void (^)(id, id, HyListActionType, BOOL)> *array = [self.listSuccessHandlerDict objectForKey:key];
                if (array.count) {
                    for (void (^block)(id, id, HyListActionType, BOOL) in array) {
                        block(input, data, type, noMore);
                    }
                }
            };
        };
        
        self.model.listActionFailure = ^typeof(void (^)(id _Nonnull, NSError * _Nonnull, HyListActionType)) (NSString *key){
            return ^(id _Nonnull input, NSError * _Nonnull error, HyListActionType type){
                __strong typeof(_self) self = _self;
                NSArray<void (^)(id, NSError *, HyListActionType)> *array = [self.listFailureHandlerDict objectForKey:key];
                if (array.count) {
                    for (void (^block)(id, NSError *, HyListActionType) in array) {
                        block(input, error, type);
                    }
                }
            };
        };
    }
}

- (id<HyListEntityProtocol>  _Nonnull (^)(NSString * _Nonnull))listEntity {
    @weakify(self);
    return ^(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self.model.listEntity(key);
    };
}

- (Class)defaultModelClass {
    return HyListModel.class;
}

- (typeof(void (^)(id _Nonnull, HyListActionType))  _Nonnull (^)(NSString * _Nonnull))listAction {
    __weak typeof(self) _self = self;
    return ^typeof(void (^)(id _Nonnull, HyListActionType)) (NSString *key) {
        __strong typeof(_self) self = _self;
        if (!key.length) {key = NSStringFromClass(self.class);}
         return self._objectForKey(self.listActionBlockDict, key, ^id {
             return ^(id input, HyListActionType type){
                 __strong typeof(_self) self = _self;
                 [self listActionWithInput:[self handleListInput:input type:type forKey:key] type:type forKey:key];
             };
         });
    };
}

- (nullable id)handleListInput:(id)input type:(HyListActionType)type forKey:(NSString *)key{
    return input;
}

- (void)listActionWithInput:(id)input type:(HyListActionType)type  forKey:(NSString *)key  {
    self.model.listAction(input, type, key);
}

- (id<HyBlockProtocol>)addListActionSuccessHandler:(void (^)(id _Nonnull, id _Nonnull, HyListActionType, BOOL))successHandler
                                            forKey:(NSString *)key {
    if (!successHandler) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}
    
    NSMutableArray<void (^)(id, id, HyListActionType, BOOL)> *array = [self.listSuccessHandlerDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
        [self.listSuccessHandlerDict setObject:array forKey:key];
    }
    [array addObject:successHandler];
    
    HyBlockObject *object = [HyBlockObject block:successHandler];
    object.releaseB = ^{
        [array removeObject:successHandler];
    };
    return object;
}

- (id<HyBlockProtocol>)addListActionFailureHandler:(void (^)(id _Nonnull, NSError * _Nonnull, HyListActionType))failureHandler
                                            forKey:(NSString *)key {
    
    if (!failureHandler) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}
    
    NSMutableArray<void (^)(id, NSError *, HyListActionType)> *array = [self.listFailureHandlerDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
        [self.listFailureHandlerDict setObject:array forKey:key];
    }
    [array addObject:failureHandler];
    
    HyBlockObject *object = [HyBlockObject block:failureHandler];
    object.releaseB = ^{
        [array removeObject:failureHandler];
    };
    return object;
}

- (NSArray<id<HyBlockProtocol>> *)addListActionSuccessHandler:(void (^)(id _Nullable, id _Nullable, HyListActionType, BOOL))successHandler
                                               failureHandler:(void (^)(id _Nullable, NSError * _Nonnull, HyListActionType))failureHandler
                                                       forKey:(NSString *)key {
    
    id<HyBlockProtocol> successB = [self addListActionSuccessHandler:successHandler forKey:key];
    id<HyBlockProtocol> failureB = [self addListActionFailureHandler:failureHandler forKey:key];
    NSMutableArray *array = @[].mutableCopy;
    if (successB) {
        [array addObject:successB];
    }
    if (failureB) {
        [array addObject:failureB];
    }
    return array;
}

- (NSArray<typeof(void (^)(id _Nonnull))> * _Nonnull (^)(NSString * _Nonnull))refreshListViewBlock {
    __weak typeof(self) _self = self;
    return ^(NSString *key) {
        __strong typeof(_self) self = _self;
        if (!key.length) {key = NSStringFromClass(self.class);}
        return [self.refreshListViewBlockDict objectForKey:key].copy;
    };
}

- (id<HyBlockProtocol>)addRefreshListViewBlock:(void (^)(id _Nonnull))block forKey:(NSString *)key {
    
    if (!block) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id _Nonnull)> *array = [self.refreshListViewBlockDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
    }
    [array addObject:block];
    [self.refreshListViewBlockDict setObject:array forKey:key];

    HyBlockObject *object = [HyBlockObject block:block];
    object.releaseB = ^{
        [array removeObject:block];
    };
    return object;
}

- (void)refreshListViewWithParameter:(id)parameter forKey:(NSString *)key {

    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id _Nonnull)> *array = [self.refreshListViewBlockDict objectForKey:key];
    if (!array.count) {
        return;
    }
    for (void (^block)(id _Nonnull) in array) {
        block(parameter);
    }
}

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

#pragma mark - RAC
- (RACCommand<RACTuple *,RACTuple *> * _Nonnull (^)(NSString * _Nonnull))listCommand {
    @weakify(self);
    return ^RACCommand *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.listCommandDict, key, ^id{
            @strongify(self);
            return [self listCommandForKey:key];
        });
    };
}

- (RACSubject * _Nonnull (^)(NSString * _Nonnull))refreshListViewSignal {
    @weakify(self);
    return ^RACSubject *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.refreshListViewSignalDict, key, ^{
            return [RACSubject subject];
        });
    };
}

- (RACCommand *)listCommandForKey:(NSString *)key {
    return hy_command(self.listCommandEnabledSignal(key),
                      self.listCommandInputHandler(key),
                      self.listCommandSignal(key));
}

- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))listCommandEnabledSignal {
    return ^RACSignal<NSNumber *> *(NSString *key){
        return [self listCommandEnabledSignalForKey:key];
    };
}

- (typeof(void(^)(id _Nonnull)) (^)(NSString * _Nonnull))listCommandInputHandler {
    @weakify(self);
    return ^(NSString *key){
        @strongify(self);
        if (!key.length) { key = NSStringFromClass(self.class);}
        return ^(id input) {
            if ([input isKindOfClass:RACTuple.class]) {
                RACTuple *tuple = input;
                if (tuple.count == 2) {
                    @strongify(self);
                    id inputValue = tuple.first;
                    HyListActionType type = [tuple.last integerValue];
                    [self listCommandInputHandlerWithInput:[self handleListInput:inputValue type:type forKey:key] type:type forkey:key];
                }
            }
        };
    };
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))listCommandSignal {
    @weakify(self);
    return ^(NSString *key) {
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return ^RACSignal *(id input){
            if ([input isKindOfClass:RACTuple.class]) {
                RACTuple *tuple = input;
                if (tuple.count == 2) {
                    @strongify(self);
                    id inputValue = tuple.first;
                    HyListActionType type = [tuple.last integerValue];
                   return [self listCommandSignalWithInput:[self handleListInput:inputValue type:type forKey:key] type:type forKey:key];
                }
            }
            NSLog(@"input需要传RACTuple ->(input, HyListActionType)");
            return [RACSignal return:nil];
        };
    };
}

- (RACSignal *)listCommandEnabledSignalForKey:(NSString *)key {
    if (!key.length) {key = NSStringFromClass(self.class);}
    return self.model.listEnabledSignal(key) ?: [RACSignal return:@YES];
}

- (RACSignal *)listCommandSignalWithInput:(id)input type:(HyListActionType)type forKey:(NSString *)key {
    if (!key.length) {key = NSStringFromClass(self.class);}
    return self.model.listSignal(type,key)(input) ?: [RACSignal empty];
}

- (void)listCommandInputHandlerWithInput:(id)input type:(HyListActionType)type forkey:(NSString *)key {}


- (id<HyListEntityProtocol>)listViewDataProviderForKey:(NSString *)key {
    if (!key.length) {key = NSStringFromClass(self.class);}
    return self.model.listEntity(key);
}

- (NSMutableDictionary<NSString *,void (^)(id _Nonnull, HyListActionType)> *)listActionBlockDict {
    if (!_listActionBlockDict) {
        _listActionBlockDict = @{}.mutableCopy;
    }
    return _listActionBlockDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull, id _Nonnull, HyListActionType, BOOL)> *> *)listSuccessHandlerDict {
    if (!_listSuccessHandlerDict) {
        _listSuccessHandlerDict = @{}.mutableCopy;
    }
    return _listSuccessHandlerDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull, NSError *, HyListActionType)> *> *)listFailureHandlerDict {
    if (!_listFailureHandlerDict) {
        _listFailureHandlerDict = @{}.mutableCopy;
    }
    return _listFailureHandlerDict;
}

- (NSMutableDictionary<NSString *,RACCommand *> *)listCommandDict {
    if (!_listCommandDict) {
        _listCommandDict = @{}.mutableCopy;
    }
    return _listCommandDict;
}

- (NSMutableDictionary<NSString *,RACSubject *> *)refreshListViewSignalDict {
    if (!_refreshListViewSignalDict) {
        _refreshListViewSignalDict = @{}.mutableCopy;
    }
    return _refreshListViewSignalDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull)> *> *)refreshListViewBlockDict {
    if (!_refreshListViewBlockDict) {
        _refreshListViewBlockDict = @{}.mutableCopy;
    }
    return _refreshListViewBlockDict;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
