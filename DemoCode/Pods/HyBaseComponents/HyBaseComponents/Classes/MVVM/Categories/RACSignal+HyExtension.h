//
//  RACSignal+HyExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <ReactiveObjC/ReactiveObjC.h>
#import "HyViewControllerJumpProtocol.h"
#import "HyMultipartFormDataProtocol.h"
#import "HyNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^_Nullable HyNetworkSignalSuccessSubscribeBlock)(id<HyNetworkSuccessProtocol> successObject, id<RACSubscriber> subscriber);
typedef void (^_Nullable HyNetworkSignalFailureSubscribeBlock)(id<HyNetworkFailureProtocol> failureObject, id<RACSubscriber> subscriber);

@interface RACSignal (HyExtension)<HyViewControllerJumpProtocol>

@property (nonatomic,copy,readonly) RACSignal *(^flattenMap)(RACSignal *(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^map)(id(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^mapReplace)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^filter)(BOOL(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^ignore)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^reduceEach)(RACReduceBlock);
@property (nonatomic,copy,readonly) RACSignal *(^startWith)(id value);
@property (nonatomic,copy,readonly) RACSignal *(^skip)(NSUInteger skipCount);
@property (nonatomic,copy,readonly) RACSignal *(^take)(NSUInteger takeCount);
@property (nonatomic,copy,readonly) RACSignal *(^delay)(NSTimeInterval interval);
@property (nonatomic,copy,readonly) RACSignal *(^throttle)(NSTimeInterval interval);
@property (nonatomic,copy,readonly) RACSignal *(^doNext)(void(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^doError)(void(^)(id value));
@property (nonatomic,copy,readonly) RACSignal *(^doCompleted)(void(^)(void));

@property (nonatomic,copy,readonly) RACDisposable *(^subscribe)(id<RACSubscriber>);
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeNext)(void(^)(id value));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeError)(void(^)(NSError *error));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeCompleted)(void(^)(void));
@property (nonatomic,copy,readonly) RACDisposable *(^subscribeAll)(void(^_Nullable)(id value), void(^_Nullable)(NSError *error), void(^_Nullable)(void));

@end

CG_INLINE RACSignal *
hy_createSignal(RACDisposable * _Nullable (^block)(id<RACSubscriber> subscriber)) {
    return [RACSignal createSignal:block];
}

CG_INLINE RACSignal *
hy_signalWithValue(id _Nullable value) {
    return [RACSignal return:value];
}

CG_INLINE RACSignal *
hy_signalWithAction(void(^block)(void)) {
    return
    [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        !block ?: block();
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

CG_INLINE RACSignal *
hy_combineLatestAndReduceEach(NSArray<RACSignal *> *signals, RACReduceBlock block){
    return
    [[[RACSignal combineLatest:signals] reduceEach:block] distinctUntilChanged];
}

CG_INLINE RACSignal *
hy_signalsCompletedWithcommands(NSArray<RACCommand *> *commands) {
     NSMutableArray<RACSignal *> *executingSignals = @[].mutableCopy;
     [commands enumerateObjectsUsingBlock:^(RACCommand * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [executingSignals addObject:[obj.executing skip:1]];
     }];
     return  executingSignals ?
    [RACSignal combineLatest:executingSignals].or.distinctUntilChanged :
    [RACSignal empty];
}


CG_INLINE RACDisposable *
hy_rac_btn(UIButton *btn, void(^subscribeNext)(UIButton *x)) {
    return
    [btn rac_signalForControlEvents:UIControlEventTouchUpInside].deliverOnMainThread.subscribeNext(subscribeNext);
}


CG_INLINE
HyNetworkSuccessBlock subscribNetworkSuccesss(id<RACSubscriber> subscriber,
                                              HyNetworkSignalSuccessSubscribeBlock block) {
    return ^(id<HyNetworkSuccessProtocol> successObject) {
        block ?
        block(successObject, subscriber) :
        ({
            NSString *status= [NSString stringWithFormat:@"%@",@"info"];
            if (![status isEqualToString:@"0"]) {
                [subscriber sendError:nil];
            }else{
                [subscriber sendNext:successObject];
                [subscriber sendCompleted];
            }
        });
    };
}
CG_INLINE
HyNetworkFailureBlock subscribNetworkFailure(id<RACSubscriber>  _Nonnull subscriber,
                                             HyNetworkSignalFailureSubscribeBlock block) {
    return ^(id<HyNetworkFailureProtocol> failureObject) {
        block ? block(failureObject, subscriber) :
        [subscriber sendError:failureObject.error];
    };
}

CG_INLINE
typeof(void(^)(void)) networkTaskDisposable(id<HyNetworkSingleTaskProtocol> networkTask) {
    return ^{
        [networkTask cancel];
    };
}

#define hy_getSiganl(_showHUD, _cache, _url, _parameter, _successSubscribeBlock, _failureSubscribeBlock) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        return [RACDisposable disposableWithBlock:networkTaskDisposable \
                ([HyNetworkManager.network getShowHUD:_showHUD \
                                                 cache:_cache \
                                                   url:_url \
                                             parameter:_parameter \
                                          successBlock:subscribNetworkSuccesss(subscriber, _successSubscribeBlock) \
                                          failureBlock:subscribNetworkFailure(subscriber, _failureSubscribeBlock)].resume)];\
    }]; \
})


