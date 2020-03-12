//
//  HyFFmepgVideoEncoder.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/4.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyVideoEncoderProtocol.h"
#import "HyVideoCodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyFFmepgVideoEncoder : HyVideoCodec<HyVideoEncoderProtocol>

@end

NS_ASSUME_NONNULL_END
