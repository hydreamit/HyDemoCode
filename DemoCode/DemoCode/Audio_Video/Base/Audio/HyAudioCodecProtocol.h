//
//  HyAudioCodecProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/10.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioConfigureProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@protocol HyAudioCodecProtocol <NSObject>

+ (instancetype)codecWithConfigure:(void(^_Nullable)(id<HyAudioConfigureProtocol> configure))block;

- (void)endCodec;

- (void)codecWithFilePath:(NSString *)filePath
               completion:(void(^)(NSString *outFilePath))completion;

@end

NS_ASSUME_NONNULL_END
