//
//  HyAVWriter.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyAVWriterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyAVWriter : NSObject<HyAVWriterProtocol>

@property (nonatomic,assign) NSTimeInterval maxTime;

- (void)writingTimeOut;

@end

NS_ASSUME_NONNULL_END
