//
//  HyVideoConfigureProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, H624DataType) {
    H624DataTypeNaluSps, // sps
    H624DataTypeNaluPps, // pps
    H624DataTypeNaluIFrame, // 关键帧I帧
    H624DataTypeNaluPBFrame // PB帧
};

@protocol HyVideoConfigureProtocol <NSObject>

// base
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) int bitrate;    // 码率
@property (nonatomic,assign) int frameRate; // 帧率 默认30

// H264
@property (nonatomic,assign) int gop_size;      // I帧间隔 默认 30
@property (nonatomic,assign) int max_b_frames; // B帧最大值 默认 5


/// 输出文件(.yuv/.h624)
@property (nonatomic,copy) NSString *outFilePath;
///  编码回调 codecData (YUV -> H.624)
@property (nonatomic,copy) void(^encodeBlock)(NSData *h624Data, H624DataType dataType);
///  解码回调 codecData (H.624 -> YUV)
@property (nonatomic,copy) void(^decodeBlock)(CVImageBufferRef imageBuffer);


@end

NS_ASSUME_NONNULL_END
