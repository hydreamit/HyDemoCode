//
//  RACSignal+HyViewControllerJump.m
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACSignal+HyViewControllerJump.h"


@implementation RACSignal (HyViewControllerJump)

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))pushSignal {
    
    @weakify(self);
    return ^RACSignal *(NSString *_Nullable viewControllerName,
                        NSString *_Nullable viewModelName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self pushViewControllerWithName:viewControllerName
                               viewModelName:viewModelName
                                   parameter:parameter
                                    animated:animated
                                  completion:^(UIViewController<HyViewControllerProtocol> * _Nonnull controller) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    };
}

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary * _Nullable parameter,
                  BOOL animated))presentSignal {
    
    @weakify(self);
    return ^RACSignal *(NSString *_Nullable viewControllerName,
                        NSString *_Nullable viewModelName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){

        return
        [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self presentViewControllerWithName:viewControllerName
                                  viewModelName:viewModelName
                                      parameter:parameter
                                       animated:animated
                                     completion:^(UIViewController<HyViewControllerProtocol> * _Nonnull controller) {
                [subscriber sendNext:controller];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    };
}

+ (RACSignal *(^)(NSString *_Nullable viewControllerName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))popSignal {
    @weakify(self);
    return ^RACSignal *(NSString *_Nullable viewControllerName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            if (viewControllerName.length) {
                [self popViewControllerWithName:viewControllerName
                                      parameter:parameter
                                       animated:animated
                                     completion:^{
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
            } else {
                [self popViewControllerWithParameter:parameter
                                            animated:animated
                                          completion:^{
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
            }
            return nil;
        }];
    };
}

+ (RACSignal *(^)(NSDictionary *_Nullable parameter,
                  BOOL animated))dismissSignal {
    @weakify(self);
    return ^RACSignal *(NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self dismissViewControllerWithParameter:parameter
                                            animated:animated
                                          completion:^{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    };
}

@end
