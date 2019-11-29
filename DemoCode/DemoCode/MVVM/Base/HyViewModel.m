//
//  HyViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewModel.h"
#import <MJExtension/MJExtension.h>
#import "NSObject+HyProtocol.h"
#import "HyNetworkManager.h"
#import <HyCategoriess/HyCategories.h>


@interface HyViewModel ()
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,copy) NSString *(^urlBlock)(id);
@property (nonatomic,copy) NSDictionary *(^parameterBlock)(id);
@property (nonatomic,copy) NSArray<id> *(^dataHandler)(id);
@property (nonatomic,copy) void(^successHandler)(id,
NSObject<HyModelProtocol> *);
@property (nonatomic,copy) void(^failureHandler)(id,
NSError *);
@property (nonatomic,strong) NSMutableArray<ReloadViewBlock> *reloadViewBlockArray;
@end


@implementation HyViewModel

+ (NSObject<HyViewModelProtocol> *)viewModelWithParameter:(NSDictionary *)parameter {
    
    NSObject<HyViewModelProtocol> *viewModel = [[self alloc] init];
    viewModel.parameter = parameter;
    viewModel = [viewModel mj_setKeyValues:parameter];
    return viewModel;
}

- (void)viewModelLoad {
    self.isGet = YES;
}

- (void)configRequestIsGet:(BOOL)isGet
                       url:(NSString *(^)(id _Nullable input))url
                 parameter:(NSDictionary *(^_Nullable)(id _Nullable input))parameter
               dataHandler:(NSArray<id> *(^_Nullable)(id _Nullable input, NSDictionary *response))dataHandler {
    
    self.isGet = isGet;
    self.urlBlock = [url copy];
    self.parameterBlock = [parameter copy];
    self.dataHandler = [dataHandler copy];
}

- (void)requestSuccessHandler:(void (^)(id input,
                       NSObject<HyModelProtocol> *model))successHandler
               failureHandler:(void (^)(id input,
                         NSError *error))failureHandler {
 
    self.successHandler = [successHandler copy];
    self.failureHandler = [failureHandler copy];
}

- (void)requestDataWithInput:(id _Nullable)input {
    
    NSString *url = self.urlBlock ? self.urlBlock(input) : @"";
    NSDictionary *parameter = self.parameterBlock ? self.parameterBlock(input) : input;
    if (self.isGet) {
        [HyNetworkManager.network getShowHUD:YES cache:NO url:url parameter:parameter successBlock:^(id  _Nullable response, id<HyNetworkTaskProtocol>  _Nonnull task) {
            [self _handleResponse:response input:input];
        } failureBlock:^(NSError * _Nullable error, id<HyNetworkTaskProtocol>  _Nonnull task) {
            !self.failureHandler ?: self.failureHandler(input, error);
        }];
    } else {
        [HyNetworkManager.network postShowHUD:YES cache:NO url:url parameter:parameter successBlock:^(id  _Nullable response, id<HyNetworkTaskProtocol>  _Nonnull task) {
            [self _handleResponse:response input:input];
        } failureBlock:^(NSError * _Nullable error, id<HyNetworkTaskProtocol>  _Nonnull task) {
            !self.failureHandler ?: self.failureHandler(input, error);
        }];
    }
}

- (void)_handleResponse:(NSDictionary *)response
                  input:(id)input {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id modelData = response;
        Class<HyModelFactoryProtocol> modelClass = HyModel.class;
        
        if (self.dataHandler) {
            NSArray *array = self.dataHandler(response);
            if (array.count) {
                modelData = array.firstObject;
                if (array.count == 2) {
                    Class cls = array.lastObject;
                    if ([cls conformsToProtocol:@protocol(HyModelProtocol)] &&
                        Hy_ProtocolAndSelector(cls, @protocol(HyModelFactoryProtocol), @selector(modelWithParameter:))) {
                        modelClass = cls;
                    }
                }
            }
        }
        self.model = [modelClass modelWithParameter:modelData];
        dispatch_async(dispatch_get_main_queue(), ^{
             !self.successHandler ?: self.successHandler(input, self.model);
        });
    });
}

- (void)setModel:(NSObject<HyModelProtocol> *)model {
    objc_setAssociatedObject(self,
                             @selector(model),
                             model,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject<HyModelProtocol> *)model {
    NSObject<HyModelProtocol> *data = objc_getAssociatedObject(self, _cmd);
    if (data == NULL) {
        data = (NSObject<HyModelProtocol> *)[HyModel modelWithParameter:self.parameter];
        objc_setAssociatedObject(self,
                                 _cmd,
                                 data,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return data;
}

- (void)setViewModelController:(UIViewController<HyViewControllerProtocol> *)viewModelController {
    objc_setAssociatedObject(self,
                             @selector(viewModelController),
                             [NSValue valueWithNonretainedObject:viewModelController],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController<HyViewControllerProtocol> *)viewModelController {
    return ((NSValue *)(objc_getAssociatedObject(self, _cmd))).nonretainedObjectValue;
}

- (UINavigationController *)viewModelNavigationController {
    return self.viewModelController.navigationController;
}


- (void)addReloadViewBlock:(ReloadViewBlock)block {
    if (!block && ![self.reloadViewBlockArray containsObject:block]) {
        [self.reloadViewBlockArray addObject:block];
    }
}

- (NSMutableArray<ReloadViewBlock> *)reloadViewBlockArray {
    if (!_reloadViewBlockArray){
        _reloadViewBlockArray = @[].mutableCopy;
    }
    return _reloadViewBlockArray;
}

- (void)reloadViewWithParameter:(id)parameter {
    for (ReloadViewBlock block in self.reloadViewBlockArray) {
        block(parameter);
    }
}

@end
