//
//  HyListModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyListModel.h"
#import <objc/runtime.h>
#import "HyListEntity.h"
#import "NSObject+HyProtocol.h"


@interface ListRequestConfigure ()
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) id input;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) HyListActionType type;
@property (nonatomic,assign) BOOL noMore;
@end
@implementation ListRequestConfigure
@dynamic key,input;
@end


@interface HyListModel()
@property (nonatomic,strong) NSMutableDictionary<NSString *,HyListEntity *> *listEntityDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *,NSMutableDictionary *> *listPageDict;
@end


@implementation HyListModel
@synthesize listActionSuccess = _listActionSuccess, listActionFailure = _listActionFailure;
- (id<HyListEntityProtocol>  _Nonnull (^)(NSString * _Nonnull))listEntity {
    __weak typeof(self) _self = self;
    return ^id<HyListEntityProtocol> (NSString *key) {
        __strong typeof(_self) self = _self;
        return self._objectForKey(self.listEntityDict, key, ^id{
            __strong typeof(_self) self = _self;
            Class<HyListEntityProtocol> cls = [self listEntityClassForKey:key];
            if (cls == NULL) {
                cls = HyListEntity.class;
            }
            if (Hy_ProtocolAndSelector(cls, @protocol(HyListEntityProtocol), @selector(entityWithParameter:))) {
                return (id<HyListEntityProtocol>)[cls entityWithParameter:self.parameter];
            }
            return nil;
        });
    };
}

- (NSMutableDictionary *  _Nonnull (^)(NSString * _Nonnull))listPage {
    __weak typeof(self) _self = self;
    return ^NSMutableDictionary * (NSString *key) {
        __strong typeof(_self) self = _self;
        return self._objectForKey(self.listPageDict, key, ^id{
            return @{@"pageSize" : @([self pageSizeForKey:key]),
                     @"startIndex" : @([self startIndexForKey:key])
            }.mutableCopy;
        });
    };
}

- (NSInteger (^)(NSString * _Nonnull))getPageSize {
    __weak typeof(self) _self = self;
    return ^(NSString *key) {
        __strong typeof(_self) self = _self;
        return [self.listPage(key)[@"pageSize"] integerValue];
    };
}

- (NSInteger (^)(HyListActionType, NSString * _Nonnull))getPageIndex {
    __weak typeof(self) _self = self;
    return ^NSInteger (HyListActionType type, NSString *key){
        __strong typeof(_self) self = _self;
        NSDictionary *dict = self.listPage(key);
        return type == HyListActionTypeMore ?
        [[dict objectForKey:@"pageIndex"] integerValue] :
        [[dict objectForKey:@"startIndex"] integerValue];
    };
}

- (Class<HyListEntityProtocol>)listEntityClassForKey:(NSString *)key {
    return HyListEntity.class;
}

- (NSInteger)pageSizeForKey:(NSString *)key {
    return 20;
}

- (NSInteger)startIndexForKey:(NSString *)key {
    return 1;
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

#pragma mark -
- (void (^)(id _Nonnull, HyListActionType, NSString * _Nonnull))listAction {
    return ^(id input, HyListActionType type, NSString *key){
        [self listActionWithInput:input type:type forKey:key];
    };
}

- (void)listActionWithInput:(NSString *)input type:(HyListActionType)type forKey:(NSString *)key {
    
    ListRequestConfigure *configure = ListRequestConfigure.new;
    configure.key = key;
    configure.input = input;
    configure.type = type;
    if (type == HyListActionTypeFirst) {
        configure.showHUD = YES;
    }
    configure.pageIndex = self.getPageIndex(type, key);
    configure.pageSize = self.getPageSize(key);
    [self configListReuestConfigure:configure];
    
    void (^success)(id<HyNetworkSuccessProtocol>) =
    ^(id<HyNetworkSuccessProtocol>  _Nullable successObject){
        [self handleListSuccess:successObject requestConfigure:configure];
    };

    void (^failure)(id<HyNetworkFailureProtocol>) =
    ^(id<HyNetworkFailureProtocol>  _Nullable failureObject){
        [self handleListFailure:failureObject requestConfigure:configure];
    };
    
    if (configure.isGet) {
        [HyNetworkManager.network getShowHUD:configure.showHUD
                                        cache:configure.cache
                                         url:configure.url
                                   parameter:configure.parameter
                                 successBlock:success
                                failureBlock:failure].resumeAtObjcet(self);
    } else {
        [HyNetworkManager.network postShowHUD:configure.showHUD
                                        cache:configure.cache
                                          url:configure.url
                                    parameter:configure.parameter
                                 successBlock:success
                                 failureBlock:failure].resumeAtObjcet(self);
    }
}

- (void)handleListSuccess:(id<HyNetworkSuccessProtocol>)successObject
         requestConfigure:(ListRequestConfigure *)configure {
    [self handleListSuccess:successObject requestConfigure:configure completion:^(id<HyListEntityProtocol> listEntity) {
        void(^block)(id, id, HyListActionType, BOOL) = self.listActionSuccess ? self.listActionSuccess(configure.key) : nil;
        !block ?: block(configure.input, listEntity, configure.type, configure.noMore);
    }];
}

- (void)handleListFailure:(id<HyNetworkFailureProtocol>)failureObject
         requestConfigure:(ListRequestConfigure *)configure {
    void (^block)(id, NSError *, HyListActionType) = self.listActionFailure ? self.listActionFailure(configure.key) : nil;
    !block ?: block(configure.input, failureObject.error, configure.type);
}

#pragma mark -
- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))listEnabledSignal {
    @weakify(self);
    return ^(NSString *key){
        @strongify(self);
        return [self listEnabledSignalForKey:key];
    };
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(HyListActionType, NSString * _Nonnull))listSignal {
    @weakify(self);
    return ^(HyListActionType type, NSString *key) {
        return ^RACSignal *(id input) {
            @strongify(self);
            return [self listSignalWithInput:input type:type forKey:key];
        };
    };
}

