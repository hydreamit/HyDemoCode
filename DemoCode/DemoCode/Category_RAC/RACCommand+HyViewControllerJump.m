//
//  RACCommand+HyViewControllerJump.m
//  DemoCode
//
//  Created by Hy on 2017/11/20.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "RACCommand+HyViewControllerJump.h"
#import "RACSignal+HyViewControllerJump.h"

@implementation RACCommand (HyViewControllerJump)

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))pushEnabledCommand {
    
    return ^RACCommand *(RACSignal *enabledSignal,
                         NSString *_Nullable viewControllerName,
                         NSString *_Nullable viewModelName,
                         NSDictionary *_Nullable parameter,
                         BOOL animated){
            return
            [[RACCommand alloc] initWithEnabled:enabledSignal
                                    signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                
                return RACSignal.pushSignal(viewControllerName,
                                            viewModelName,
                                            parameter,
                                            animated);
            }];
       };
}

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSString *_Nullable viewModelName,
                   NSDictionary * _Nullable parameter,
                   BOOL animated))presentEnabledCommand {

    return ^RACCommand *(RACSignal<NSNumber *> *enabledSignal,
                         NSString *_Nullable viewControllerName,
                         NSString *_Nullable viewModelName,
                         NSDictionary *_Nullable parameter,
                         BOOL animated){
            return
            [[RACCommand alloc] initWithEnabled:enabledSignal
                                    signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
                return RACSignal.presentSignal(viewControllerName,
                                               viewModelName,
                                               parameter,
                                               animated);
            }];
       };
}

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSString *_Nullable viewControllerName,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))popEnabledCommand {

    return ^RACCommand *(RACSignal<NSNumber *> *enabledSignal,
                         NSString *_Nullable viewControllerName,
                         NSDictionary *_Nullable parameter,
                         BOOL animated){
        return
        [[RACCommand alloc] initWithEnabled:enabledSignal
                                signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return RACSignal.popSignal(viewControllerName,
                                       parameter,
                                       animated);
        }];
    };
}

+ (RACCommand *(^)(RACSignal<NSNumber *> *enabledSignal,
                   NSDictionary *_Nullable parameter,
                   BOOL animated))dismissEnabledCommand {

    return ^RACCommand *(RACSignal<NSNumber *> *enabledSignal,
                         NSDictionary *_Nullable parameter,
                         BOOL animated){
        return
        [[RACCommand alloc] initWithEnabled:enabledSignal
                                signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
             return RACSignal.dismissSignal(parameter,
                                            animated);
        }];
    };
}

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))pushCommand {
    
    return ^RACCommand *(NSString *_Nullable viewControllerName,
                        NSString *_Nullable viewModelName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return RACSignal.pushSignal(viewControllerName,
                                        viewModelName,
                                        parameter,
                                        animated);
        }];
    };
}

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                  NSString *_Nullable viewModelName,
                  NSDictionary * _Nullable parameter,
                  BOOL animated))presentCommand {
    
    return ^RACCommand *(NSString *_Nullable viewControllerName,
                        NSString *_Nullable viewModelName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return RACSignal.presentSignal(viewControllerName,
                                           viewModelName,
                                           parameter,
                                           animated);
        }];
    };
}

+ (RACCommand *(^)(NSString *_Nullable viewControllerName,
                  NSDictionary *_Nullable parameter,
                  BOOL animated))popCommand {
    return ^RACCommand *(NSString *_Nullable viewControllerName,
                        NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return RACSignal.popSignal(viewControllerName,
                                       parameter,
                                       animated);
        }];
    };
}

+ (RACCommand *(^)(NSDictionary *_Nullable parameter,
                  BOOL animated))dismissCommand {
    return ^RACCommand *(NSDictionary *_Nullable parameter,
                        BOOL animated){
        return
        [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return RACSignal.dismissSignal(parameter,
                                           animated);
        }];
    };
}

@end
