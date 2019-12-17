//
//  HyNetworkSingleTaskProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkBaseTaskProtocol <NSObject>

- (void)resume;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
