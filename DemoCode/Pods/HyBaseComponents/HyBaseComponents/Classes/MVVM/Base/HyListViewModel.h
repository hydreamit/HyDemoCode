//
//  HyListViewModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/21.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyViewModel.h"
#import "HyListViewModelProtocol.h"
#import "HyListViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyListViewModel : HyViewModel <HyListViewModelProtocol, HyListViewInvokerProtocol>

- (void)listActionWithInput:(id)input type:(HyListActionType)type  forKey:(NSString *)key;

- (RACCommand *)listCommandForKey:(NSString *)key;
- (RACSignal *)listCommandEnabledSignalForKey:(NSString *)key;


- (RACSignal *)listCommandSignalWithInput:(id _Nullable)input type:(HyListActionType)type forKey:(NSString *)key;
- (void)listCommandInputHandlerWithInput:(id _Nullable)input type:(HyListActionType)type forkey:(NSString *)key;
- (nullable id)handleListInput:(id _Nullable)input type:(HyListActionType)type forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
