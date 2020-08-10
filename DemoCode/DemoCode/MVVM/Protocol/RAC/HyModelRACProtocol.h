//
//  HyModelRACProtocol.h
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HyModelBaseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyModelRACProtocol <HyModelBaseProtocol>

@property (nonatomic,copy,readonly) RACSignal<NSNumber *> *(^requestDataEnabledSignal)(NSString *type);
@property (nonatomic,copy,readonly) typeof(RACSignal *(^)(id input))(^requestDataSignal)(NSString *type);

@end

NS_ASSUME_NONNULL_END
