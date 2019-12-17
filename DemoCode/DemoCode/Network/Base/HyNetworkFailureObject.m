//
//  HyNetworkFailureObject.m
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
//

#import "HyNetworkFailureObject.h"

@implementation HyNetworkFailureObject
@synthesize error = _error, task = _task;

+ (id<HyNetworkFailureProtocol>(^)(id, id<HyNetworkSingleTaskProtocol>))failureObject {
    return ^(id error, id<HyNetworkSingleTaskProtocol> task){
        id<HyNetworkFailureProtocol> object = [[self alloc] init];
        object.error = error;
        object.task = task;
        return object;
    };
}

@end
