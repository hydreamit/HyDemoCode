//
//  HyNetworkSuccessProtocol.h
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyNetworkSingleTaskProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkSuccessProtocol <NSObject>

@property (nonatomic,strong,nullable) id response;

@property (nonatomic,strong) id<HyNetworkSingleTaskProtocol> task;

@end

NS_ASSUME_NONNULL_END
