//
//  HyNetworkCacheProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkCacheProtocol <NSObject>

- (id<NSCoding>)getCacheForKey:(NSString *)key;
- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key;

- (void)removeCacheForKey:(NSString *)key;
- (void)removeAllCaches;

- (unsigned long long)totalCacheSize;
@end

NS_ASSUME_NONNULL_END
