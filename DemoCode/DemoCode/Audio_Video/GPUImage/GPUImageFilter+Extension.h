//
//  GPUImageFilter+Extension.h
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <GPUImage/GPUImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPUImageFilter (Extension)

+ (instancetype)hy_filterWithConfigureBlock:(void(^)(id filter))block;

+ (UIImage *)hy_imageByFilteringImage:(UIImage *)image
                       configureBlock:(void(^)(id filter))block;

@end

NS_ASSUME_NONNULL_END
