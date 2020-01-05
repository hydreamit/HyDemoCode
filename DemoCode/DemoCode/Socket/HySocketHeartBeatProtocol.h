//
//  HySocketHeartBeatProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HySocketHeartBeatProtocol <NSObject>

- (void)start;

- (void)stop;

- (void)performBlock:(void(^_Nullable)(void))pBlock;

@end

NS_ASSUME_NONNULL_END
