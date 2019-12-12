//
//  HyView.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyView.h"

@implementation HyView
@synthesize parameter = _parameter, viewModel = _viewModel;

+ (UIView<HyViewProtocol> *)viewWithFrame:(CGRect)frame
                                viewModel:(NSObject<HyViewModelProtocol> *)viewModel
                                parameter:(id)parameter {
    
    UIView<HyViewProtocol> *view = [[self alloc] initWithFrame:frame];
    view.viewModel = viewModel;
    view.parameter = parameter;
    [view viewLoad];
    return view;
}

- (void)viewLoad {}

@end
