//
//  HyViewModelRACProtocol.h
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HyViewModelBaseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyViewModelRACProtocol <HyViewModelBaseProtocol>

/// view 层获取数据
@property (nonatomic,copy,readonly) RACCommand *(^requestDataCommand)(NSString *type);

/// 刷新view层信号
@property (nonatomic,copy,readonly) RACSubject *(^refreshViewSignal)(NSString *type);


@end

NS_ASSUME_NONNULL_END
