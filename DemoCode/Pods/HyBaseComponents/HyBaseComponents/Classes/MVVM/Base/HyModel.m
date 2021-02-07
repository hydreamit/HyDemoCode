//
//  HyModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyModel.h"
#import "NSObject+HyProtocol.h"
#import "HyModelParser.h"
#import "HyTipText.h"

void handleSuccess(id<HyNetworkSuccessProtocol> successObject, RequestConfigure *configure, void(^completion)(id model)) {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id modelData = successObject.response;
        Class<HyModelProtocol> modelClass = HyModel.class;
        if (configure.dataHandlerConfigure) {
            NSArray *array = configure.dataHandlerConfigure(modelData);
            if (array.count) {
                modelData = array.firstObject;
                if (array.count == 2) {
                    Class cls = array.lastObject;
                    if (Hy_ProtocolAndSelector(cls, @protocol(HyModelProtocol), @selector(modelWithParameter:)) ||
                        Hy_ProtocolAndSelector(cls, @protocol(HyEntityProtocol), @selector(entityWithParameter:))) {
                        modelClass = cls;
                    }
                }
            }
        }

        id<HyModelProtocol> model;
        if (Hy_ProtocolAndSelector(modelClass, @protocol(HyModelProtocol), @selector(modelWithParameter:))) {
            model = [modelClass modelWithParameter:modelData];
        } else {
            model = [((Class<HyEntityProtocol>)modelClass) entityWithParameter:modelData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !completion ?: completion(model);
        });
    });
}

@interface RequestConfigure()
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) id input;
@end
@implementation RequestConfigure
@end


@interface HyModel ()
@property (nonatomic,strong) NSDictionary *parameter;
@end


@implementation HyModel
@synthesize actionSuccess = _actionSuccess, actionFailure = _actionFailure;

+ (instancetype)modelWithParameter:(NSDictionary *)parameter {
    HyModel *model = [[self alloc] init];
    model.parameter = parameter;
    [model hy_modelSetWithJSON:parameter];
    [model modelLoad];
    return model;
}

- (void)setModelWithParameter:(nullable NSDictionary *)parameter {
    [self hy_modelSetWithJSON:parameter];
}

- (void)modelLoad {}

- (void (^)(id _Nonnull, NSString * _Nonnull))action {
    @weakify(self);
    return ^(id input, NSString *key){
        @strongify(self);
        [self actionWithInput:input forKey:key];
    };
}

- (void)actionWithInput:(NSString *)input forKey:(NSString *)key {
    
    RequestConfigure *configure = RequestConfigure.new;
    configure.key = key;
    configure.input = input;
    [self configReuestConfigure:configure];
    
    void (^success)(id<HyNetworkSuccessProtocol>) =
    ^(id<HyNetworkSuccessProtocol>  _Nullable successObject){
        [self handleSuccess:successObject requestConfigure:configure];
    };

    void (^failure)(id<HyNetworkFailureProtocol>) =
    ^(id<HyNetworkFailureProtocol>  _Nullable failureObject){
        [self handleFailure:failureObject requestConfigure:configure];
    };

    if (configure.isGet) {
        [HyNetworkManager.network getShowHUD:configure.showHUD
                                       cache:configure.cache
                                         url:configure.url
                                   parameter:configure.parameter
                                successBlock:success
                                failureBlock:failure].resumeAtObjcet(self);
    } else {
        [HyNetworkManager.network postShowHUD:configure.showHUD
                                        cache:configure.cache
                                          url:configure.url
                                    parameter:configure.parameter
                                 successBlock:success
                                 failureBlock:failure].resumeAtObjcet(self);
    }
}

- (void)handleSuccess:(id<HyNetworkSuccessProtocol>)successObject requestConfigure:(RequestConfigure *)configure {
    handleSuccess(successObject, configure, ^(id model) {
        void (^block)(id, id) = self.actionSuccess ? self.actionSuccess(configure.key) : nil;
        !block ?: block(configure.input, model);
    });
}

