//
//  HyFFmepgAudioEncoder.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/4.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioEncoderProtocol.h"
#import "HyAudioCodec.h"

NS_ASSUME_NONNULL_BEGIN
 
@interface HyFFmepgAudioEncoder : HyAudioCodec<HyAudioEncoderProtocol>

@end

NS_ASSUME_NONNULL_END
