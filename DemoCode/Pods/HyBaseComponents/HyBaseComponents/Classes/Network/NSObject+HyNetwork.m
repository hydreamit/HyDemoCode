//
//  NSObject+HyNetwork.m
//  DemoCode
//
//  Created by Hy on 2018/3/12.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "NSObject+HyNetwork.h"
#import <objc/message.h>

@implementation HyNetworkTaskContainer
- (instancetype)init {
    if (self = [super init]) {
        self.tasks = @[].mutableCopy;
    }
    return self;
}

- (void)dealloc {
    if (self.tasks.count) {
        [self.tasks makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
    }
}

@end

@implementation NSObject (HyNetwork)

- (HyNetworkTaskContainer *)hy_networkTaskContainer {
    HyNetworkTaskContainer *container = objc_getAssociatedObject(self, _cmd);
    if (!container) {
        container = [[HyNetworkTaskContainer alloc] init];
        self.hy_networkTaskContainer = container;
    }
    return container;
}

- (void)setHy_networkTaskContainer:(HyNetworkTaskContainer *)hy_networkTaskContainer {
    objc_setAssociatedObject(self,
                             @selector(hy_networkTaskContainer),
                             hy_networkTaskContainer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
