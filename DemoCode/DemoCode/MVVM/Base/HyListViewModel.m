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


@interface HyListViewModel ()
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger pageNumber;
@property (nonatomic,assign) NSInteger startPage;

@property (nonatomic,copy) NSString *(^urlBlock)(id, HyListViewRequestDataType);
@property (nonatomic,copy) NSDictionary *(^parameterBlock)(id, HyListViewRequestDataType);
@property (nonatomic,copy) NSArray *(^sectionDataHandler)(id, NSDictionary *, HyListViewRequestDataType);
@property (nonatomic,copy) NSArray *(^cellDataHandler)(id, NSDictionary *, NSInteger, HyListViewRequestDataType);
@property (nonatomic,copy) void(^successHandler)(id input,
                                                    id<HyListModelProtocol> listModel,
                                                    HyListViewRequestDataType type,
                                                    BOOL noMore);
@property (nonatomic,copy) void(^failureHandler)(id input,
                                                NSError *error,
                                                HyListViewRequestDataType type);
@end


@implementation HyListViewModel
@synthesize listModel = _listModel, reloadListViewBlock = _reloadListViewBlock;
- (void)viewModelLoad {
    [super viewModelLoad];
    
    self.isGet = YES;
    self.startPage = 0;
    self.pageNumber = self.startPage;
    self.pageSize = 20;
}

- (void)configStartPage:(NSInteger)startPage
               pageSize:(NSInteger)pageSize {
    
    self.pageSize = pageSize;
    self.startPage = startPage;
}

- (void)configRequestIsGet:(BOOL)isGet
                       url:(NSString *(^)(id _Nullable input, HyListViewRequestDataType type))url
                 parameter:(NSDictionary *(^_Nullable)(id _Nullable input, HyListViewRequestDataType type))parameter
         sectionDataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *response, HyListViewRequestDataType type))sectionDataHandler
            cellDataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *sectionData, NSUInteger section, HyListViewRequestDataType type))cellDataHandler {
    
    self.isGet = isGet;
    self.urlBlock = [url copy];
    self.parameterBlock = [parameter copy];
    self.sectionDataHandler = [sectionDataHandler copy];
    self.cellDataHandler = [cellDataHandler copy];
}

- (void)requestListSuccessHandler:(void (^)(id input,
                                            id<HyListModelProtocol> listModel,
                                            HyListViewRequestDataType type,
                                            BOOL noMore))successHandler
                   failureHandler:(void (^)(id input,
                                            NSError *error,
                                            HyListViewRequestDataType type))failureHandler {
    
    self.successHandler = [successHandler copy];
    self.failureHandler = [failureHandler copy];
}

- (void)requestListDataWithInput:(id)input type:(HyListViewRequestDataType)type {
    
    NSString *url = self.urlBlock ? self.urlBlock(input,type) : @"";
    NSDictionary *parameter = self.parameterBlock ? self.parameterBlock(input,type) : input;
    BOOL showHUD = type == HyListViewRequestDataTypeFirst;
    
    void (^success)(id<HyNetworkSuccessProtocol>) =
    ^(id<HyNetworkSuccessProtocol>  _Nullable successObject){
        [self _handleResponse:successObject.response input:input type:type];
    };
    
    void (^failure)(id<HyNetworkFailureProtocol>) =
    ^(id<HyNetworkFailureProtocol>  _Nullable failureObject){
        !self.failureHandler ?: self.failureHandler(input, failureObject.error, type);
    };
    
    if (self.isGet) {
        [[HyNetworkManager.network getShowHUD:showHUD
                                        cache:NO
                                          url:url
                                    parameter:parameter
                                 successBlock:success
                                 failureBlock:failure] resume];
    } else {
        [[HyNetworkManager.network postShowHUD:showHUD
                                         cache:NO
                                           url:url
                                     parameter:parameter
                                  successBlock:success
                                  failureBlock:failure] resume];
    }
}

