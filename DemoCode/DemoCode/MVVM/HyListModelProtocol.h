//
//  HyListModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyListEntityProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HyListActionType) {
    HyListActionTypeFirst,
    HyListActionTypeNew,
    HyListActionTypeMore
};

@protocol HyModelProtocol;
@protocol HyListModelProtocol <HyModelProtocol>
@optional

@property (nonatomic,copy,readonly) id<HyListEntityProtocol>(^listEntity)(NSString *key);

#pragma mark - Common
@property (nonatomic,copy,readonly) void(^listAction)(id input, HyListActionType typ, NSString *key);
@property (nonatomic,copy) typeof(void(^)(id input, id data, HyListActionType typ, BOOL noMore)) (^listActionSuccess)(NSString *key);
@property (nonatomic,copy) typeof(void(^)(id input, NSError *error, HyListActionType typ)) (^listActionFailure)(NSString *key);


#pragma mark - RAC
@property (nonatomic,copy,readonly) RACSignal<NSNumber *> *(^listEnabledSignal)(NSString *key);
@property (nonatomic,copy,readonly) typeof(RACSignal *(^)(id input))(^listSignal)(HyListActionType typ, NSString *key);

@end

NS_ASSUME_NONNULL_END
