//
//  HyVideoCodecProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyVideoConfigureProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HyVideoCodecProtocol <NSObject>

+ (instancetype)codecWithConfigure:(void(^_Nullable)(id<HyVideoConfigureProtocol> configure))block;

- (void)endCodec;

- (void)codecWithFilePath:(NSString *)filePath
               completion:(void(^)(NSString *outFilePath))completion;

@end

NS_ASSUME_NONNULL_END
