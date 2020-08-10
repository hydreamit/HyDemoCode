//
//  HyViewBaseProtocol.h
//  DemoCode
//
//  Created by ben on 2020/8/3.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewControllerJumpProtocol.h"

NS_ASSUME_NONNULL_BEGIN


//@protocol HyViewDataProtocol <NSObject>
//@end
//@protocol HyViewEventProtocol <NSObject>
//@end
//@protocol HyViewInvokerProtocol <NSObject>
//@optional;
//- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString;
//- (id<HyViewEventProtocol>)viewEventHandlerForClassString:(NSString *)classString;
//@end


@protocol HyViewModelBaseProtocol;
@protocol HyViewBaseProtocol <HyViewControllerJumpProtocol>
@optional
//+ (instancetype)viewWithFrame:(CGRect)frame
//                    viewModel:(nullable id<HyViewModelBaseProtocol>)viewModel
//                    parameter:(nullable id)parameter;
//
//@property (nonatomic,strong,readonly) NSDictionary *parameter;
//@property (nonatomic,strong,readonly) id<HyViewModelBaseProtocol> viewModel;
//@property (nonatomic,weak,readonly) id<HyViewDataProtocol> dataProvider;
//@property (nonatomic,weak,readonly) id<HyViewEventProtocol> eventHandler;
//
//- (void)viewLoad;

@end


NS_ASSUME_NONNULL_END
