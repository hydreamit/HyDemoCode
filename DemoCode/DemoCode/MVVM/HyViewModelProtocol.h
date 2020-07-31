//
//  HyViewModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "HyViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReloadViewBlock)(id _Nullable parameter);
@protocol HyViewControllerProtocol, HyModelProtocol, HyViewProtocol;
@protocol HyViewModelProtocol <NSObject>
@optional

+ (instancetype)viewModelWithParameter:(nullable NSDictionary *)parameter;

@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id<HyModelProtocol> model;
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

- (void)requestSuccessHandler:(void (^_Nullable)(id input,
                                        id<HyModelProtocol> model))successHandler
               failureHandler:(void (^_Nullable)(id input,
                                        NSError *error))failureHandler;

@end


NS_ASSUME_NONNULL_END
