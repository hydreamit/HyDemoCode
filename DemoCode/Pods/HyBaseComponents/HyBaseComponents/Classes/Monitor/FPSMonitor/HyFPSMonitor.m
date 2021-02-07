//
//  HyFPSMonitor.m
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyFPSMonitor.h"


@interface HyDisplayLinkProxy : NSProxy
@property (nonatomic,weak) id target;
@property (nonatomic,weak) CADisplayLink *displayLink;
@end
@implementation HyDisplayLinkProxy
+ (instancetype)proxyWithTarget:(id)target {
    HyDisplayLinkProxy *proxy = [HyDisplayLinkProxy alloc];
    proxy.target = target;
    return proxy;
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if (self.target) {
        return [self.target methodSignatureForSelector:sel];
    } else {
        [self.displayLink invalidate];
        self.displayLink = nil;
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.target) {
        [invocation invokeWithTarget:self.target];
    }
}
@end


@interface HyFPSMonitor ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;
@property (nonatomic, assign) NSTimeInterval updateFPSInterval;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic,copy) void(^handler)(NSNumber *fps);
@end


@implementation HyFPSMonitor

- (instancetype)init {
    if (self = [super init]) {
        self.lastUpdateTime = 0;
        self.updateFPSInterval = 1;
    }
    return self;
}

- (void)startMonitorWithHandler:(void (^)(id _Nullable))handler {
    
    if (self.handler) {
        self.handler = nil;
    }
    self.handler = [handler copy];
    if (self.displayLink) {return;}
    
    HyDisplayLinkProxy *proxy = [HyDisplayLinkProxy proxyWithTarget:self];
    self.displayLink = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(updateFPS:)];
    proxy.displayLink = self.displayLink;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMonitor {
    
    if (!self.displayLink) {return;}
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)updateFPS:(CADisplayLink *)displayLink {
    
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = displayLink.timestamp;
    }
    ++self.count;
    NSTimeInterval interval = displayLink.timestamp - self.lastUpdateTime;
    if (interval < 1) {
        return;
    }
    self.lastUpdateTime = displayLink.timestamp;
    float fps = self.count / interval;
    self.count = 0;
    !self.handler ?: self.handler([NSNumber numberWithFloat:fps]);
}

@end

