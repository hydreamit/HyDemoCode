//
//  HyViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


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


@protocol HyViewModelProtocol;
@protocol HyViewProtocol <NSObject>
@optional
+ (instancetype)viewWithFrame:(CGRect)frame
                    viewModel:(nullable id<HyViewModelProtocol>)viewModel
                    parameter:(nullable id)parameter;

@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,strong) id<HyViewModelProtocol> viewModel;
@property (nonatomic,weak,readonly) id<HyViewDataProtocol> dataProvider;
@property (nonatomic,weak,readonly) id<HyViewEventProtocol> eventHandler;

- (void)viewLoad;
@end




NS_ASSUME_NONNULL_END
