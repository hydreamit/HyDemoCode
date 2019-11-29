//
//  HyViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewControllerJumpProtocol.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyViewModelProtocol;
@protocol HyViewProtocol <NSObject>
@optional
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) NSObject<HyViewModelProtocol> *viewModel;
- (void)viewLoad;
@end


@protocol HyViewFactoryProtocol <NSObject>
@optional
+ (UIView<HyViewProtocol> *)viewWithFrame:(CGRect)frame
                                viewModel:(nullable NSObject<HyViewModelProtocol> *)viewModel
                                parameter:(nullable id)parameter;
@end


NS_ASSUME_NONNULL_END