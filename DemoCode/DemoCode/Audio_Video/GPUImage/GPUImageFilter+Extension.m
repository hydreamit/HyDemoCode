//
//  GPUImageFilter+Extension.m
//  HyVideoDemo
//
//  Created by Hy on 2018/1/15.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "GPUImageFilter+Extension.h"

@implementation GPUImageFilter (Extension)

+ (instancetype)hy_filterWithConfigureBlock:(void(^)(id filter))block {
    
    GPUImageFilter *filter = [[self alloc] init];
    !block ?: block(filter);
    return filter;
}

+ (UIImage *)hy_imageByFilteringImage:(UIImage *)image
                       configureBlock:(void(^)(id filter))block {

    GPUImageFilter *filter = [self hy_filterWithConfigureBlock:block];
    return [filter imageByFilteringImage:image];
}

@end
