//
//  HyVideoDecoderProtocol.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyVideoDecoderProtocol <NSObject>

- (void)codecWithNaluData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
