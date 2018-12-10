//
//  HYJumpConrollerTool.m
//  HYlesAssistant
//
//  Created by huangyi on 17/7/6.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYCurrentControllerTool.h"
#import "HYBaseViewController.h"
#import "HYJumpConrollerTool.h"
#import "HYBaseViewModel.h"
#import "HYRunTimeTool.h"


@implementation HYJumpConrollerTool

+ (void)pushViewControllerWithControllerName:(NSString *)controllerName
                               viewModelName:(NSString *)viewModelName
                                      params:(NSDictionary *)params
                                    animated:(BOOL)flag {
    
    [self handleViewControllerJumpWithControllerName:controllerName
                                       viewModelName:viewModelName
                                              params:params
                                            animated:flag
                                              isPush:YES];
}

+ (void)presentViewControllerWithControllerName:(NSString *)controllerName
                                  viewModelName:(NSString *)viewModelName
                                         params:(NSDictionary *)params
                                       animated:(BOOL)flag {
    
    [self handleViewControllerJumpWithControllerName:controllerName
                                       viewModelName:viewModelName
                                              params:params
                                            animated:flag
                                              isPush:NO];
}

+ (void)popViewControllerWithControllerName:(NSString *)controllerName
                                     params:(NSDictionary *)params
                                   animated:(BOOL)flag {
    
    [self handleViewControllerBackWithControllerName:controllerName
                                              params:params
                                            animated:flag
                                              isPush:YES];
}

+ (void)dismissViewControllerWithParams:(NSDictionary *)params
                               animated:(BOOL)flag {
    
    [self handleViewControllerBackWithControllerName:nil
                                              params:params
                                            animated:flag
                                              isPush:NO];
}

+ (HYBaseViewController *)controllerWithName:(NSString *)controllerName
                               viewModelName:(NSString *)viewModelName
                                      params:(NSDictionary *)params {
    
    
    const char *vcClassName = [controllerName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(vcClassName);
    if (!newClass){
        if (!controllerName ||
            ![controllerName isKindOfClass:NSString.class] ||
            !controllerName.length) {
            newClass = [self createNoSameClassIsController:YES];
        } else {
            objc_registerClassPair(objc_allocateClassPair([HYBaseViewController class], vcClassName, 0));
        }
    }
    id contorller = [[newClass alloc] init];
    
    id viewModel = [self viewModelWithName:viewModelName params:params];
    
    SEL contorllerMethod = NSSelectorFromString(@"initWithViewModel:");
    if ([contorller respondsToSelector:contorllerMethod]) {
        ((void (*)(id, SEL, id))objc_msgSend)((id)contorller, contorllerMethod, viewModel);
    } else {
        NSArray<NSString *> *propertyList = [HYRunTimeTool propertyListWithClass:[contorller class]];
        [propertyList enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:@"viewModel"]) {
                [contorller setValue:viewModel forKey:@"viewModel"];
                *stop = YES;
            }
        }];
    }
    
    return contorller;
}

