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
#import "RACCommand+HyViewControllerJump.h"

@implementation HyMeViewModel
@dynamic model;

- (void)viewModelLoad {
    [super viewModelLoad];
    
    self.model = (HyMeModel *)[HyMeModel modelWithParameter:self.parameter];
    
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
       
       [btn rac_liftSelector:@selector(setTitle:forState:)
                 withSignals:[RACSignal merge:@[counterStringSignal, resetStringSignal]],
        [RACSignal return:@(UIControlStateNormal)], nil];
       [btn sizeToFit];
       
       return timerSignal;
    };


    #pragma mark — push
    RACSignal *pushEnabledSignal =
    [[[RACSignal combineLatest:@[RACObserve(self.model, account),
                                RACObserve(self.model, code)]]
       reduceEach:^(NSString *account,
                    NSString *code){
         return @(account.length == 11 && code.length);
     }] distinctUntilChanged];

    self.pushCommand =
    RACCommand.pushEnabledCommand(pushEnabledSignal, @"HyMeViewController", @"HyMeViewModel", @{@"account" : @"12345678901"}, YES);


    #pragma mark — pop
    self.popCommand = RACCommand.popCommand(@"",@{}, YES);


    #pragma mark — 发送验证码
    RACSignal *codeEnabledSignal =
    [[RACObserve(self.model, account) distinctUntilChanged] map:^id (NSString *value) {
       return @(value.length == 11);
    }];

    CommandSignalInputBlock (^codeSignal)(void) = ^CommandSignalInputBlock {
       return ^RACSignal *(id value){
           return timerCountSignal(value, @60, @"获取验证码");
       };
    };
    self.codeCommand = RACCommand.enabledBlockCommand(codeEnabledSignal, codeSignal(), nil);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
