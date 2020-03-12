//
//  HyAudioConfigureProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyAudioConfigureProtocol <NSObject>

@property (nonatomic,assign) Float64 sampleRate;   // 采样率
@property (nonatomic,assign) UInt32 channelCount; // 声道数
@property (nonatomic,assign) uint32_t  bitrate;  // 码率

/// 输出文件(.pcm/.aac)
@property (nonatomic,copy) NSString *outFilePath;
///  编/解码回调 codecData (pcm/aac)
@property (nonatomic,copy) void(^codecBlock)(NSData *codecData);

@end

NS_ASSUME_NONNULL_END
