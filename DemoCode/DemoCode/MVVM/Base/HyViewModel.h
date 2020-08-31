//
//  HyViewModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewModelProtocol.h"
#import "HyViewProtocol.h"
#import "RACCommand+HyExtension.h"

NS_ASSUME_NONNULL_BEGIN

#define isKey(_key) [key isEqualToString:_key]

@interface HyViewModel : NSObject <HyViewModelProtocol, HyViewInvokerProtocol>

#pragma mark - 子类重写
- (void)actionWithInput:(id _Nullable)input forKey:(NSString *)key;

- (RACCommand *)commandForKey:(NSString *)key;
- (RACSignal *)commandEnabledSignalForKey:(NSString *)key;
- (RACSignal *)commandSignalWithInput:(id _Nullable)input forKey:(NSString *)key;
- (void)commandInputHandlerWithInput:(id _Nullable)input forkey:(NSString *)key;
- (nullable id)handleInput:(id _Nullable)input forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
