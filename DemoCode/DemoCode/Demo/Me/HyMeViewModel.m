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


@implementation HyMeViewModel
@dynamic model;

- (void)viewModelLoad {
    [super viewModelLoad];
    

    
    #pragma mark — 倒计时信号
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


    #pragma mark — push
    RACSignal *pushEnabledSignal =
    hy_combineLatestAndReduceEach(@[RACObserve(self.model, account),
                                    RACObserve(self.model, code)], ^id _Nonnull(NSString *account,
                                    NSString *code){
        return @(account.length == 11 && code.length);
    });
    self.pushCommand =
    hy_pushCommand(pushEnabledSignal, @"HyMeViewController", @"HyMeViewModel", @{@"account" : self.model.account}, YES);

    
    #pragma mark — pop
    self.popCommand = hy_popCommand(nil, @"", @{}, YES);


    #pragma mark — 发送验证码
    RACSignal *codeEnabledSignal =
    [[RACObserve(self.model, account) distinctUntilChanged] map:^id (NSString *value) {
       return @(value.length == 11);
    }];

    self.codeCommand = hy_command(codeEnabledSignal, nil, ^RACSignal * _Nonnull(id  _Nonnull value) {
        return timerCountSignal(value, @60, @"获取验证码");
    });
}

- (id<HyViewDataProtocol>)viewDataProviderForClassString:(NSString *)classString {
    if ([classString isEqualToString:@"HyMeView"]) {
        return self.model;
    }
    return nil;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
