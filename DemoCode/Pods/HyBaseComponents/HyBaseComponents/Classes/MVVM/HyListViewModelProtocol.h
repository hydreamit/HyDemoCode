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


@protocol HyListViewModelProtocol <HyViewModelProtocol>
@optional

@property (nonatomic,copy,readonly) id<HyListEntityProtocol>(^listEntity)(NSString *_Nullable key);

#pragma mark - Block
@property (nonatomic,copy,readonly) typeof(void(^)(id parameter, HyListActionType type)) (^listAction)(NSString *_Nullable key);
- (id<HyBlockProtocol>)addListActionSuccessHandler:(void(^)(id _Nullable input, id _Nullable data, HyListActionType type, BOOL noMore))successHandler
                                            forKey:(NSString *_Nullable)key;
- (id<HyBlockProtocol>)addListActionFailureHandler:(void(^)(id _Nullable input, NSError *error, HyListActionType type))failureHandler
                                            forKey:(NSString *_Nullable)key;
- (NSArray<id<HyBlockProtocol>> *)addListActionSuccessHandler:(void(^_Nullable)(id _Nullable input, id _Nullable data, HyListActionType type, BOOL noMore))successHandler
                                               failureHandler:(void(^_Nullable)(id _Nullable input, NSError *error, HyListActionType type))failureHandler
                                                       forKey:(NSString *_Nullable)key;

@property (nonatomic,copy,readonly) NSArray<typeof(void(^)(id _Nullable parameter))> *(^refreshListView)(NSString *_Nullable key);
- (id<HyBlockProtocol>)addRefreshListViewBlock:(void(^)(id _Nullable parameter))block forKey:(NSString *_Nullable)key;
- (void)refreshListViewWithParameter:(id _Nullable)parameter forKey:(NSString *_Nullable)key;


#pragma mark - RAC
@property (nonatomic,copy,readonly) RACCommand<RACTuple *, RACTuple *> *(^listCommand)(NSString *_Nullable key);
@property (nonatomic,copy,readonly) RACSubject *(^refreshListViewSignal)(NSString *_Nullable key);

@end


NS_ASSUME_NONNULL_END
