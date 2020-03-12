//
//  HyVideoCodec.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyVideoCodecProtocol.h"
#import "HyVideoConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyVideoCodec : NSObject<HyVideoCodecProtocol>

@property (nonatomic,strong,readonly) HyVideoConfigure *videoConfigure;
@property (nonatomic,assign,readonly) FILE *file;

- (void)closeFile;

@end

NS_ASSUME_NONNULL_END
