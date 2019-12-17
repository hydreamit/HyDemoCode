//
//  HyNetworkSuccessObject.m
//  DemoCode
//
//  Created by Hy on 2017/12/16.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNetworkSuccessObject.h"

@implementation HyNetworkSuccessObject
@synthesize response = _response, task = _task;

+ (id<HyNetworkSuccessProtocol>(^)(id, id<HyNetworkSingleTaskProtocol>))successObject {
    return ^(id response, id<HyNetworkSingleTaskProtocol> task){
        id<HyNetworkSuccessProtocol> object = [[self alloc] init];
        object.response = response;
        object.task = task;
        return object;
    };
}

@end