- (RACSignal<NSNumber *> *)listEnabledSignalForKey:(NSString *)key {
    return hy_signalWithValue(@YES);
}

- (RACSignal *)listSignalWithInput:(id)input type:(HyListActionType)type forKey:(NSString *)key {
    
    ListRequestConfigure *configure = ListRequestConfigure.new;
    configure.key = key;
    configure.input = input;
    configure.type = type;
    if (type == HyListActionTypeFirst) {
        configure.showHUD = YES;
    }
    configure.pageIndex = self.getPageIndex(type, key);
    configure.pageSize = self.getPageSize(key);
    [self configListReuestConfigure:configure];
    
    if (!configure.url.length) {
        return hy_signalWithValue(nil);
    }
    
    HyNetworkSignalSuccessSubscribeBlock successSubscribeBlock = configure.successSubscribeBlock ?:
    ({
        @weakify(self);
        ^(id<HyNetworkSuccessProtocol>  _Nonnull successObject, id<RACSubscriber>  _Nonnull subscriber) {
           @strongify(self);
            [self handleListSuccess:successObject requestConfigure:configure completion:^(id<HyListEntityProtocol> listEntity) {
                RACTuple *tuple = RACTuplePack(configure.input, (id)listEntity, @(configure.type), @(configure.noMore));
                [subscriber sendNext:tuple];
                [subscriber sendCompleted];
            }];
        };
    });

    HyNetworkSignalFailureSubscribeBlock failureBlock = configure.failureSubscribeBlock ?:
    ({
        ^(id<HyNetworkFailureProtocol> failureObject, id<RACSubscriber> subscriber){
            RACTuple *tuple = RACTuplePack(configure.input, failureObject.error, @(configure.type));
            [subscriber sendError:(id)tuple];
            [subscriber sendCompleted];
        };
    });    

    if (configure.isGet) {
        return
        hy_getSiganl(configure.showHUD, configure.cache, configure.url, configure.parameter, successSubscribeBlock, failureBlock);

    } else {
        return
        hy_postSiganl(configure.showHUD, configure.cache, configure.url, configure.parameter, successSubscribeBlock, failureBlock);
    }
}

