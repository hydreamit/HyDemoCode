//
//  HyNetworkManager.m
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkManager.h"
#import "YYNetworkCache.h"
#import "AFNetwork.h"


@interface HyNetworkManager ()
@property (nonatomic,strong) id<HyNetworkProtocol> afnNetwork;
@property (nonatomic,strong) id<HyNetworkCacheProtocol> yyNetworkCache;
@end


@implementation HyNetworkManager

+ (instancetype)manager {
    
    static HyNetworkManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[super allocWithZone:NULL] init];
        _instance.yyNetworkCache = [[YYNetworkCache alloc] init];
        _instance.afnNetwork = [AFNetwork networkWithCache:_instance.yyNetworkCache];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self manager];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (id<HyNetworkProtocol>)network {
    return [[self manager] afnNetwork];
}

+ (id<HyNetworkCacheProtocol>)networkCache {
    return [[self manager] yyNetworkCache];
}

@end
