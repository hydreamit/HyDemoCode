//
//  HyViewModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import "HyViewControllerJumpProtocol.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReloadViewBlock)(id _Nullable parameter);
@protocol HyViewControllerProtocol, HyModelProtocol;
@protocol HyViewModelProtocol <NSObject>
@optional
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) NSObject<HyModelProtocol> *model;
@property (nonatomic,readonly) UINavigationController *viewModelNavigationController;
@property (nonatomic,weak) UIViewController<HyViewControllerProtocol> *viewModelController;

- (void)viewModelLoad;

- (void)addReloadViewBlock:(ReloadViewBlock)block;
- (void)reloadViewWithParameter:(id _Nullable)parameter;

- (void)configRequestIsGet:(BOOL)isGet
                       url:(NSString *(^)(id _Nullable input))url
                 parameter:(NSDictionary *(^_Nullable)(id _Nullable input))parameter
               dataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *response))dataHandler;

- (void)requestDataWithInput:(id _Nullable)input;

- (void)requestSuccessHandler:(void (^)(id input,
                                        NSObject<HyModelProtocol> *model))successHandler
               failureHandler:(void (^)(id input,
                                        NSError *error))failureHandler;
@end


@protocol HyViewModelFactoryProtocol <NSObject>
@optional
+ (NSObject<HyViewModelProtocol> *)viewModelWithParameter:(nullable NSDictionary *)parameter;
@end

NS_ASSUME_NONNULL_END
