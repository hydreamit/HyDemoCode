//
//  HyViewControllerProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewControllerJumpProtocol.h"
#import "HyViewModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyViewControllerProtocol <HyViewControllerJumpProtocol>
@optional

+ (instancetype)viewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                      parameter:(NSDictionary * _Nullable)parameter;

+ (instancetype)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
                                          parameter:(NSDictionary *_Nullable)parameter
                                           animated:(BOOL)flag
                                         completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;

+ (instancetype)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                             parameter:(NSDictionary *_Nullable)parameter
                                              animated:(BOOL)flag
                                            completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;


@property (nonatomic,strong,readonly) NSDictionary *parameter;
@property (nonatomic,strong,readonly) id<HyViewModelProtocol> viewModel;
- (void)viewModelWillLoad;
- (void)viewModelDidLoad;
- (void)popFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;
- (void)dismissFromViewController:(NSString *)name parameter:(NSDictionary *)parameter;

@end


NS_ASSUME_NONNULL_END
