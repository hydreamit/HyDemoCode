//
//  HyViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewController.h"
#import "HyViewModelProtocol.h"
#import "NSObject+HyProtocol.h"
#import <objc/message.h>


@implementation HyViewController
@synthesize parameter = _parameter;

+ (UIViewController<HyViewControllerProtocol> *)viewControllerWithViewModelName:(NSString *)viewModelName
                                                                      parameter:(NSDictionary *)parameter {
    
    UIViewController<HyViewControllerProtocol> *controller = [[self alloc] init];
    controller.parameter = parameter;
    
    if (viewModelName.length) {
        
        Class viewModelClass = NSClassFromString(viewModelName);
        
        if (Hy_ProtocolAndSelector(viewModelClass, @protocol(HyViewModelProtocol), @selector(viewModelWithParameter:))) {
            
            id<HyViewModelProtocol> viewModel = [viewModelClass viewModelWithParameter:parameter];
            controller.viewModel = viewModel;
            viewModel.viewModelController = controller;

            if (Hy_ProtocolAndSelector(viewModel, @protocol(HyViewModelProtocol), @selector(viewModelLoad))) {
                
                if (Hy_ProtocolAndSelector(controller, @protocol(HyViewControllerProtocol), @selector(viewModelWillLoad))) {
                    [controller viewModelWillLoad];
                }
                
                [viewModel viewModelLoad];
                
                controller.hy_viewWillAppearBlock = ^(UIViewController * _Nonnull _self, BOOL animated, BOOL firstLoad) {
                    if (firstLoad) {
                        if (Hy_ProtocolAndSelector(_self, @protocol(HyViewControllerProtocol), @selector(viewModelDidLoad))) {
                            [(UIViewController<HyViewControllerProtocol> *)_self viewModelDidLoad];
                        }
                    }
                };
            }
        }
    }
    return controller;
}

+ (UIViewController<HyViewControllerProtocol> *)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
                                                 parameter:(NSDictionary *_Nullable)parameter
                                                  animated:(BOOL)flag
                                                                         completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion{
    return
    [self pushViewControllerWithName:NSStringFromClass(self)
                       viewModelName:viewModelName
                           parameter:parameter
                            animated:flag
                          completion:completion];
}

+ (UIViewController<HyViewControllerProtocol> *)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                                parameter:(NSDictionary *_Nullable)parameter
                                                 animated:(BOOL)flag
                                                                            completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion {
    return
    [self presentViewControllerWithName:NSStringFromClass(self)
                          viewModelName:viewModelName
                              parameter:parameter
                               animated:flag
                             completion:completion];
}

- (void)viewModelWillLoad {}
- (void)viewModelDidLoad {}
- (void)hy_viewDidLoad {self.view.backgroundColor = UIColor.whiteColor;}
- (void)popFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}
- (void)dissmissFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}

@end
