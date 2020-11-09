//
//  HyModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//


#import "HyViewControllerJumpProtocol.h"
#import <ReactiveObjC/ReactiveObjC.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyModelProtocol <HyViewControllerJumpProtocol>
@optional

@property (nonatomic,strong,readonly) NSDictionary *parameter;
+ (instancetype)modelWithParameter:(nullable NSDictionary *)parameter;
- (void)setModelWithParameter:(nullable NSDictionary *)parameter;
- (void)modelLoad;


#pragma mark - Block 
@property (nonatomic,copy,readonly) void(^action)(id _Nullable input, NSString *_Nullable key);
@property (nonatomic,copy) typeof(void(^)(id _Nullable input, id data)) (^actionSuccess)(NSString *_Nullable key);
@property (nonatomic,copy) typeof(void(^)(id _Nullable input, NSError *error)) (^actionFailure)(NSString *_Nullable key);


#pragma mark - RAC
@property (nonatomic,copy,readonly) RACSignal<NSNumber *> *(^enabledSignal)(NSString *_Nullable key);
@property (nonatomic,copy,readonly) typeof(RACSignal *(^)(id _Nullable input))(^signal)(NSString *_Nullable key);

@end

NS_ASSUME_NONNULL_END