- (void)handleFailure:(id<HyNetworkFailureProtocol>)failureObject
     requestConfigure:(RequestConfigure *)configure {
    void (^block)(id, id) = self.actionFailure ? self.actionFailure(configure.key) : nil;
    !block ?: block(configure.input, failureObject.error);
}

#pragma mark - RAC
- (RACSignal<NSNumber *> * _Nonnull (^)(NSString * _Nonnull))enabledSignal {
    @weakify(self);
    return ^(NSString *key) {
        @strongify(self);
        return [self enabledSignalForKey:key];
    };
}

- (typeof(RACSignal *(^)(id _Nonnull)) _Nonnull (^)(NSString * _Nonnull))signal {
    @weakify(self);
    return ^(NSString *key){
        return ^RACSignal *(id input){
            @strongify(self);
            return [self signalWithInput:input forKey:key];
        };
    };
}

- (RACSignal<NSNumber *> *)enabledSignalForKey:(NSString *)key {
    return hy_signalWithValue(@YES);
}

- (RACSignal *)signalWithInput:(id _Nullable)input forKey:(NSString *)key {
    
    RequestConfigure *configure = RequestConfigure.new;
    configure.key = key;
    configure.input = input;
    [self configReuestConfigure:configure];
    
    HyNetworkSignalSuccessSubscribeBlock successSubscribeBlock = configure.successSubscribeBlock ?:
    ({
        ^(id<HyNetworkSuccessProtocol>  _Nonnull successObject, id<RACSubscriber>  _Nonnull subscriber) {
            NSString *status= [NSString stringWithFormat:@"%@",successObject.response[@"code"]];
            if (![status isEqualToString:@"200"]) {
                NSString *errorString = [NSString stringWithFormat:@"%@",successObject.response[@"code_desc"]];
                HyTipText.show(nil, errorString, nil);
                [subscriber sendError:nil];
            }else{
                if (configure.dataHandlerConfigure) {
                    handleSuccess(successObject, configure, ^(id model) {
                        [subscriber sendNext:model];
                        [subscriber sendCompleted];
                    });
                } else {
                    [subscriber sendNext:successObject.response[@"ch_msg"]];
                    [subscriber sendCompleted];
                }
            }
        };
    });
    
    if (configure.isGet) {
        return
        hy_getSiganl(configure.showHUD,
                     configure.cache,
                     configure.url,
                     configure.parameter,
                     successSubscribeBlock,
                     configure.failureSubscribeBlock);
    } else {
        return
        hy_postSiganl(configure.showHUD,
                      configure.cache,
                      configure.url,
                      configure.parameter,
                      successSubscribeBlock,
                      configure.failureSubscribeBlock);
    }
}

- (void)configReuestConfigure:(RequestConfigure *)configure {}
//- (void)handleSuccess:(id<HyNetworkSuccessProtocol>)successObject
//     requestConfigure:(RequestConfigure *)configure
//           completion:(void(^)(id))completion {
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        id modelData = successObject.response;
//        Class<HyModelProtocol> modelClass = self.class;
//        if (configure.dataHandlerConfigure) {
//            NSArray *array = configure.dataHandlerConfigure(modelData);
//            if (array.count) {
//                modelData = array.firstObject;
//                if (array.count == 2) {
//                    Class cls = array.lastObject;
//                    if (Hy_ProtocolAndSelector(cls, @protocol(HyModelProtocol), @selector(modelWithParameter:)) ||
//                        Hy_ProtocolAndSelector(cls, @protocol(HyEntityProtocol), @selector(entityWithParameter:))) {
//                        modelClass = cls;
//                    }
//                }
//            }
//        }
//
//        id<HyModelProtocol> model;
//        if (Hy_ProtocolAndSelector(modelClass, @protocol(HyModelProtocol), @selector(modelWithParameter:))) {
//            model = [modelClass modelWithParameter:modelData];
//        } else {
//            model = [((Class<HyEntityProtocol>)modelClass) entityWithParameter:modelData];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !completion ?: completion(model);
//        });
//    });
//}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
