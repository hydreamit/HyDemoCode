//
//  NSObject+HyNetwork.h
//  DemoCode
//
//  Created by Hy on 2018/3/12.
//  Copyright © 2018 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "HyNetworkBaseTaskProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface HyNetworkTaskContainer : NSObject
@property (nonatomic, strong) NSMutableArray<HyNetworkBaseTaskProtocol> *tasks;
@end


@interface NSObject (HyNetwork)
@property (nonatomic,strong) HyNetworkTaskContainer *hy_networkTaskContainer;
@end

NS_ASSUME_NONNULL_END
