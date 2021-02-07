//
//  YYNetworkCache.m
//  DemoCode
//
//  Created by Hy on 2017/11/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "YYNetworkCache.h"
#import <YYCache/YYCache.h>


#define KEY_YYNetworkCache @"YYNetworkCache"

@interface YYNetworkCache ()
@property (nonatomic,strong) YYCache *yyCache;
@end


@implementation YYNetworkCache

- (id<NSCoding>)getCacheForKey:(NSString *)key {
    return [self.yyCache objectForKey:key];
}

- (void)setCache:(id<NSCoding>)cache forKey:(NSString *)key {
    [self. yyCache setObject:cache forKey:key];
}

- (void)removeCacheForKey:(NSString *)key {
    [[YYCache cacheWithName:KEY_YYNetworkCache].diskCache removeObjectForKey:key];
}

- (void)removeAllCaches {
    [[YYCache cacheWithName:KEY_YYNetworkCache].diskCache removeAllObjects];
}

- (unsigned long long)totalCacheSize {
    return [YYCache cacheWithName:KEY_YYNetworkCache].diskCache.totalCost;
}

- (YYCache *)yyCache {
    if (!_yyCache){
        _yyCache = [YYCache cacheWithName:KEY_YYNetworkCache];
        _yyCache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;;
    }
    return _yyCache;
}

@end
