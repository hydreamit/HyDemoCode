//
//  HyTabBarController.m
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTabBarController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyMVVM.h"
#import "HyViewControllerProtocol.h"
#import "HyNewsViewController.h"
#import "HyRecommendViewController.h"
#import "HyMeViewController.h"


@implementation HyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self configTabBar];
    [self configChildViewControllers];
}

- (void)configChildViewControllers {
    
    HyNewsViewController *newsVc = (HyNewsViewController *)[HyNewsViewController viewControllerWithViewModelName:@"HyNewsViewModel" parameter:nil];
    HyRecommendViewController *recommendVc = (HyRecommendViewController *)[HyRecommendViewController viewControllerWithViewModelName:@"HyRecommendViewModel" parameter:nil];
    HyMeViewController *meVc = (HyMeViewController *)[HyMeViewController viewControllerWithViewModelName:@"HyMeViewModel" parameter:@{@"account" : @"15888888888"}];
    
    NSArray *array = @[newsVc, recommendVc, meVc];
    NSArray *titles = @[@"资讯", @"精选", @"我的"];
    NSArray *normalImages = @[@"icon_zx_nomal_pgall", @"icon_jx_nomal_pgall", @"icon_w_nomal_pgall"];
    NSArray *selImages = @[@"icon_zx_pressed_pgall", @"icon_jx_pressed_pgall", @"icon_jx_pressed_pgall"];
    
    for (UIViewController<HyViewControllerProtocol> *vc in array) {
        NSInteger index = [array indexOfObject:vc];
        [self hy_addChildViewController:[[UINavigationController alloc] initWithRootViewController:vc]
                                  title:titles[index]
                                  image:normalImages[index]
                          selectedImage:selImages[index]
                            imageInsets:UIEdgeInsetsZero
                          titlePosition:UIOffsetMake(0, -2)];
    }
    
    self.hy_clickItemBlock = ^(UITabBarController * _Nonnull _self, NSInteger index, BOOL isRepeat) {
        if (isRepeat && index != 2) {
            HyVoidMsgSend(((UINavigationController *)_self.viewControllers[index]).hy_rootViewController, sel_registerName("scrollToTop"));
        }
    };
}

- (void)configTabBar {
    
    NSDictionary *normal = @{NSForegroundColorAttributeName : Hy_ColorWithRGB(113, 113, 113)};
    NSDictionary *sel = @{NSForegroundColorAttributeName : Hy_ColorWithRGB(218, 85, 10)};
    if (@available(iOS 13.0, *)){
       UITabBarAppearance *ap = UITabBarAppearance.new;
       ap.stackedLayoutAppearance.normal.titleTextAttributes = normal;
       ap.stackedLayoutAppearance.selected.titleTextAttributes = sel;
       [UITabBar appearance].standardAppearance = ap;
    } else {
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTitleTextAttributes:normal forState:UIControlStateNormal];
        [[UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTitleTextAttributes:sel forState:UIControlStateSelected];
    }
}


@end