+ (HYBaseViewModel *)viewModelWithName:(NSString *)viewModelName
                                params:(NSDictionary *)params {
    
    const char *viewModelClassName = [viewModelName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(viewModelClassName);
    if (!newClass){
        if (!viewModelName ||
            ![viewModelName isKindOfClass:NSString.class] ||
            !viewModelName.length) {
            newClass = [self createNoSameClassIsController:YES];
        } else {
            objc_registerClassPair(objc_allocateClassPair([HYBaseViewModel class], viewModelClassName, 0));
        }
    }
    
    id viewModel;
    if ([params isKindOfClass:NSDictionary.class]) {
        viewModel = [newClass mj_objectWithKeyValues:params];
    } else {
        viewModel = [[newClass alloc] init];
    }
    
    SEL viewModelMethod = NSSelectorFromString(@"handleViewModel");
    if ([viewModel respondsToSelector:viewModelMethod]) {
        ((void (*)(id, SEL))objc_msgSend)((id)viewModel, viewModelMethod);
    }
    return viewModel;
}

+ (void)handleViewControllerJumpWithControllerName:(NSString *)controllerName
                                     viewModelName:(NSString *)viewModelName
                                            params:(NSDictionary *)params
                                          animated:(BOOL)flag
                                            isPush:(BOOL)push {
        
    id contorller = [self controllerWithName:controllerName
                               viewModelName:viewModelName
                                      params:params];

    UIViewController *currentVC = [HYCurrentControllerTool sharedCurrentControllerTool].currentController;
    if ([contorller isKindOfClass:[UIViewController class]]) {
        if (push) {
            [currentVC.navigationController pushViewController:contorller animated:flag];
        } else {
            [currentVC presentViewController:contorller animated:flag completion:nil];
        }
    }
}

+ (void)handleViewControllerBackWithControllerName:(NSString *)controllerName
                                            params:(NSDictionary *)params
                                          animated:(BOOL)flag
                                            isPush:(BOOL)push {
    
    UIViewController *currentVC = [HYCurrentControllerTool sharedCurrentControllerTool].currentController;
    UIViewController *backVc;
    if (push) {
        if ([controllerName isKindOfClass:NSString.class] && controllerName.length) {
            backVc = [self getNaviChildViewControllerWithName:controllerName];
        } else {
            backVc = [self getPopContronller];
        }
    } else {
        backVc = currentVC.presentingViewController;
    }
    
    if (backVc && [self checkPropertyWithInstance:backVc propertyName:@"viewModel"]) {
        id viewModel = [backVc valueForKeyPath:@"viewModel"];
        if (viewModel && [params isKindOfClass:NSDictionary.class]) {
            [[viewModel class] mj_setKeyValues:params];
            SEL viewModelMethod = NSSelectorFromString(@"handleBackViewModel");
            if ([viewModel respondsToSelector:viewModelMethod]) {
                ((void (*)(id, SEL))objc_msgSend)((id)viewModel, viewModelMethod);
            }
        }
    }
    
    if (backVc) {
        if (push) {
            [currentVC.navigationController popToViewController:backVc animated:flag];
        } else {
            [backVc dismissViewControllerAnimated:false completion:nil];
        }
    }
}

+ (Class)createNoSameClassIsController:(BOOL)isController {
    
    NSString *perNameString = isController ? @"HYNoClassController" : @"HYNoClassViewModel";
    Class currentClass = isController ? HYBaseViewController.class : HYBaseViewModel.class;
    NSString *customClassName = [NSString stringWithFormat:@"%@_%zd",perNameString, random()%10000];
    const char *className = [customClassName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        objc_registerClassPair(objc_allocateClassPair(currentClass, className, 0));
        return newClass;
    } else {
        return [self createNoSameClassIsController:isController];
    }
}

+ (BOOL)checkPropertyWithInstance:(id)instance
                     propertyName:(NSString *)propertyName {
    __block BOOL checkCan = NO;
    NSArray *propertyList =  [HYRunTimeTool propertyListWithClass:[instance class]];
    [propertyList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:propertyName]) {
            checkCan = YES;
            *stop = YES;
        }
    }];
    return checkCan;
}

+ (UIViewController *)getNaviChildViewControllerWithName:(NSString *)name{
    __block UIViewController *vc;
    UIViewController *currentVC = [HYCurrentControllerTool sharedCurrentControllerTool].currentController;
    [currentVC.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.className isEqualToString:name]) {
            vc = obj;
            *stop = YES;
        }
    }];
    if (vc) {
        return vc;
    }
    return nil;
}

+ (UIViewController *)getPopContronller {
    UIViewController *currentVC = [HYCurrentControllerTool sharedCurrentControllerTool].currentController;
    NSInteger cout = currentVC.navigationController.childViewControllers.count - 2;
    return [self getNaviChildViewControllerWithIndex:cout];
}

+ (UIViewController *)getNaviChildViewControllerWithIndex:(NSInteger)index{
    UIViewController *currentVC = [HYCurrentControllerTool sharedCurrentControllerTool].currentController;
    if (index > currentVC.navigationController.childViewControllers.count) {
        return nil;
    }
    if (index < 0) {
        return nil;
    }
    UIViewController *vc = [currentVC.navigationController.childViewControllers objectAtIndex:index];
    return vc;
}
@end