- (void)_handleResponse:(NSDictionary *)response
                  input:(id)input
                   type:(HyListViewRequestDataType)type {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray<HyListModelProtocol> *sectionModelArray = @[].mutableCopy;
         
           if (self.sectionDataHandler) {
               
               id sectionData = nil;
               Class<HyModelFactoryProtocol> sectionModelClass = HyListModel.class;
               NSArray *sectionArray = self.sectionDataHandler(input, response, type);
               if (sectionArray.count) {
                   sectionData = sectionArray.firstObject;
                   if (sectionArray.count == 2) {
                       Class cls = sectionArray.lastObject;
                       if ([cls conformsToProtocol:@protocol(HyListModelProtocol)] &&
                           Hy_ProtocolAndSelector(cls, @protocol(HyModelFactoryProtocol), @selector(modelWithParameter:))) {
                           sectionModelClass = cls;
                       }
                   }
               }

               if (sectionData) {
                   if ([sectionData isKindOfClass:NSDictionary.class]) {
                       [sectionModelArray addObject:[sectionModelClass modelWithParameter:sectionData]];
                   } else if ([sectionData isKindOfClass:NSArray.class] ||
                              [sectionData isKindOfClass:NSMutableArray.class]) {
                       for (NSDictionary *dict in sectionData) {
                           [sectionModelArray addObject:[sectionModelClass modelWithParameter:dict]];
                       }
                   }
               }
           }
           
           if (self.cellDataHandler) {
               
               if (!sectionModelArray.count) {
                   id<HyListModelProtocol> listModel = (id<HyListModelProtocol>)[HyListModel modelWithParameter:response];
                   [sectionModelArray addObject:listModel];
               }
               
               for (id<HyListModelProtocol> sectionModel in sectionModelArray) {
                   
                   NSInteger index = [sectionModelArray indexOfObject:sectionModel];
                   NSDictionary *sectionDict = sectionModel.parameter;
        
                   id cellData = nil;
                   Class cellModelClass = HyModel.class;
                   NSMutableArray<HyModelProtocol> *cellModelArray = @[].mutableCopy;
                   NSArray *cellArray = self.cellDataHandler(input, sectionDict, index, type);
                   if (cellArray.count) {
                       cellData = cellArray.firstObject;
                       if (cellArray.count == 2) {
                           Class cls = cellArray.lastObject;
                           if ([cls conformsToProtocol:@protocol(HyModelProtocol)] &&
                               Hy_ProtocolAndSelector(cls, @protocol(HyModelFactoryProtocol), @selector(modelWithParameter:))) {
                               cellModelClass = cls;
                           }
                       }
                   }
                   
                   if (cellData) {
                       if ([cellData isKindOfClass:NSDictionary.class]) {
                          [cellModelArray addObject:[cellModelClass modelWithParameter:cellData]];
                       } else if ([cellData isKindOfClass:NSArray.class] ||
                                  [cellData isKindOfClass:NSMutableArray.class]) {
                          for (NSDictionary *dict in cellData) {
                              [cellModelArray addObject:[cellModelClass modelWithParameter:dict]];
                          }
                       }
                       [sectionModel.listModelArray addObjectsFromArray:cellModelArray];
                   }
               }
           }

           if (type == HyListViewRequestDataTypeNew ||
               type == HyListViewRequestDataTypeFirst) {
               
               if (self.sectionDataHandler) {
                  [self.listModel.listModelArray removeAllObjects];
               } else {
                   [((id<HyListModelProtocol>)self.listModel.listModelArray.firstObject).listModelArray removeAllObjects];
               }
               self.pageNumber = self.startPage + 1;
           } else {
               self.pageNumber += 1;
           }
           
           BOOL noMore = NO;
           if (self.sectionDataHandler) {
              [self.listModel.listModelArray addObjectsFromArray:sectionModelArray];
               noMore = sectionModelArray.count < self.pageSize;
           } else {
               
               if (!self.listModel.listModelArray.count) {
                   id<HyListModelProtocol> listModel = (id<HyListModelProtocol> )[HyListModel modelWithParameter:nil];
                   [self.listModel.listModelArray addObject:listModel];
               }
               
               NSArray<id<HyModelProtocol>> *cellModels = ((id<HyListModelProtocol> )sectionModelArray.firstObject).listModelArray;
               [((id<HyListModelProtocol>)self.listModel.listModelArray.firstObject).listModelArray addObjectsFromArray:cellModels];
               
                noMore = cellModels.count < self.pageSize;
           }
        
        dispatch_async(dispatch_get_main_queue(), ^{
             !self.successHandler ?: self.successHandler(input,
                                                         self.listModel,
                                                         type,
                                                         noMore);
        });
    });
}

- (NSInteger)getPageSize {
    return self.pageSize;
}

- (NSInteger(^)(HyListViewRequestDataType type))getRequestDataPageNumber {
    __weak typeof(self) _self = self;
    return ^NSInteger(HyListViewRequestDataType type){
        __strong typeof(_self) self = _self;
        return type == HyListViewRequestDataTypeMore ? self.pageNumber : self.startPage;
    };
}

- (id<HyListModelProtocol> (^)(NSUInteger section))sectionModel {
     __weak typeof(self) _self = self;
    return ^ id<HyListModelProtocol> (NSUInteger section){
        __strong typeof(_self) self = _self;
        
        if (!self.listModel) { return nil; }
        if (section >= self.listModel.listModelArray.count) { return nil;}
        return self.listModel.listModelArray[section];
    };
}

- (id<HyModelProtocol> (^)(NSIndexPath *indexPath))cellModel {
    __weak typeof(self) _self = self;
    return ^ id<HyModelProtocol> (NSIndexPath *indexPath){
        __strong typeof(_self) self = _self;
        
        if (!self.listModel || !indexPath) { return nil; }
        
        id<HyListModelProtocol> sectionData = self.sectionModel(indexPath.section);
        if (!sectionData) { return nil; }
        if (indexPath.row >= sectionData.listModelArray.count) {
            return nil;
        }
        return sectionData.listModelArray[indexPath.row];
    };
}

- (id<HyListModelProtocol>)listModel {
    if (!_listModel) {
        Class<HyModelFactoryProtocol> cls = getObjcectPropertyClass([self class], "listModel");
        if (cls == NULL) {
            cls = HyListModel.class;
        }
        if (Hy_ProtocolAndSelector(cls, @protocol(HyModelFactoryProtocol), @selector(modelWithParameter:))) {
            _listModel = (id<HyListModelProtocol>)[cls modelWithParameter:self.parameter];
        }
    }
    return _listModel;
}

@end
