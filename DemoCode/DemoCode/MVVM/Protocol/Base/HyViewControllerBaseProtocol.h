//
//  HyViewControllerBaseProtocol.h
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyViewModelBaseProtocol;
@protocol HyViewControllerBaseProtocol <NSObject>
@optional

+ (instancetype)viewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                      parameter:(NSDictionary * _Nullable)parameter;

+ (instancetype)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
                                          parameter:(NSDictionary *_Nullable)parameter
                                           animated:(BOOL)flag
                                         completion:(void(^_Nullable)(UIViewController<HyViewControllerBaseProtocol> *controller))completion;

+ (instancetype)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                             parameter:(NSDictionary *_Nullable)parameter
                                              animated:(BOOL)flag
                                            completion:(void(^_Nullable)(UIViewController<HyViewControllerBaseProtocol> *controller))completion;


@property (nonatomic,strong,readonly) NSDictionary *parameter;
@property (nonatomic,strong,readonly) id<HyViewModelBaseProtocol> viewModel;
- (void)viewModelWillLoad;
- (void)viewModelDidLoad;
- (void)popFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;
- (void)dismissFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;

@end

NS_ASSUME_NONNULL_END
