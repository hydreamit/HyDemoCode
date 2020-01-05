//
//  HySocketHeartBeat.m
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySocketHeartBeat.h"
#import "HyNetworkManager.h"


@interface HySocketHeartBeat ()
@property (nonatomic, strong) dispatch_source_t beatTimer;
@property (nonatomic,copy) void(^pBlock)(void);
@end


@implementation HySocketHeartBeat

- (void)performBlock:(void (^)(void))pBlock {
    self.pBlock = [pBlock copy];
}

- (void)start {
    dispatch_resume(self.beatTimer);
}

- (void)stop {
    if (_beatTimer) {
        dispatch_source_cancel(self.beatTimer);
        self.beatTimer = NULL;
    }
}

- (dispatch_source_t)beatTimer {
    if (!_beatTimer) {
        //心跳设置为3分钟，NAT超时一般为5分钟
        _beatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_beatTimer, DISPATCH_TIME_NOW, 3 * 60  * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_beatTimer, self.pBlock);
    }
    return _beatTimer;
}

@end
