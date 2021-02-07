//
//  HyPerformanceMonitor.m
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyPerformanceMonitor.h"


@interface HyPerformanceMonitor ()
@property (nonatomic,assign) CFRunLoopActivity activity;
@property (nonatomic,assign) CFRunLoopObserverRef observer;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@end


@implementation HyPerformanceMonitor

- (void)startMonitorWithHandler:(void (^)(id _Nullable result))handler {
   
    if (self.observer) { return; }
       
    self.semaphore = dispatch_semaphore_create(0);
    self.observer =
    CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
       self.activity = activity;
       dispatch_semaphore_signal(self.semaphore);
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    CFRelease(self.observer);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       while (self.observer) {
           
           long waitS = dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 18 * NSEC_PER_MSEC));
        
           // 刷新UI/处理时间逻辑 超时16.7 ms(60FPS)
           if (waitS != 0) {
               // kCFRunLoopBeforeWaiting 刷新UI
               // kCFRunLoopBeforeTimers 处理时间逻辑
               if (self.activity == kCFRunLoopBeforeSources ||
                   self.activity == kCFRunLoopAfterWaiting) {
                   !handler ?: handler(nil);
               }
           }
       }
    });
}

- (void)stopMonitor {
   
    if (!self.observer) { return; }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    CFRelease(self.observer);
    self.observer = NULL;
}

@end

