//
//  HyFFmepgAudioDecoder.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/5.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioDecoderProtocol.h"
#import "HyAudioCodec.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyFFmepgAudioDecoder : HyAudioCodec<HyAudioDecoderProtocol>

@end

NS_ASSUME_NONNULL_END
