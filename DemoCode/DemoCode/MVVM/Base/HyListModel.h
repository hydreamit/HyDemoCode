//
//  HyListModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyModel.h"
#import "HyListModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListRequestConfigure : RequestConfigure
@property (nonatomic, assign,readonly) NSInteger pageSize;
@property (nonatomic, assign,readonly) NSInteger pageIndex;
@property (nonatomic, assign,readonly) HyListActionType type;
@property (nonatomic, copy) NSArray *(^sectionDataHandler)(id _Nullable input, NSDictionary *response, HyListActionType type);
@property (nonatomic, copy) NSArray *(^cellDataHandler)(id _Nullable input, NSDictionary *sectionData, NSUInteger section, HyListActionType type);
@end


@interface HyListModel : HyModel <HyListModelProtocol>

@property (nonatomic, copy, readonly) NSInteger (^getPageSize)(NSString *key);
@property (nonatomic, copy, readonly) NSInteger (^getPageIndex)(HyListActionType type, NSString *key);


- (void)configListReuestConfigure:(ListRequestConfigure *)configure;

- (void)entityParserCompleteHandler:(id<HyNetworkSuccessProtocol>)successObject
                         listEntity:(id<HyListEntityProtocol>)listEntity
                   requestConfigure:(ListRequestConfigure *)configure;

#pragma mark -
- (void)listActionWithInput:(NSString *)input type:(HyListActionType)type forKey:(NSString *)key;
- (void)handleListSuccess:(id<HyNetworkSuccessProtocol>)successObject requestConfigure:(ListRequestConfigure *)configure;
- (void)handleListFailure:(id<HyNetworkFailureProtocol>)failureObject requestConfigure:(ListRequestConfigure *)configure;


#pragma mark - 子类重写
- (RACSignal<NSNumber *> *)listEnabledSignalForKey:(NSString *)key;
- (RACSignal<RACTuple *> *)listSignalWithInput:(id _Nullable)input type:(HyListActionType)type forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
