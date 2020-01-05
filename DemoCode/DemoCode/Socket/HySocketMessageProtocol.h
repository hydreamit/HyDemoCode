//
//  HySocketMessageProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/1/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HySocketMessageType) {
    HySocketMessageTypeText,
    HySocketMessageTypePicture
};

@protocol HySocketMessageProtocol <NSObject>

+ (instancetype(^)(NSString *content, NSString * _Nullable targetID, HySocketMessageType type))message;

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *sourceID;
@property (nonatomic,copy) NSString *targetID;
@property (nonatomic,assign) HySocketMessageType type;

@end

NS_ASSUME_NONNULL_END
