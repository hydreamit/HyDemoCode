//
//  HyViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewModel.h"
#import "HyModelParser.h"
#import "NSObject+HyProtocol.h"
#import "HyNetworkManager.h"
#import "NSObject+HyProtocol.h"
#import <HyCategoriess/HyCategories.h>


@interface HyViewModel ()
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,copy) NSString *(^urlBlock)(id);
@property (nonatomic,copy) NSDictionary *(^parameterBlock)(id);
@property (nonatomic,copy) NSArray<id> *(^dataHandler)(id);
@property (nonatomic,copy) void(^successHandler)(id,
id<HyModelProtocol>);
@property (nonatomic,copy) void(^failureHandler)(id,
NSError *);
@property (nonatomic,strong) NSMutableArray<ReloadViewBlock> *reloadViewBlockArray;
@end


@implementation HyViewModel
@synthesize parameter = _parameter, model = _model;

+ (id<HyViewModelProtocol>)viewModelWithParameter:(NSDictionary *)parameter {
    
    id<HyViewModelProtocol> viewModel = [[self alloc] init];
    viewModel.parameter = parameter;
    [((NSObject<HyViewModelProtocol> *)viewModel) hy_modelSetWithJSON:parameter];
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
                       id<HyModelProtocol> model))successHandler
               failureHandler:(void (^)(id input,
                         NSError *error))failureHandler {
 
    self.successHandler = [successHandler copy];
    self.failureHandler = [failureHandler copy];
}

- (void)requestDataWithInput:(id _Nullable)input {
    
    NSString *url = self.urlBlock ? self.urlBlock(input) : @"";
    NSDictionary *parameter = self.parameterBlock ? self.parameterBlock(input) : input;
    
    void (^success)(id<HyNetworkSuccessProtocol>) =
    ^(id<HyNetworkSuccessProtocol>  _Nullable successObject){
        [self _handleResponse:successObject.response input:input];
    };
    
    void (^failure)(id<HyNetworkFailureProtocol>) =
    ^(id<HyNetworkFailureProtocol>  _Nullable failureObject){
        !self.failureHandler ?: self.failureHandler(input, failureObject.error);
    };
    
    if (self.isGet) {
        [[HyNetworkManager.network getShowHUD:YES
                                        cache:NO
                                          url:url
                                    parameter:parameter
                                 successBlock:success
                                 failureBlock:failure] resume];
    } else {
        [[HyNetworkManager.network postShowHUD:YES
                                         cache:NO
                                           url:url
                                     parameter:parameter
                                  successBlock:success
                                  failureBlock:failure] resume];
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

- (id<HyModelProtocol>)model {
    if (!_model) {
        Class<HyModelFactoryProtocol> cls = getObjcectPropertyClass([self class], "model");
        if (cls == NULL) {
            cls = HyModel.class;
        }
        if (Hy_ProtocolAndSelector(cls, @protocol(HyModelFactoryProtocol), @selector(modelWithParameter:))) {
            _model = (id<HyModelProtocol>)[cls modelWithParameter:self.parameter];
        }
    }
    return _model;
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
