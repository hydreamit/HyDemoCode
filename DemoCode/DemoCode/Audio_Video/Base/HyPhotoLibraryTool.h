//
//  HyPhotoLibraryTool.h
//  HyVideoDemo
//
//  Created by Hy on 2018/3/3.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyPhotoLibraryTool : NSObject

+ (void)saveImage:(UIImage *)image
        assetName:(NSString * _Nullable)assetName
       completion:(void(^_Nullable)(UIImage *image, NSError *error))completion;


+ (void)saveVideoWithUrl:(NSURL *)url
               assetName:(NSString *_Nullable)assetName
              completion:(void(^_Nullable)(NSURL *url, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
