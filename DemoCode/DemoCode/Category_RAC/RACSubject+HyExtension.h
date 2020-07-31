//
//  RACSubject+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RACCommand+HyExtension.h"


NS_ASSUME_NONNULL_BEGIN

@interface RACSubject (HyExtension)

@property (nonatomic,copy,readonly) void(^sendWithInputBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(id))(^sendWithInputHandlerBlock)(id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^sendWithVoidBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^sendWithVoidHandlerBlock)(id(^_Nullable)(void));

@property (nonatomic,copy,readonly) void (^send)(id _Nullable input);
@property (nonatomic,copy,readonly) void (^sendFromSignal)(RACSignal *signal, id(^_Nullable)(id value));

@end

NS_ASSUME_NONNULL_END
