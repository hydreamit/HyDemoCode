//
//  HySocketMessage.m
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySocketMessage.h"

@implementation HySocketMessage
@synthesize content = _content, sourceID = _sourceID, targetID = _targetID, type = _type;

+ (instancetype(^)(NSString *content, NSString * _Nullable targetID, HySocketMessageType type))message {
    return ^(NSString *content, NSString * _Nullable targetID, HySocketMessageType type) {
        HySocketMessage *message = [[self alloc] init];
        message.content = content;
        message.type = type;
        message.targetID = targetID;
        return message;
    };
}

@end

