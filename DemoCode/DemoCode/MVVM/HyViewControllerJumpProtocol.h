//
//  HyViewControllerJumpProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyViewControllerProtocol;
@protocol HyViewControllerJumpProtocol <NSObject>
@optional
+ (UIViewController<HyViewControllerProtocol> *)pushViewControllerWithName:(NSString *_Nullable)controllerName
                                                             viewModelName:(NSString *_Nullable)viewModelName
                                                                 parameter:(NSDictionary *_Nullable)parameter
                                                                  animated:(BOOL)flag
                                                                completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;

+ (UIViewController<HyViewControllerProtocol> *)presentViewControllerWithName:(NSString *_Nullable)controllerName
                                                                viewModelName:(NSString * _Nullable)viewModelName
                                                                    parameter:(NSDictionary *_Nullable)parameter
                                                                     animated:(BOOL)flag
                                                                   completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion;

+ (nullable UIViewController<HyViewControllerProtocol> *)popViewControllerWithParameter:(NSDictionary *_Nullable)parameter
                                                                               animated:(BOOL)flag
                                                                             completion:(void(^_Nullable)(void))completion;


+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewController:(UIViewController<HyViewControllerProtocol> *)viewController
                                                                            parameter:(NSDictionary *_Nullable)parameter
                                                                             animated:(BOOL)flag
                                                                           completion:(void(^_Nullable)(void))completion;

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithName:(NSString * _Nullable)controllerName
                                                                                    parameter:(NSDictionary *_Nullable)parameter
                                                                                     animated:(BOOL)flag
                                                                                   completion:(void(^_Nullable)(void))completion;

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithFromIndex:(NSInteger)fromIndex
                                                                                         parameter:(NSDictionary *_Nullable)parameter
                                                                                          animated:(BOOL)flag
                                                                                        completion:(void(^_Nullable)(void))completion;

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithToIndex:(NSInteger)ToIndex
                                                                                       parameter:(NSDictionary *_Nullable)parameter
                                                                                        animated:(BOOL)flag
                                                                                      completion:(void(^_Nullable)(void))completion;

+ (void)dismissViewControllerWithParameter:(NSDictionary *)parameter
                                  animated:(BOOL)flag
                                completion:(void(^_Nullable)(void))completion;


@end


NS_ASSUME_NONNULL_END
