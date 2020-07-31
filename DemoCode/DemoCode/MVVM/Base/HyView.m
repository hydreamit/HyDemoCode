//
//  HyView.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyView.h"
#import "NSObject+HyProtocol.h"

@implementation HyView
@synthesize parameter = _parameter;

+ (instancetype)viewWithFrame:(CGRect)frame
                    viewModel:(id<HyViewModelProtocol>)viewModel
                    parameter:(id)parameter {
    
    UIView<HyViewProtocol> *view = [[self alloc] initWithFrame:frame];
    view.viewModel = viewModel;
    view.parameter = parameter;
    [view viewLoad];
    return (id)view;
}

- (void)viewLoad {}

- (id<HyViewDataProtocol>)dataProvider {
    if (Hy_ProtocolAndSelector(self.viewModel, @protocol(HyViewInvokerProtocol),@selector(viewDataProviderForClassString:))) {
        return [self.viewModel viewDataProviderForClassString:NSStringFromClass(self.class)];
    }
    return nil;
}

- (id<HyViewEventProtocol>)eventHandler {
    if (Hy_ProtocolAndSelector(self.viewModel, @protocol(HyViewInvokerProtocol),@selector(viewEventHandlerForClassString:))) {
        return [self.viewModel viewEventHandlerForClassString:NSStringFromClass(self.class)];
    }
    return nil;
}

@end
