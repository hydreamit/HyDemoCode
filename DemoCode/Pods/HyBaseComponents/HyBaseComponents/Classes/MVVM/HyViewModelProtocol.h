//
//  HyViewModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "HyModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyBlockProtocol <NSObject>
+ (instancetype)block:(id)block;
- (void)releaseBlock;
@end


@protocol HyViewModelProtocol <HyViewControllerJumpProtocol>
@optional

@property (nonatomic,strong,readonly) NSDictionary *parameter;
@property (nonatomic,strong,readonly) id<HyModelProtocol> model;
@property (nonatomic,weak,readonly) UINavigationController *viewModelNavigationController;
@property (nonatomic,weak,readonly) UIViewController<HyViewControllerProtocol> *viewModelController;

+ (instancetype)viewModelWithParameter:(nullable NSDictionary *)parameter;
- (void)viewModelLoad;

- (void)setModelWithParameter:(nullable NSDictionary *)parameter;


#pragma mark - Block
@property (nonatomic,copy,readonly) typeof(void(^)(id _Nullable parameter)) (^action)(NSString *_Nullable key);
- (id<HyBlockProtocol>)addActionSuccessHandler:(void(^)(id _Nullable input, id _Nullable data))successHandler
                                        forKey:(NSString *_Nullable)key;
- (id<HyBlockProtocol>)addActionFailureHandler:(void(^)(id _Nullable input, NSError *error))failureHandler
                                        forKey:(NSString *_Nullable)key;
- (NSArray<id<HyBlockProtocol>> *)addActionSuccessHandler:(void(^)(id _Nullable input, id _Nullable data))successHandler
                                           failureHandler:(void(^)(id _Nullable input, NSError *error))failureHandler
                                                   forKey:(NSString *_Nullable)key;


@property (nonatomic,copy,readonly) NSArray<typeof(void(^)(id _Nullable parameter))> *(^refreshView)(NSString *_Nullable key);
- (id<HyBlockProtocol>)addRefreshViewBlock:(void(^)(id _Nullable parameter))block forKey:(NSString *_Nullable)key;
- (void)refreshViewWithParameter:(id _Nullable)parameter forKey:(NSString *_Nullable)key;



#pragma mark - RAC
@property (nonatomic,copy,readonly) RACCommand *(^command)(NSString *_Nullable key);
@property (nonatomic,copy,readonly) RACSubject *(^refreshViewSignal)(NSString *_Nullable key);

@end


NS_ASSUME_NONNULL_END
