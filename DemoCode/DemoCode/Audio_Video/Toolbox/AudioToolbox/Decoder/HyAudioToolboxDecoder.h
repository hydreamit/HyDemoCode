//
//  HyAudioToolboxDecoder.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/6.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioCodec.h"
#import "HyAudioDecoderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyAudioToolboxDecoder : HyAudioCodec<HyAudioDecoderProtocol>

@end

NS_ASSUME_NONNULL_END
