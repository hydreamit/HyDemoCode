//
//  NSObject+HyProtocol.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <HyCategoriess/UINavigationController+HyExtension.h>
#import <HyCategoriess/HyRunTimeMethods.h>
#import "HyViewControllerProtocol.h"
#import "HyViewModelProtocol.h"
#import "NSObject+HyProtocol.h"
#import "HyViewController.h"
#import <objc/message.h>
#import "HyViewModel.h"


@implementation NSObject (HyProtocol)

- (void)setViewModel:(NSObject<HyViewModelProtocol> *)viewModel {
    objc_setAssociatedObject(self,
                             @selector(viewModel),
                             viewModel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject<HyViewModelProtocol> *)viewModel {
    NSObject<HyViewModelProtocol> *viewModel = objc_getAssociatedObject(self, _cmd);
    return viewModel;
}

- (void)setParameter:(id)parameter {
    objc_setAssociatedObject(self,
                            @selector(parameter),
                            parameter,
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)parameter {
    return objc_getAssociatedObject(self, _cmd);
}

+ (UIViewController<HyViewControllerProtocol> *)pushViewControllerWithName:(NSString *_Nullable)controllerName
                                                             viewModelName:(NSString *_Nullable)viewModelName
                                                                 parameter:(NSDictionary *_Nullable)parameter
                                                                  animated:(BOOL)flag
                                                                completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion {
    
    Class controllerClass = nil;
    if (!controllerName.length) {
        controllerClass = [self hy_createDifferClass];
    } else {
        const char *controllerNameChar = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
        controllerClass = objc_getClass(controllerNameChar);
        if (!controllerClass) {
            objc_registerClassPair(objc_allocateClassPair(HyViewController.class, controllerNameChar, 0));
            controllerClass = objc_getClass(controllerNameChar);
        }
    }

    UIViewController<HyViewControllerProtocol> *controller = [controllerClass viewControllerWithViewModelName:viewModelName parameter:parameter];
    UIViewController *currentController = UIViewController.hy_currentViewController;
    __weak typeof(controller) weakController = controller;
    if (currentController.navigationController.viewControllers.count) {
        controller.hidesBottomBarWhenPushed = YES;
    }
    [currentController.navigationController hy_pushViewController:controller animated:flag completion:^{
        __strong typeof(weakController) strongController = weakController;
        !completion ?: completion(strongController);
    }];
    return controller;
}

+ (UIViewController<HyViewControllerProtocol> *)presentViewControllerWithName:(NSString *_Nullable)controllerName
                                                                viewModelName:(NSString * _Nullable)viewModelName
                                                                    parameter:(NSDictionary *_Nullable)parameter
                                                                     animated:(BOOL)flag
                                                                   completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion {
    
    Class controllerClass = nil;
    if (!controllerName.length) {
        controllerClass = [self hy_createDifferClass];
    } else {
        const char *controllerNameChar = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
        controllerClass = objc_getClass(controllerNameChar);
        if (!controllerClass) {
            objc_registerClassPair(objc_allocateClassPair(HyViewController.class, controllerNameChar, 0));
            controllerClass = objc_getClass(controllerNameChar);
        }
    }
    
    UIViewController<HyViewControllerProtocol> *controller = [controllerClass viewControllerWithViewModelName:viewModelName parameter:parameter];
    UIViewController *currentController = UIViewController.hy_currentViewController;
    __weak typeof(controller) weakController = controller;
    [currentController presentViewController:controller animated:flag completion:^{
        __strong typeof(weakController) strongController = weakController;
        !completion ?: completion(strongController);
    }];
    return controller;
}


+ (nullable UIViewController<HyViewControllerProtocol> *)popViewControllerWithParameter:(NSDictionary *_Nullable)parameter
                                                                               animated:(BOOL)flag
                                                                             completion:(void(^_Nullable)(void))completion {
   
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
     NSString *controllerName = NSStringFromClass(currentController.class);
    UIViewController<HyViewControllerProtocol> *popController = (UIViewController<HyViewControllerProtocol> *)[currentController.navigationController hy_viewControllerToIndex:1];
     __weak typeof(currentController) weakController = popController;
    return (UIViewController<HyViewControllerProtocol> *)[currentController.navigationController hy_popViewControllerAnimated:flag completion:^{
        __strong typeof(weakController) strongController = weakController;
        if (Hy_ProtocolAndSelector(strongController, @protocol(HyViewControllerProtocol), @selector(popFromViewController:parameter:))) {
            [strongController popFromViewController:controllerName parameter:parameter];
        }
    }];
}

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewController:(UIViewController<HyViewControllerProtocol> *)viewController
                                                                            parameter:(NSDictionary *_Nullable)parameter
                                                                             animated:(BOOL)flag
                                                                           completion:(void(^_Nullable)(void))completion {
    
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
    NSString *controllerName = NSStringFromClass(currentController.class);
    __weak typeof(currentController) weakController = viewController;
    return
    [currentController.navigationController hy_popToViewController:viewController animated:flag completion:^{
        __strong typeof(weakController) strongController = weakController;
        if (Hy_ProtocolAndSelector(strongController, @protocol(HyViewControllerProtocol), @selector(popFromViewController:parameter:))) {
            [strongController popFromViewController:controllerName parameter:parameter];
        }
    }];
}

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithName:(NSString * _Nullable)controllerName
                                                                                    parameter:(NSDictionary *_Nullable)parameter
                                                                                     animated:(BOOL)flag
                                                                                   completion:(void(^_Nullable)(void))completion {
    
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
    UIViewController<HyViewControllerProtocol> *popController = (UIViewController<HyViewControllerProtocol> *)([currentController.navigationController hy_viewControllerWithName:controllerName]);
    return [self popViewController:popController parameter:parameter animated:flag completion:completion];
}

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithFromIndex:(NSInteger)fromIndex
                                                                                         parameter:(NSDictionary *_Nullable)parameter
                                                                                          animated:(BOOL)flag
                                                                                        completion:(void(^_Nullable)(void))completion {
    
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
    UIViewController<HyViewControllerProtocol> *popController = (UIViewController<HyViewControllerProtocol> *)[currentController.navigationController hy_viewControllerFromIndex:fromIndex];
    return [self popViewController:popController parameter:parameter animated:flag completion:completion];
}

+ (nullable NSArray<UIViewController<HyViewControllerProtocol> *> *)popViewControllerWithToIndex:(NSInteger)toIndex
                                                                                       parameter:(NSDictionary *_Nullable)parameter
                                                                                        animated:(BOOL)flag
                                                                                      completion:(void(^_Nullable)(void))completion {
    
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
    UIViewController<HyViewControllerProtocol> *popController = (UIViewController<HyViewControllerProtocol> *)[currentController.navigationController hy_viewControllerToIndex:toIndex];
    return [self popViewController:popController parameter:parameter animated:flag completion:completion];
}


+ (void)dismissViewControllerWithParameter:(NSDictionary *)parameter
                                  animated:(BOOL)flag
                                completion:(void(^_Nullable)(void))completion {
    
    UIViewController<HyViewControllerProtocol> *currentController = (UIViewController<HyViewControllerProtocol> *)UIViewController.hy_currentViewController;
    NSString *controllerName = NSStringFromClass(currentController.class);
    UIViewController<HyViewControllerProtocol> *presentedViewController = (UIViewController<HyViewControllerProtocol> *)currentController.presentedViewController;
    __weak typeof(currentController) weakController = presentedViewController;
    [currentController dismissViewControllerAnimated:flag completion:^{
        __strong typeof(weakController) strongController = weakController;
        if (Hy_ProtocolAndSelector(strongController, @protocol(HyViewControllerProtocol), @selector(dismissFromViewController:parameter:))) {
            [strongController dismissFromViewController:controllerName parameter:parameter];
        }
    }];
}

+ (Class)hy_createDifferClass {
    
    NSString *perNameString = @"HyViewController";
    NSString *customClassName = [NSString stringWithFormat:@"%@_%zd",perNameString, random()%10000];
    const char *className = [customClassName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        objc_registerClassPair(objc_allocateClassPair(HyViewController.class, className, 0));
        return objc_getClass(className);
    } else {
        return [self hy_createDifferClass];
    }
}

@end
