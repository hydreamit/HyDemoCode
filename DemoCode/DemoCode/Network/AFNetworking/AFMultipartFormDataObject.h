//
//  AFMultipartFormDataObject.h
//  DemoCode
//
//  Created by Hy on 2017/11/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyMultipartFormDataProtocol.h"
#import "AFURLRequestSerialization.h"


NS_ASSUME_NONNULL_BEGIN

@interface AFMultipartFormDataObject : NSObject <HyMultipartFormDataProtocol>

+ (instancetype)object:(id<AFMultipartFormData>)fromData;

@end

NS_ASSUME_NONNULL_END
