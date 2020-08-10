//
//  HyListEntityProtocol.h
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyEntityProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyListEntityProtocol <HyEntityProtocol>

@property (nonatomic,strong) NSMutableArray<id<HyListEntityProtocol>> *entityArray;
@property (nonatomic,copy,readonly) id<HyEntityProtocol> (^cellEntity)(NSIndexPath *indexPath);
@property (nonatomic,copy,readonly) id<HyListEntityProtocol> (^sectionEntity)(NSUInteger section);

@end


NS_ASSUME_NONNULL_END
