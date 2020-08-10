//
//  HyModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyModelProtocol.h"
#import "HyViewModelProtocol.h"
#import "HyNetworkManager.h"
#import "RACSignal+HyExtension.h"
#import "HyEntity.h"


NS_ASSUME_NONNULL_BEGIN


@interface RequestConfigure : NSObject
@property (nonatomic,copy,readonly,nullable) NSString *key;
@property (nonatomic,strong,readonly) id _Nonnull input;
@property (nonatomic,assign) BOOL showHUD;
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,assign) BOOL cache;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,copy) NSArray *(^dataHandlerConfigure)(NSDictionary *response);
#pragma mark - RAC
@property (nonatomic,copy) HyNetworkSignalSuccessSubscribeBlock successSubscribeBlock;
@property (nonatomic,copy) HyNetworkSignalFailureSubscribeBlock failureSubscribeBlock;
@end


@interface HyModel : NSObject <HyModelProtocol>

- (void)configReuestConfigure:(RequestConfigure *)configure;

#pragma mark -
- (void)actionWithInput:(NSString *)input forKey:(NSString *)key;
- (void)handleSuccess:(id<HyNetworkSuccessProtocol>)successObject requestConfigure:(RequestConfigure *)configure;
- (void)handleFailure:(id<HyNetworkFailureProtocol>)failureObject requestConfigure:(RequestConfigure *)configure;


#pragma mark - 子类重写
- (RACSignal<NSNumber *> *)enabledSignalForKey:(NSString *)key;
- (RACSignal *)signalWithInput:(id _Nullable)input forKey:(NSString *)key;

@end


NS_ASSUME_NONNULL_END
