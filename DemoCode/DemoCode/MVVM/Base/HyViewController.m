//
//  HyViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewController.h"
#import "NSObject+HyProtocol.h"
#import <HyCategoriess/HyCategories.h>

@interface HyViewController ()
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id viewModel;
@end

@implementation HyViewController

+ (instancetype)viewControllerWithViewModelName:(NSString *)viewModelName
                                      parameter:(NSDictionary *)parameter {
    
    HyViewController *controller = [[self alloc] init];
    controller.parameter = parameter;
    if (viewModelName.length) {
        
        Class viewModelClass = NSClassFromString(viewModelName);
        
        if (Hy_ProtocolAndSelector(viewModelClass,
                                   @protocol(HyViewModelProtocol),
                                   @selector(viewModelWithParameter:))) {
            
            controller.hy_viewDidLoadBlock = ^(UIViewController * _Nonnull _self) {
                
                HyViewController *vc = (id)_self;
                id<HyViewModelProtocol> viewModel = [viewModelClass viewModelWithParameter:parameter];
                vc.viewModel = viewModel;
                if ([viewModel respondsToSelector:sel_registerName("setViewModelController:")]) {
                    ((void(*)(id, SEL, id))objc_msgSend)(viewModel, sel_registerName("setViewModelController:"), vc);
                }
                if (Hy_ProtocolAndSelector(viewModel,
                                           @protocol(HyViewModelProtocol),
                                           @selector(viewModelLoad))) {
                    [vc viewModelWillLoad];
                    [viewModel viewModelLoad];
                }
            };
            
            controller.hy_viewWillAppearBlock = ^(UIViewController * _Nonnull _self, BOOL animated, BOOL firstLoad) {
               if (firstLoad) {
                    [(UIViewController<HyViewControllerProtocol> *)_self viewModelDidLoad];
               }
           };
        }
    }
    return controller;
}

+ (instancetype)pushViewControllerWithViewModelName:(NSString *_Nullable)viewModelName
                                                 parameter:(NSDictionary *_Nullable)parameter
                                                  animated:(BOOL)flag
                                                completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion{
    return (id)
    [self pushViewControllerWithName:NSStringFromClass(self)
                       viewModelName:viewModelName
                           parameter:parameter
                            animated:flag
                          completion:completion];
}

+ (instancetype)presentViewControllerWithViewModelName:(NSString * _Nullable)viewModelName
                                             parameter:(NSDictionary *_Nullable)parameter
                                              animated:(BOOL)flag
                                            completion:(void(^_Nullable)(UIViewController<HyViewControllerProtocol> *controller))completion {
    return (id)
    [self presentViewControllerWithName:NSStringFromClass(self)
                          viewModelName:viewModelName
                              parameter:parameter
                               animated:flag
                             completion:completion];
}

- (void)viewModelWillLoad {}
- (void)viewModelDidLoad {}
- (void)hy_viewDidLoad {[super hy_viewDidLoad]; self.view.backgroundColor = UIColor.whiteColor;}
- (void)popFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}
- (void)dissmissFromViewController:(NSString *)controllerName parameter:(NSDictionary *)parameter {}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
