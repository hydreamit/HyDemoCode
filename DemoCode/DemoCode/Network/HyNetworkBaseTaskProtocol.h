//
//  HyNetworkSingleTaskProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/28.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyNetworkBaseTaskProtocol <NSObject>

- (instancetype)resume;

// object 销毁时 如果任务在请求中 取消请求
- (instancetype (^)(NSObject * _Nullable object))resumeAtObjcet;


- (void)cancel;


@end

NS_ASSUME_NONNULL_END
