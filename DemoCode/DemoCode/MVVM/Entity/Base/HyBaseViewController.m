//
//  HyBaseViewController.m
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyBaseViewController.h"
#import "HyViewModelBaseProtocol.h"
#import "NSObject+HyProtocol.h"
#import <objc/message.h>
#import <HyCategoriess/HyCategories.h>


@interface HyBaseViewController ()
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id<HyViewModelBaseProtocol> viewModel;
@end


@implementation HyBaseViewController

+ (instancetype)viewControllerWithViewModelName:(NSString *)viewModelName
                                      parameter:(NSDictionary *)parameter {
    
    HyBaseViewController *controller = [[self alloc] init];
    controller.parameter = parameter;
    if (viewModelName.length) {
        Class viewModelClass = NSClassFromString(viewModelName);
        if (Hy_ProtocolAndSelector(viewModelClass,
                                   @protocol(HyViewModelBaseProtocol),
                                   @selector(viewModelWithParameter:))) {
            
            id<HyViewModelBaseProtocol> viewModel = [viewModelClass viewModelWithParameter:parameter];
            controller.viewModel = viewModel;
            if ([viewModel respondsToSelector:sel_registerName("setViewModelController:")]) {
                ((void(*)(id, SEL, id))objc_msgSend)(viewModel, sel_registerName("setViewModelController:"), controller);
            }
            if (Hy_ProtocolAndSelector(viewModel,
                                       @protocol(HyViewModelBaseProtocol),
                                       @selector(viewModelLoad))) {
                [controller viewModelWillLoad];
                [viewModel viewModelLoad];
                controller.hy_viewWillAppearBlock = ^(UIViewController * _Nonnull _self, BOOL animated, BOOL firstLoad) {
                    if (firstLoad) {
                         [(UIViewController<HyViewControllerBaseProtocol> *)_self viewModelDidLoad];
                    }
                };
            }
        }
    }
    return controller;
}

//+ (instancetype)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
//                                                 parameter:(NSDictionary *_Nullable)parameter
//                                                  animated:(BOOL)flag
//                                                completion:(void(^_Nullable)(UIViewController<HyViewControllerRACProtocol> *controller))completion{
//    return
//    [self pushViewControllerWithName:NSStringFromClass(self)
//                       viewModelName:viewModelName
//                           parameter:parameter
//                            animated:flag
//                          completion:completion];
//}
//
//+ (instancetype)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
//                                             parameter:(NSDictionary *_Nullable)parameter
//                                              animated:(BOOL)flag
//                                            completion:(void(^_Nullable)(UIViewController<HyViewControllerRACProtocol> *controller))completion {
//    return
//    [self presentViewControllerWithName:NSStringFromClass(self)
//                          viewModelName:viewModelName
//                              parameter:parameter
//                               animated:flag
//                             completion:completion];
//}

- (void)viewModelWillLoad {}
- (void)viewModelDidLoad {}
- (void)hy_viewDidLoad {self.view.backgroundColor = UIColor.whiteColor;}
- (void)popFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}
- (void)dissmissFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}

@end
