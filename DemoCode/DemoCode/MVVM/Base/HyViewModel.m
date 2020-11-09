//
//  HyViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewModel.h"
#import "HyModelParser.h"
#import "NSObject+HyProtocol.h"
#import "HyNetworkManager.h"
#import "NSObject+HyProtocol.h"
#import <HyCategoriess/HyCategories.h>
#import "HyModel.h"


@interface HyBlockObject : NSObject<HyBlockProtocol>
@property (nonatomic,copy) id bk;
@property (nonatomic,copy) void(^releaseB)(void);
@end
@implementation HyBlockObject
+ (instancetype)block:(id)block {
    HyBlockObject *object = [[self alloc] init];
    object.bk = block;
    return object;
}
- (void)releaseBlock {
    self.bk = nil;
    !self.releaseB ?: self.releaseB();
    self.releaseB = nil;
}
- (void)dealloc {
    self.bk = nil;
    self.releaseB = nil;
}
@end

#define HandlerKey if (!key.length) {key = NSStringFromClass(self.class);}

@interface HyViewModel ()
@property (nonatomic,strong) HyModel *model;
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,weak) UIViewController<HyViewControllerProtocol> *viewModelController;

@property (nonatomic, strong) NSMutableDictionary<NSString *, void (^)(id _Nonnull)> *actionBlockDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull, id _Nonnull)> *> *successHandlerDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull, NSError *)> *> *failureHandlerDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<void (^)(id _Nonnull)> *> *refreshViewBlockDict;

#pragma mark - RAC
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACCommand *> *commandDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *, RACSubject *> *refreshViewSignalDict;
@end


@implementation HyViewModel

#pragma mark - base
+ (instancetype)viewModelWithParameter:(NSDictionary *)parameter {
    HyViewModel *viewModel = [[self alloc] init];
    viewModel.parameter = parameter;
    [viewModel hy_modelSetWithJSON:parameter];
    return viewModel;
}

- (void)viewModelLoad {
    
    if (self.model) {
        __weak typeof(self) _self = self;
        self.model.actionSuccess  = ^typeof(void (^)(id _Nonnull, id _Nonnull)) (NSString *key){
            return ^(id input, id data){
                __strong typeof(_self) self = _self;
                NSArray<void (^)(id, id)> *array = [self.successHandlerDict objectForKey:key];
                if (array.count) {
                    for (void (^block)(id, id) in array) {
                        block(input, data);
                    }
                }
            };
        };
        
        self.model.actionFailure = ^typeof(void (^)(id _Nonnull, NSError * _Nonnull)) (NSString *key){
            return ^(id input, NSError *error){
                __strong typeof(_self) self = _self;
                NSArray<void (^)(id, NSError *)> *array = [self.failureHandlerDict objectForKey:key];
                if (array.count) {
                    for (void (^block)(id, NSError *) in array) {
                        block(input, error);
                    }
                }
            };
        };
    }
}

- (void)setModelWithParameter:(nullable NSDictionary *)parameter {
    [self.model setModelWithParameter:parameter];
}

- (id<HyModelProtocol>)model {
    if (!_model) {
        Class<HyModelProtocol> cls = getObjcectPropertyClass([self class], "model");
        if (cls == NULL) {
            cls = self.defaultModelClass;
        }
        if (Hy_ProtocolAndSelector(cls, @protocol(HyModelProtocol), @selector(modelWithParameter:))) {
            _model = (id)[cls modelWithParameter:self.parameter];
        }
    }
    return _model;
}

- (Class)defaultModelClass {
    return HyModel.class;
}

- (void)setViewModelController:(UIViewController<HyViewControllerProtocol> *)viewModelController {
    objc_setAssociatedObject(self,
                             @selector(viewModelController),
                             [NSValue valueWithNonretainedObject:viewModelController],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController<HyViewControllerProtocol> *)viewModelController {
    return ((NSValue *)(objc_getAssociatedObject(self, _cmd))).nonretainedObjectValue;
}

- (UINavigationController *)viewModelNavigationController {
    return self.viewModelController.navigationController;
}

#pragma mark - action
- (typeof(void (^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))action {
    __weak typeof(self) _self = self;
    return ^typeof(void (^)(id _Nonnull)) (NSString *key) {
        __strong typeof(_self) self = _self;
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.actionBlockDict, key, ^id {
            return ^(id input){
                __strong typeof(_self) self = _self;
                [self actionWithInput:[self handleInput:input forKey:key] forKey:key];
            };
        });
    };
}

- (void)actionWithInput:(id)input forKey:(NSString *)key {
    [self.model actionWithInput:input forKey:key];
}

- (nullable id)handleInput:(id)input forKey:(NSString *)key {
    return input;
}

- (id<HyBlockProtocol>)addActionSuccessHandler:(void (^)(id _Nonnull, id _Nonnull))successHandler
                                        forKey:(NSString *)key {
    
    if (!successHandler) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id, id)> *array = [self.successHandlerDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
        [self.successHandlerDict setObject:array forKey:key];
    }
    [array addObject:successHandler];

    HyBlockObject *object = [HyBlockObject block:successHandler];
    object.releaseB = ^{
        [array removeObject:successHandler];
    };
    return object;
}

- (id<HyBlockProtocol>)addActionFailureHandler:(void (^)(id _Nonnull, NSError * _Nonnull))failureHandler
                                        forKey:(NSString *)key {
    
    if (!failureHandler) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id, NSError *)> *array = [self.failureHandlerDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
        [self.failureHandlerDict setObject:array forKey:key];
    }
    [array addObject:failureHandler];

    HyBlockObject *object = [HyBlockObject block:failureHandler];
    object.releaseB = ^{
        [array removeObject:failureHandler];
    };
    return object;
}

