//
//  HyAudioWriter.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAudioWriterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class HyAVWriter;
@interface HyAudioWriter : NSObject<HyAudioWriterProtocol>

@property (nonatomic,weak) HyAVWriter<HyAVWriterProtocol> *avWriter;

@end

NS_ASSUME_NONNULL_END