- (void)configListReuestConfigure:(ListRequestConfigure *)configure {}
- (void)handleListSuccess:(id<HyNetworkSuccessProtocol>)successObject
         requestConfigure:(ListRequestConfigure *)configure
               completion:(void(^)(id<HyListEntityProtocol>))completion {
    
    NSDictionary *response = successObject.response;
    HyListActionType type = configure.type;
    NSString *key = configure.key;
    id input = configure.input;
    
    id<HyListEntityProtocol> listEntity = self.listEntity(key);
    NSMutableDictionary *listPage = self.listPage(key);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSMutableArray<id<HyListEntityProtocol>> *sectionEntityArray = @[].mutableCopy;
        
           if (configure.sectionDataHandler) {

               id sectionData = nil;
               Class<HyListEntityProtocol> sectionEntityClass = HyListEntity.class;
               NSArray *sectionArray = configure.sectionDataHandler(input, response, type);
               if (sectionArray.count) {
                   sectionData = sectionArray.firstObject;
                   if (sectionArray.count == 2) {
                       Class cls = sectionArray.lastObject;
                       if (Hy_ProtocolAndSelector(cls, @protocol(HyListEntityProtocol), @selector(entityWithParameter:))) {
                           sectionEntityClass = cls;
                       }
                   }
               }

               if (sectionData) {
                   if ([sectionData isKindOfClass:NSDictionary.class]) {
                       [sectionEntityArray addObject:[sectionEntityClass entityWithParameter:sectionData]];
                   } else if ([sectionData isKindOfClass:NSArray.class] ||
                              [sectionData isKindOfClass:NSMutableArray.class]) {
                       for (NSDictionary *dict in sectionData) {
                           [sectionEntityArray addObject:[sectionEntityClass entityWithParameter:dict]];
                       }
                   }
               }
           }

           if (configure.cellDataHandler) {

               if (!sectionEntityArray.count) {
                   id<HyListEntityProtocol> sectionEntity = (id)[HyListEntity entityWithParameter:response];
                   [sectionEntityArray addObject:sectionEntity];
               }

               for (id<HyListEntityProtocol> sectionEntity in sectionEntityArray) {

                   NSInteger index = [sectionEntityArray indexOfObject:sectionEntity];
                   NSDictionary *sectionDict = sectionEntity.parameter;

                   id cellData = nil;
                   Class cellEntityClass = HyEntity.class;
                   NSMutableArray<id<HyEntityProtocol>> *cellEntityArray = @[].mutableCopy;
                   NSArray *cellArray = configure.cellDataHandler(input, sectionDict, index, type);
                   if (cellArray.count) {
                       cellData = cellArray.firstObject;
                       if (cellArray.count == 2) {
                           Class cls = cellArray.lastObject;
                           if (Hy_ProtocolAndSelector(cls, @protocol(HyEntityProtocol), @selector(entityWithParameter:))) {
                               cellEntityClass = cls;
                           }
                       }
                   }

                   if (cellData) {
                       if ([cellData isKindOfClass:NSDictionary.class]) {
                          [cellEntityArray addObject:[cellEntityClass entityWithParameter:cellData]];
                       } else if ([cellData isKindOfClass:NSArray.class] ||
                                  [cellData isKindOfClass:NSMutableArray.class]) {
                          for (NSDictionary *dict in cellData) {
                              [cellEntityArray addObject:[cellEntityClass entityWithParameter:dict]];
                          }
                       }
                       [sectionEntity.entityArray addObjectsFromArray:(id)cellEntityArray];
                   }
               }
           }

        if (type == HyListActionTypeNew ||
           type == HyListActionTypeFirst) {
           if (configure.sectionDataHandler) {
               [listEntity.entityArray removeAllObjects];
           } else {
               [listEntity.entityArray.firstObject.entityArray removeAllObjects];
           }
           [listPage setObject:@([listPage[@"startIndex"] integerValue] + 1) forKey:@"pageIndex"];
        } else {
           [listPage setObject:@([listPage[@"pageIndex"] integerValue] + 1) forKey:@"pageIndex"];
        }

        BOOL noMore = NO;
        if (configure.sectionDataHandler) {
           [listEntity.entityArray addObjectsFromArray:sectionEntityArray];
           noMore = sectionEntityArray.count < [listPage[@"pageSize"] integerValue];
        } else {
           if (!listEntity.entityArray.count) {
               [listEntity.entityArray addObject:[HyListEntity entityWithParameter:nil]];
           }
           NSArray<id<HyEntityProtocol>> *cellEntityArray = sectionEntityArray.firstObject.entityArray;
           [listEntity.entityArray.firstObject.entityArray addObjectsFromArray:(id)cellEntityArray];
            noMore = cellEntityArray.count < [listPage[@"pageSize"] integerValue];
        }
        configure.noMore = noMore;
        
        [self entityParserCompleteHandler:successObject
                               listEntity:listEntity
                         requestConfigure:configure];

        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(listEntity);
        });
    });
}

- (void)entityParserCompleteHandler:(id<HyNetworkSuccessProtocol>)successObject
                         listEntity:(id<HyListEntityProtocol>)listEntity
                   requestConfigure:(ListRequestConfigure *)configure {
    
}

- (NSMutableDictionary<NSString *,HyListEntity *> *)listEntityDict {
    if (!_listEntityDict) {
        _listEntityDict = @{}.mutableCopy;
    }
    return _listEntityDict;
}

- (NSMutableDictionary<NSString *,NSMutableDictionary *> *)listPageDict {
    if (!_listPageDict) {
        _listPageDict = @{}.mutableCopy;
    }
    return _listPageDict;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
