//
//  HyAudioCodec.m
//  HyVideoDemo
//
//  Created by Hy on 2018/3/10.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioCodec.h"


@interface HyAudioCodec ()
@property (nonatomic,strong) HyAudioConfigure *audioConfigure;
@property (nonatomic,assign) FILE *file;
@end


@implementation HyAudioCodec

+ (instancetype)codecWithConfigure:(void(^_Nullable)(id<HyAudioConfigureProtocol> configure))block {
    
    HyAudioCodec *encoder = [[self alloc] init];
    HyAudioConfigure *configure = [[HyAudioConfigure alloc] init];
    !block ?: block(configure);
    encoder.audioConfigure = configure;
    if (encoder.audioConfigure.outFilePath) {
        encoder.file = fopen([encoder.audioConfigure.outFilePath UTF8String], "wb");
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