#define hy_postSiganl(_showHUD, _cache, _url, _parameter, _successSubscribeBlock, _failureSubscribeBlock) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        return [RACDisposable disposableWithBlock:networkTaskDisposable \
                ([HyNetworkManager.network postShowHUD:_showHUD \
                                                 cache:_cache \
                                                   url:_url \
                                             parameter:_parameter \
                                          successBlock:subscribNetworkSuccesss(subscriber, _successSubscribeBlock) \
                                          failureBlock:subscribNetworkFailure(subscriber, _failureSubscribeBlock)].resume)];\
    }]; \
})


#define hy_postFormDataSiganl(_showHUD, _cache, _url, _parameter, _formDataBlock, _successSubscribeBlock, _failureSubscribeBlock) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        return [RACDisposable disposableWithBlock:networkTaskDisposable \
                ([HyNetworkManager.network postShowHUD:_showHUD \
                                                 cache:_cache \
                                                   url:_url \
                                             parameter:_parameter \
                                         formDataBlock:_formDataBlock \
                                          successBlock:subscribNetworkSuccesss(subscriber, _successSubscribeBlock) \
                                          failureBlock:subscribNetworkFailure(subscriber, _failureSubscribeBlock)].resume)];\
    }]; \
})


#define hy_pushSignal(_viewControllerName, _viewModelName, _parameter, _animated) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        [RACSignal pushViewControllerWithName:_viewControllerName \
                                viewModelName:_viewModelName \
                                    parameter:_parameter \
                                     animated:_animated \
                                   completion:^(UIViewController<HyViewControllerProtocol> * _Nonnull controller) { \
            [subscriber sendNext:controller]; \
            [subscriber sendCompleted]; \
        }]; \
        return nil; \
    }]; \
})


#define hy_presentSignal(_viewControllerName, _viewModelName, _parameter, _animated) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        [RACSignal presentViewControllerWithName:_viewControllerName \
                                   viewModelName:_viewModelName \
                                       parameter:_parameter \
                                        animated:_animated \
                                      completion:^(UIViewController<HyViewControllerProtocol> * _Nonnull controller) { \
           [subscriber sendNext:controller]; \
           [subscriber sendCompleted]; \
        }]; \
        return nil; \
    }]; \
})

#define hy_popSignal(_viewControllerName, _parameter, _animated) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
       if (_viewControllerName.length) { \
           [RACSignal popViewControllerWithName:_viewControllerName \
                                      parameter:_parameter \
                                       animated:_animated \
                                     completion:^{ \
               [subscriber sendNext:nil]; \
               [subscriber sendCompleted]; \
           }]; \
       } else { \
           [RACSignal popViewControllerWithParameter:_parameter \
                                            animated:_animated \
                                          completion:^{ \
               [subscriber sendNext:nil]; \
               [subscriber sendCompleted]; \
           }]; \
       } \
       return nil; \
    }]; \
})

#define hy_dismissSignal(_parameter, _animated) \
({ \
    [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) { \
        [RACSignal dismissViewControllerWithParameter:_parameter \
                                             animated:_animated \
                                           completion:^{ \
            [subscriber sendNext:nil]; \
            [subscriber sendCompleted]; \
        }]; \
        return nil; \
    }]; \
})


NS_ASSUME_NONNULL_END
