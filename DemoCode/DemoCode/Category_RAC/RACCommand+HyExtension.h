//
//  RACCommand+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "RACSignal+HyExtension.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^_Nullable HyNetworkCommandSuccessSubscribeBlock)(id input, id<HyNetworkSuccessProtocol> successObject, id<RACSubscriber> subscriber);
typedef void (^_Nullable HyNetworkCommandFailureSubscribeBlock)(id input, id<HyNetworkFailureProtocol> failureObject, id<RACSubscriber> subscriber);

@interface RACCommand (HyExtension)

@property (nonatomic,copy,readonly) void(^executeWithInputBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(id))(^executeWithInputHandlerBlock)(id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^executeWithVoidBlock)(id input);
@property (nonatomic,copy,readonly) typeof(void(^)(void))(^executeWithVoidHandlerBlock)(id(^_Nullable)(void));

@property (nonatomic,copy,readonly) RACSignal *(^execute)(id _Nullable input);
@property (nonatomic,copy,readonly) RACSignal *(^executeFromSignal)(RACSignal *signal, id(^_Nullable)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^executeToSignal)(id input, RACSignal *(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^executeFromToSignal)(RACSignal *signal, id(^_Nullable)(id value), RACSignal *(^)(id value));

@property (nonatomic,strong,readonly) RACSignal *signal;
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeNext)(void (^)(id value));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeError)(void (^)(NSError *error));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeCompleted)(void (^)(id value));
@property (nonatomic,copy,readonly) NSArray<RACDisposable *> *(^subscribeAll)(void (^_Nullable)(id value), void (^_Nullable)(NSError *error), void (^_Nullable)(id value));

@end



CG_INLINE RACCommand *
hy_command(RACSignal<NSNumber *> * _Nullable enabledSignal, void(^_Nullable inputHandler)(id _Nullable input), RACSignal *(^_Nullable signalBlock)(id _Nullable value)) {
    RACSignal *enabledS = enabledSignal ?: hy_signalWithValue(@YES);
    return [[RACCommand alloc] initWithEnabled:enabledS signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        !inputHandler ?: inputHandler(input);
        return (signalBlock ? signalBlock(input) : nil) ?: hy_signalWithValue(input);
    }];
}

CG_INLINE RACCommand *
hy_commandWithAction(void(^block)(id input)) {
    return hy_command(nil, block, nil);
}

CG_INLINE RACCommand *
hy_commandWithEnabledAction(RACSignal<NSNumber *> *signal, void(^block)(id input)) {
    return hy_command(signal, block, nil);
}

CG_INLINE RACCommand *
hy_commandWithSignal(RACSignal *(^block)(id input)) {
    return hy_command(nil, nil, block);
}

CG_INLINE RACCommand *
hy_commandWithEnabledSignal(RACSignal<NSNumber *> *signal, RACSignal *(^block)(id input)) {
    return hy_command(signal, nil , block);
}

CG_INLINE HyNetworkSignalSuccessSubscribeBlock
networkCommandSuccessSubscribe(id input, HyNetworkCommandSuccessSubscribeBlock block) {
    return !block  ? nil :
    ^(id<HyNetworkSuccessProtocol> successObject, id<RACSubscriber> subscriber) {
        block(input, successObject, subscriber);
    };
}

CG_INLINE HyNetworkSignalFailureSubscribeBlock
networkCommandFailureSubscribe(id input, HyNetworkCommandFailureSubscribeBlock block) {
    return !block  ? nil :
    ^(id<HyNetworkFailureProtocol> failureObject, id<RACSubscriber> subscriber) {
        block(input, failureObject, subscriber);
    };
}

CG_INLINE RACCommand *
hy_getCommand(BOOL(^_Nullable showHUD)(id _Nullable input),
              BOOL(^_Nullable cache)(id _Nullable input),
              NSString *(^_Nullable url)(id _Nullable input),
              NSDictionary *(^_Nullable parameter)(id _Nullable input),
              HyNetworkCommandSuccessSubscribeBlock sBlock,
              HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_getSiganl(showHUD ? showHUD(input) : YES,
                            cache ? cache(input) : NO,
                            url ? url(input) : @"",
                            parameter ? parameter(input) : input,
                            networkCommandSuccessSubscribe(input, sBlock),
                            networkCommandFailureSubscribe(input, fBlock));
    });
};

CG_INLINE RACCommand *
hy_getEnabledCommand(RACSignal<NSNumber *> *enabledSignal,
                     BOOL(^_Nullable showHUD)(id _Nullable input),
                     BOOL(^_Nullable cache)(id _Nullable input),
                     NSString *(^_Nullable url)(id _Nullable input),
                     NSDictionary *(^_Nullable parameter)(id _Nullable input),
                     HyNetworkCommandSuccessSubscribeBlock sBlock,
                     HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_getSiganl(showHUD ? showHUD(input) : YES,
                            cache ? cache(input) : NO,
                            url ? url(input) : @"",
                            parameter ? parameter(input) : input,
                            networkCommandSuccessSubscribe(input, sBlock),
                            networkCommandFailureSubscribe(input, fBlock));
    });
};

