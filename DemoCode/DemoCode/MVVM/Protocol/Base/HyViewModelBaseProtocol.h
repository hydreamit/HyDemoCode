//
//  HyViewModelBaseProtocol.h
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewControllerJumpProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyModelBaseProtocol, HyViewControllerBaseProtocol;
@protocol HyViewModelBaseProtocol <HyViewControllerJumpProtocol>

+ (instancetype)viewModelWithParameter:(nullable NSDictionary *)parameter;

@property (nonatomic,strong,readonly) NSDictionary *parameter;
@property (nonatomic,strong,readonly) id<HyModelBaseProtocol> model;
@property (nonatomic,weak,readonly) UINavigationController *viewModelNavigationController;
@property (nonatomic,weak,readonly) UIViewController<HyViewControllerBaseProtocol> *viewModelController;

- (void)viewModelLoad;

@end

NS_ASSUME_NONNULL_END
