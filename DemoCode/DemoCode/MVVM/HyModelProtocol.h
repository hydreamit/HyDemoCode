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
- (void)modelLoad;


#pragma mark - Common
@property (nonatomic,copy,readonly) void(^action)(id input, NSString *_Nullable key);
@property (nonatomic,copy) typeof(void(^)(id input, id data)) (^actionSuccess)(NSString *_Nullable key);
@property (nonatomic,copy) typeof(void(^)(id input, NSError *error)) (^actionFailure)(NSString *_Nullable key);


#pragma mark - RAC
@property (nonatomic,copy,readonly) RACSignal<NSNumber *> *(^enabledSignal)(NSString *_Nullable key);
@property (nonatomic,copy,readonly) typeof(RACSignal *(^)(id input))(^signal)(NSString *_Nullable key);

@end

NS_ASSUME_NONNULL_END
