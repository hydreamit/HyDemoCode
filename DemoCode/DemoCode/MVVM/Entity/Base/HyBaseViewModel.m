//
//  HyBaseViewModel.m
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyModelParser.h"
#import "HyBaseViewModel.h"
#import "HyModelBaseProtocol.h"
#import "HyViewControllerBaseProtocol.h"
#import "HyBaseModel.h"
#import "NSObject+HyProtocol.h"
#import "HyViewBaseProtocol.h"


@interface HyBaseViewModel ()
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id<HyModelBaseProtocol> model;
@property (nonatomic,weak) UIViewController<HyViewControllerBaseProtocol> *viewModelController;
@end


@implementation HyBaseViewModel

+ (instancetype)viewModelWithParameter:(NSDictionary *)parameter {
    
    HyBaseViewModel *viewModel = [[self alloc] init];
    viewModel.parameter = parameter;
    [viewModel hy_modelSetWithJSON:parameter];
    return viewModel;
}

- (void)viewModelLoad {}

- (id<HyModelBaseProtocol>)model {
    if (!_model) {
        Class<HyModelBaseProtocol> cls = getObjcectPropertyClass([self class], "model");
        if (cls == NULL) {
            cls = self.class;
        }
        if (Hy_ProtocolAndSelector(cls, @protocol(HyModelBaseProtocol), @selector(modelWithParameter:))) {
            _model = (id)[cls modelWithParameter:self.parameter];
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

#pragma mark - HyViewInvokerProtocol
- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString {
    return nil;
}

- (id<HyViewEventProtocol>)viewEventHandlerForClassString:(NSString *)classString {
    return nil;
}

@end
