//
//  HyListViewModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HyViewModelProtocol.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "HyModelProtocol.h"
#import "HyListModel.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyListViewRequestDataType) {
    HyListViewRequestDataTypeNew,
    HyListViewRequestDataTypeMore
};


@protocol HyListViewModelProtocol <HyViewModelProtocol>
@optional

@property (nonatomic,strong) NSObject<HyListModelProtocol> *listModel;
@property (nonatomic,copy) void(^reloadListViewBlock)(id _Nullable parameter);

- (NSInteger)getPageSize;
- (NSInteger(^)(HyListViewRequestDataType type))getRequestDataPageNumber;

- (void)configStartPage:(NSInteger)startPage
               pageSize:(NSInteger)pageSize;

- (void)configRequestIsGet:(BOOL)isGet
                       url:(NSString *(^)(id _Nullable input, HyListViewRequestDataType type))url
                 parameter:(NSDictionary *(^_Nullable)(id _Nullable input, HyListViewRequestDataType type))parameter
         sectionDataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *response, HyListViewRequestDataType type))sectionDataHandler
            cellDataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *sectionData, NSUInteger section, HyListViewRequestDataType type))cellDataHandler;

- (void)requestListDataWithInput:(id _Nullable)input type:(HyListViewRequestDataType)type;

- (void)requestListSuccessHandler:(void (^)(id input,
                                        NSObject<HyListModelProtocol> *listModel,
                                        HyListViewRequestDataType type,
                                        BOOL noMore))successHandler
                   failureHandler:(void (^)(id input,
                                            NSError *error,
                                            HyListViewRequestDataType type))failureHandler;

- (NSObject<HyModelProtocol> *(^)(NSIndexPath *indexPath))cellModel;
- (NSObject<HyListModelProtocol> *(^)(NSUInteger section))sectionModel;

@end


NS_ASSUME_NONNULL_END