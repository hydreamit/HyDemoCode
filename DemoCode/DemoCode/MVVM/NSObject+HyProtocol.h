//
//  NSObject+HyProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ReactiveObjC/RACEXTRuntimeExtensions.h>
#import <UIKit/UIKit.h>


#define  Hy_ProtocolAndSelector(_object, _Protocol, _Selector) \
( \
[_object conformsToProtocol:_Protocol] && \
[_object respondsToSelector:_Selector] \
)

Class getObjcectPropertyClass(Class cls, const char *name);

NS_ASSUME_NONNULL_BEGIN


@interface NSObject (HyProtocol)

@end

NS_ASSUME_NONNULL_END