- (NSArray<id<HyBlockProtocol>> *)addActionSuccessHandler:(void (^)(id _Nullable, id _Nullable))successHandler
                                           failureHandler:(void (^)(id _Nullable, NSError * _Nonnull))failureHandler
                                                   forKey:(NSString *)key {

    id<HyBlockProtocol> successB = [self addActionSuccessHandler:successHandler forKey:key];
    id<HyBlockProtocol> failureB = [self addActionFailureHandler:failureHandler forKey:key];
    NSMutableArray *array = @[].mutableCopy;
    if (successB) {
        [array addObject:successB];
    }
    if (failureB) {
        [array addObject:failureB];
    }
    return array;
}

- (NSArray<typeof(void (^)(id _Nonnull))> * _Nonnull (^)(NSString * _Nonnull))refreshViewBlock {
    __weak typeof(self) _self = self;
    return ^(NSString *key) {
        __strong typeof(_self) self = _self;
        if (!key.length) {key = NSStringFromClass(self.class);}
        return [self.refreshViewBlockDict objectForKey:key].copy;
    };
}

- (id<HyBlockProtocol>)addRefreshViewBlock:(void (^)(id _Nonnull))block forKey:(NSString *)key {
    
    if (!block) { return nil;}
    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id _Nonnull)> *array = [self.refreshViewBlockDict objectForKey:key];
    if (!array) {
        array = @[].mutableCopy;
    }
    [array addObject:block];
    [self.refreshViewBlockDict setObject:array forKey:key];

    HyBlockObject *object = [HyBlockObject block:block];
    object.releaseB = ^{
        [array removeObject:block];
    };
    return object;
}

- (void)refreshViewWithParameter:(id)parameter forKey:(NSString *)key {

    if (!key.length) {key = NSStringFromClass(self.class);}

    NSMutableArray<void (^)(id _Nonnull)> *array = [self.refreshViewBlockDict objectForKey:key];
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

- (NSMutableDictionary<NSString *,void (^)(id _Nonnull)> *)actionBlockDict {
    if (!_actionBlockDict) {
        _actionBlockDict = @{}.mutableCopy;
    }
    return _actionBlockDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull)> *> *)refreshViewBlockDict {
    if (!_refreshViewBlockDict) {
        _refreshViewBlockDict = @{}.mutableCopy;
    }
    return _refreshViewBlockDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull, id _Nonnull)> *> *)successHandlerDict {
    if (!_successHandlerDict) {
        _successHandlerDict = @{}.mutableCopy;
    }
    return _successHandlerDict;
}

- (NSMutableDictionary<NSString *,NSMutableArray<void (^)(id _Nonnull, NSError *)> *> *)failureHandlerDict {
    if (!_failureHandlerDict) {
        _failureHandlerDict = @{}.mutableCopy;
    }
    return _failureHandlerDict;
}

#pragma mark - command - signal
- (RACCommand * _Nonnull (^)(NSString * _Nonnull))command {
    @weakify(self);
    return ^RACCommand *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.commandDict, key, ^id{
            @strongify(self);
            return [self commandForKey:key];
        });
    };
}

- (RACCommand *)commandForKey:(NSString *)key {
    return hy_command(self.commandEnabledSignal(key),
                      self.commandInputHandler(key),
                      self.commandSignal(key));
}

- (RACSubject * _Nonnull (^)(NSString * _Nonnull))refreshViewSignal {
    @weakify(self);
    return ^RACSubject *(NSString *key){
        @strongify(self);
        if (!key.length) {key = NSStringFromClass(self.class);}
        return self._objectForKey(self.refreshViewSignalDict, key, ^{
            return [RACSubject subject];
        });
    };
}

- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))commandEnabledSignal {
    @weakify(self);
    return ^RACSignal<NSNumber *> *(NSString *key){
        @strongify(self);
        return [self commandEnabledSignalForKey:key];
    };
}

- (typeof(void(^)(id _Nonnull)) (^)(NSString * _Nonnull))commandInputHandler {
    @weakify(self);
    return ^(NSString *key){
        return ^(id input) {
            @strongify(self);
            [self commandInputHandlerWithInput:[self handleInput:input forKey:key]  forkey:key];
        };
    };
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))commandSignal {
    @weakify(self);
    return ^(NSString *key) {
        return ^RACSignal *(id input){
            @strongify(self);
            return [self commandSignalWithInput:[self handleInput:input forKey:key]  forKey:key];
        };
    };
}

- (RACSignal *)commandEnabledSignalForKey:(NSString *)key {
    if (!key.length) {key = NSStringFromClass(self.class);}
    return self.model.enabledSignal(key) ?: hy_signalWithValue(@YES);
}

- (RACSignal *)commandSignalWithInput:(id)input forKey:(NSString *)key {
    if (!key.length) {key = NSStringFromClass(self.class);}
    return self.model.signal(key)(input) ?:  [RACSignal empty];
}

- (void)commandInputHandlerWithInput:(id)input forkey:(NSString *)key {}

- (NSMutableDictionary<NSString *,RACCommand *> *)commandDict {
    if (!_commandDict) {
        _commandDict = @{}.mutableCopy;
    }
    return _commandDict;
}

- (NSMutableDictionary<NSString *,RACSubject *> *)refreshViewSignalDict {
    if (!_refreshViewSignalDict) {
        _refreshViewSignalDict = @{}.mutableCopy;
    }
    return _refreshViewSignalDict;
}

#pragma mark - HyViewInvokerProtocol
- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString {
    return (id)self;
}

- (id<HyViewEventProtocol>)viewEventHandlerForClassString:(NSString *)classString {
    return (id)self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
