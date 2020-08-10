//
//  HyModel_RAC.m
//  DemoCode
//
//  Created by ben on 2020/7/31.
//  Copyright © 2020 Hy. All rights reserved.
//

#import "HyModel_RAC.h"
#import "HyModelParser.h"


@interface RequestConfigure_RAC()
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) id input;
@end
@implementation RequestConfigure_RAC
@end


@implementation HyModel_RAC

- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))requestDataEnabledSignal {
    return ^(NSString *type) {
        return hy_signalWithValue(@YES);
    };
}

- (typeof(RACSignal *(^)(id _Nonnull))  _Nonnull (^)(NSString * _Nonnull))requestDataSignal {
    @weakify(self);
    return ^(NSString *type){
        return ^RACSignal *(id input){
            @strongify(self);
            return [self requestSignalWithType:type input:input];
        };
    };
}

- (RACSignal *)requestSignalWithType:(NSString *)type input:(id)input {
    
    RequestConfigure_RAC *configure = RequestConfigure_RAC.new;
    configure.type = type;
    configure.input = input;
    [self configReuestConfigure:configure];
    
    if (configure.isGet) {
        return
        [RACSignal signalGetShowHUD:valueBlock(configure.showHUD)
                              cache:valueBlock(configure.cache)
                                url:valueBlock(configure.url)
                          parameter:valueBlock(configure.parameter)
                       handleSignal:configure.signalSubscriber];
        
    } else {
        return
        [RACSignal signalGetShowHUD:valueBlock(configure.showHUD)
                              cache:valueBlock(configure.cache)
                                url:valueBlock(configure.url)
                          parameter:valueBlock(configure.parameter)
                       handleSignal:configure.signalSubscriber];
    }
}

- (void)configReuestConfigure:(RequestConfigure_RAC *)configure {}

@end
