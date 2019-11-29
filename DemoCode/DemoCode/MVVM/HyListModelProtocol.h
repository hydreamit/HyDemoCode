//
//  HyListModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyModelProtocol;
@protocol HyListModelProtocol <HyModelProtocol>
@optional

@property (nonatomic,strong) NSMutableArray<HyListModelProtocol> *listModelArray;

@end

NS_ASSUME_NONNULL_END
