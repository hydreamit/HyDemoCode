//
//  HyViewControllerProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewControllerJumpProtocol.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyViewModelProtocol;
@protocol HyViewControllerProtocol <NSObject>
@optional
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id<HyViewModelProtocol> viewModel;
- (void)viewModelWillLoad;
- (void)viewModelDidLoad;
- (void)popFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;
- (void)dismissFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;
@end


@protocol HyViewControllerFactoryProtocol <NSObject>
@optional
+ (UIViewController<HyViewControllerProtocol> *)viewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                                                      parameter:(NSDictionary * _Nullable)parameter;

+ (UIViewController<HyViewControllerProtocol> *)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
                                                 parameter:(NSDictionary *_Nullable)parameter
                                                  animated:(BOOL)flag
                                                completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;

+ (UIViewController<HyViewControllerProtocol> *)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                                parameter:(NSDictionary *_Nullable)parameter
                                                 animated:(BOOL)flag
                                               completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;
@end

NS_ASSUME_NONNULL_END
