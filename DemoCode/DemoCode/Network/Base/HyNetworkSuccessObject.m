//
//  HyNetworkSuccessObject.m
//  DemoCode
//
//  Created by huangyi on 2019/12/16.
//  Copyright © 2019 Hy. All rights reserved.
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
