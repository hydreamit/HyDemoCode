//
//  HyAudioCodec.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/10.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioCodecProtocol.h"
#import "HyAudioConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyAudioCodec : NSObject<HyAudioCodecProtocol>

@property (nonatomic,strong,readonly) HyAudioConfigure *audioConfigure;
@property (nonatomic,assign,readonly) FILE *file;

- (void)closeFile;

@end

NS_ASSUME_NONNULL_END
