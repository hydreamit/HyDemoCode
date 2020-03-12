//
//  HyVideoCodec.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyVideoCodec.h"


@interface HyVideoCodec ()
@property (nonatomic,strong) HyVideoConfigure *videoConfigure;
@property (nonatomic,assign) FILE *file;
@end


@implementation HyVideoCodec

+ (instancetype)codecWithConfigure:(void(^_Nullable)(id<HyVideoConfigureProtocol> configure))block {
    
    HyVideoCodec *encoder = [[self alloc] init];
    HyVideoConfigure *configure = [[HyVideoConfigure alloc] init];
    !block ?: block(configure);
    encoder.videoConfigure = configure;
    if (encoder.videoConfigure.outFilePath) {
        encoder.file = fopen([encoder.videoConfigure.outFilePath UTF8String], "wb");
    }
    return encoder;
}

- (void)endCodec {
    [self closeFile];
}

- (void)codecWithFilePath:(nonnull NSString *)filePath completion:(nonnull void (^)(NSString * _Nonnull))completion {}

- (void)closeFile {
    if (self.file) {
        fclose(self.file);
        self.file = NULL;
    }
}

- (void)dealloc {
    [self endCodec];
    
    NSLog(@"%@=====%s", self, __func__);
}

@end