CG_INLINE RACCommand *
hy_postCommand(BOOL(^_Nullable showHUD)(id _Nullable input),
              BOOL(^_Nullable cache)(id _Nullable input),
              NSString *(^_Nullable url)(id _Nullable input),
              NSDictionary *(^_Nullable parameter)(id _Nullable input),
              HyNetworkCommandSuccessSubscribeBlock sBlock,
              HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_postSiganl(showHUD ? showHUD(input) : YES,
                            cache ? cache(input) : NO,
                            url ? url(input) : @"",
                            parameter ? parameter(input) : input,
                            networkCommandSuccessSubscribe(input, sBlock),
                            networkCommandFailureSubscribe(input, fBlock));
    });
};

CG_INLINE RACCommand *
hy_postEnabledCommand(RACSignal<NSNumber *> *enabledSignal,
                     BOOL(^_Nullable showHUD)(id _Nullable input),
                     BOOL(^_Nullable cache)(id _Nullable input),
                     NSString *(^_Nullable url)(id _Nullable input),
                     NSDictionary *(^_Nullable parameter)(id _Nullable input),
                     HyNetworkCommandSuccessSubscribeBlock sBlock,
                     HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_postSiganl(showHUD ? showHUD(input) : YES,
                            cache ? cache(input) : NO,
                            url ? url(input) : @"",
                            parameter ? parameter(input) : input,
                            networkCommandSuccessSubscribe(input, sBlock),
                            networkCommandFailureSubscribe(input, fBlock));
    });
};


CG_INLINE RACCommand *
hy_postFormDataCommand(BOOL(^_Nullable showHUD)(id _Nullable input),
                       BOOL(^_Nullable cache)(id _Nullable input),
                       NSString *(^_Nullable url)(id _Nullable input),
                       NSDictionary *(^_Nullable parameter)(id _Nullable input),
                       HyNetworkFormDataBlock formDataBlock,
                       HyNetworkCommandSuccessSubscribeBlock sBlock,
                       HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithSignal(^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_postFormDataSiganl(showHUD ? showHUD(input) : YES,
                                     cache ? cache(input) : NO,
                                     url ? url(input) : @"",
                                     parameter ? parameter(input) : input,
                                     formDataBlock,
                                     networkCommandSuccessSubscribe(input, sBlock),
                                     networkCommandFailureSubscribe(input, fBlock));
    });
};

CG_INLINE RACCommand *
hy_postFormDataEnabledCommand(RACSignal<NSNumber *> *enabledSignal,
                              BOOL(^_Nullable showHUD)(id _Nullable input),
                              BOOL(^_Nullable cache)(id _Nullable input),
                              NSString *(^_Nullable url)(id _Nullable input),
                              NSDictionary *(^_Nullable parameter)(id _Nullable input),
                              HyNetworkFormDataBlock formDataBlock,
                              HyNetworkCommandSuccessSubscribeBlock sBlock,
                              HyNetworkCommandFailureSubscribeBlock fBlock) {
    return hy_commandWithEnabledSignal(enabledSignal, ^RACSignal * _Nonnull(id  _Nonnull input) {
        return hy_postFormDataSiganl(showHUD ? showHUD(input) : YES,
                                     cache ? cache(input) : NO,
                                     url ? url(input) : @"",
                                     parameter ? parameter(input) : input,
                                     formDataBlock,
                                     networkCommandSuccessSubscribe(input, sBlock),
                                     networkCommandFailureSubscribe(input, fBlock));
    });
};


#define hy_popCommand(_enabledSignal, _viewControllerName, _parameter, _animated) \
({ \
    [[RACCommand alloc] initWithEnabled:_enabledSignal ?: [RACSignal return:@YES] \
                            signalBlock:^RACSignal * _Nonnull(id  _Nullable input) { \
        return hy_popSignal(_viewControllerName, _parameter, _animated); \
    }]; \
})

#define hy_pushCommand(_enabledSignal, _viewControllerName, _viewModelName, _parameter, _animated) \
({ \
    [[RACCommand alloc] initWithEnabled:_enabledSignal ?: [RACSignal return:@YES] \
                            signalBlock:^RACSignal * _Nonnull(id  _Nullable input) { \
        return hy_pushSignal(_viewControllerName, _viewModelName, _parameter, _animated); \
    }]; \
})

#define hy_presentCommand(_enabledSignal, _viewControllerName, _viewModelName, _parameter, _animated) \
({ \
    [[RACCommand alloc] initWithEnabled:_enabledSignal ?: [RACSignal return:@YES] \
                                       signalBlock:^RACSignal * _Nonnull(id  _Nullable input) { \
        return hy_presentSignal(_viewControllerName, _viewModelName, _parameter, _animated); \
    }]; \
})

#define hy_dismissCommand(enabledSignal, _parameter, _animated) \
({ \
    [[RACCommand alloc] initWithEnabled:_enabledSignal ?: [RACSignal return:@YES] \
                            signalBlock:^RACSignal * _Nonnull(id  _Nullable input) { \
         return hy_dismissSignal(_parameter, _animated); \
    }]; \
})


NS_ASSUME_NONNULL_END
