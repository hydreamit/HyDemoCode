//
//  HyMeViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyMeViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RACCommand+HyExtension.h"
#import "NSObject+HyRACExtension.h"
#import "HyMeModel.h"
#import "HyMeViewController.h"


@interface HyMeViewModel ()
@property (nonatomic,strong) HyMeModel *model;
@end


@implementation HyMeViewModel
@dynamic model;

- (RACCommand *)commandForKey:(NSString *)key {
    
    @weakify(self);
    
    if (isKey(@"push")) {
        RACSignal *pushEnabledSignal =
        hy_combineLatestAndReduceEach(@[RACObserve(self.model, account),
                                        RACObserve(self.model, code)], ^id _Nonnull(NSString *account,
                                        NSString *code){
            return @(account.length == 11 && code.length);
        });
        
        RACCommand *command =
        hy_pushCommand(pushEnabledSignal,
                       @"HyMeViewController",
                       @"HyMeViewModel",
                       @{@"account" : self_weak_.model.account},
                       YES);
        command.allowsConcurrentExecution = YES;
        return command;
    }
    
    if (isKey(@"pop")) {
        return hy_popCommand(nil, @"", @{@"account" : self_weak_.model.account}, YES);
    }
    
    return [super commandForKey:key];
}


- (RACSignal *)commandEnabledSignalForKey:(NSString *)key {
    
    if (isKey(@"code")) {
        return
        [[RACObserve(self.model, account) distinctUntilChanged] map:^id (NSString *value) {
           return @(value.length == 11);
        }];
    }
    
    return [super commandEnabledSignalForKey:key];
}

- (RACSignal *)commandSignalWithInput:(id)input forKey:(NSString *)key {
    
    if (isKey(@"code")) {
        
        RACSignal *(^timerCountSignal)(UIButton *, NSNumber *, NSString *) =
        ^RACSignal *(UIButton *btn, NSNumber *count, NSString *title) {

           RACSignal *(^counterSignal)(NSNumber *count) = ^RACSignal *(NSNumber *count) {
               return
               [[[[RACSignal interval:1
                          onScheduler:[RACScheduler mainThreadScheduler]]
                  startWith:[NSDate date]]
                 scanWithStart:count reduce:^id(NSNumber *running, id next) {
                     return @(running.integerValue - 1);
                 }] takeUntilBlock:^BOOL(NSNumber *x) {
                     return x.integerValue < 0;
                 }];
           };

           RACSignal *timerSignal = counterSignal(count);
           id (^counterSignalMap)(NSNumber *value) = ^(NSNumber *value){
               return [NSString stringWithFormat:@"%@ (%@)",title, value];
           };
           RACSignal *counterStringSignal = [timerSignal map:counterSignalMap];

           __block id<RACSubscriber> saveSubscriber = nil;
           RACSignal *resetStringSignal =
           [RACSignal createSignal:^RACDisposable *(id<RACSubscriber>  subscriber) {
               saveSubscriber = subscriber;
               return nil;
           }];

           @weakify(btn);
           [timerSignal subscribeCompleted:^{
               @strongify(btn);
               [saveSubscriber sendNext:title];
               [saveSubscriber sendCompleted];
               [btn sizeToFit];
           }];

            btn.liftSelectorWithSignals(@selector(setTitle:forState:),
                                        @[[RACSignal merge:@[counterStringSignal, resetStringSignal]],
                                          [RACSignal return:@(UIControlStateNormal)]]);
           [btn sizeToFit];

           return timerSignal;
        };
        
        return timerCountSignal(input, @60, @"获取验证码");
    }
    
    return [super commandSignalWithInput:input forKey:key];
}

- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString {
    if ([classString isEqualToString:@"HyMeView"]) {
        return (id)self.model;
    }
    return nil;
}

@end
