//
//  HyBaseView.m
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyBaseView.h"
#import "NSObject+HyProtocol.h"

@interface HyBaseView ()
@property (nonatomic,strong) id viewModel;
@property (nonatomic,strong) id parameter;
@end


@implementation HyBaseView

//+ (instancetype)viewWithFrame:(CGRect)frame
//                    viewModel:(id)viewModel
//                    parameter:(id)parameter {
//    
//    HyBaseView *view = [[self alloc] initWithFrame:frame];
//    view.viewModel = viewModel;
//    view.parameter = parameter;
//    [view viewLoad];
//    return view;
//}
//
//- (void)viewLoad {}
//
//- (id<HyViewDataProtocol>)dataProvider {
//    if (Hy_ProtocolAndSelector(self.viewModel, @protocol(HyViewInvokerProtocol),@selector(viewDataProviderForClassString:))) {
//        return [self.viewModel viewDataProviderForClassString:NSStringFromClass(self.class)];
//    }
//    return nil;
//}
//
//- (id<HyViewEventProtocol>)eventHandler {
//    if (Hy_ProtocolAndSelector(self.viewModel, @protocol(HyViewInvokerProtocol),@selector(viewEventHandlerForClassString:))) {
//        return [self.viewModel viewEventHandlerForClassString:NSStringFromClass(self.class)];
//    }
//    return nil;
//}

@end
