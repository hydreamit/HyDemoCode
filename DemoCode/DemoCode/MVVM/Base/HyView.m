//
//  HyView.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyView.h"
#import "NSObject+HyProtocol.h"

@interface HyView ()
@property (nonatomic,strong) id viewModel;
@property (nonatomic,strong) id parameter;
@end


@implementation HyView

+ (instancetype)viewWithFrame:(CGRect)frame
                    viewModel:(id)viewModel
                    parameter:(id)parameter {
    
    HyView *view = [[self alloc] initWithFrame:frame];
    view.viewModel = viewModel;
    view.parameter = parameter;
    [view viewLoad];
    return view;
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

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
