//
//  HyListEntity.h
//  DemoCode
//
//  Created by huangyi on 2017/8/6.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HyListEntityProtocol.h"
#import "HyEntity.h"

NS_ASSUME_NONNULL_BEGIN
@class HyListEntity;
@interface HyListEntity<__covariant ListEntityType : id<HyListEntityProtocol>> : HyEntity<HyListEntityProtocol>

//@property (nonatomic,strong,readonly) NSMutableArray<ListEntityType> *entityArray;

//- (NSMutableArray<ListEntityType> *)entityArray;

@end

NS_ASSUME_NONNULL_END
