//
//  HyNetworkCompletionObject.m
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkCompletionObject.h"

@implementation HyNetworkCompletionObject
@synthesize response = _response, error = _error, task = _task;

+ (id<HyNetworkCompletionProtocol>(^)(id, id, id<HyNetworkMutipleTasksProtocol>))completionObject {
    return ^(id response, id error, id<HyNetworkMutipleTasksProtocol> task){
        id<HyNetworkCompletionProtocol> object = [[self alloc] init];
        object.response = response;
        object.error = error;
        object.task = task;
        return object;
    };
}

@end
