//
//  HyViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//


#import "HyViewControllerJumpProtocol.h"
#import "HyViewModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyViewDataProtocol <NSObject>
@end
@protocol HyViewEventProtocol <NSObject>
@end
@protocol HyViewInvokerProtocol <NSObject>
@optional;
- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString;
- (id<HyViewEventProtocol>)viewEventHandlerForClassString:(NSString *)classString;
@end


@protocol HyViewProtocol <HyViewControllerJumpProtocol>
@optional
+ (instancetype)viewWithFrame:(CGRect)frame
                    viewModel:(nullable id<HyViewModelProtocol>)viewModel
                    parameter:(nullable id)parameter;

- (void)viewLoad;

@property (nonatomic,strong,readonly) NSDictionary *parameter;
@property (nonatomic,strong,readonly) id<HyViewModelProtocol> viewModel;
@property (nonatomic,weak,readonly) id<HyViewDataProtocol> dataProvider;
@property (nonatomic,weak,readonly) id<HyViewEventProtocol> eventHandler;

@end


NS_ASSUME_NONNULL_END
