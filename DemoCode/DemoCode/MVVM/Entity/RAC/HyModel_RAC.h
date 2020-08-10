//
//  HyModel_RAC.h
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACSignal+HyExtension.h"
#import "RACSignal+Network.h"
#import "HyModelRACProtocol.h"
#import "HyBaseModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface RequestConfigure_RAC : NSObject
@property (nonatomic,copy,readonly,nullable) NSString *type;
@property (nonatomic,strong,readonly) id _Nonnull input;
@property (nonatomic,assign) BOOL showHUD;
@property (nonatomic,assign) BOOL isGet;
@property (nonatomic,assign) BOOL cache;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,strong) NSDictionary *parameter;
@property (nonatomic,copy) RequestSignalBlock signalSubscriber;
@end


@interface HyModel_RAC : HyBaseModel <HyModelRACProtocol>

- (RACSignal *)requestSignalWithType:(NSString *)type input:(id)input;
- (void)configReuestConfigure:(RequestConfigure_RAC *)configure;

@end

NS_ASSUME_NONNULL_END
