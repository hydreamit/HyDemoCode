//
//  RACTestViewModel.m
//  demo
//
//  Created by huangyi on 2018/12/7.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACTestViewModel.h"

@implementation RACTestViewModel

- (void)handleViewModel {
    
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
    [[[RACSignal combineLatest:@[RACObserve(self, account),
                                 RACObserve(self, code)]]
        reduceEach:^(NSString *account,
                     NSString *code){
          return @(account.length == 11 && code.length);
      }] distinctUntilChanged];
    
    self.pushCommand =
    RACCommand.pushEnabledCommand(pushEnabledSignal, @"RACTestViewController", @"RACTestViewModel", @{});
  
    
#pragma mark — pop
    self.popCommand = RACCommand.popCommand(@"",@{});
    
    
#pragma mark — 发送验证码
    RACSignal *codeEnabledSignal =
    [[RACObserve(self, account) distinctUntilChanged] map:^id (NSString *value) {
        return @(value.length == 11);
    }];
    
    CommandSignalInputBlock (^codeSignal)(void) = ^CommandSignalInputBlock {
        return ^RACSignal *(id value){
            return timerCountSignal(value, @60, @"获取验证码");
        };
    };
    self.codeCommand = RACCommand.enabledBlockCommand(codeEnabledSignal, codeSignal(), nil);
}

@end
