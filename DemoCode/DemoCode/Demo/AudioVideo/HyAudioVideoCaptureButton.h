//
//  HyAudioVideoCaptureButton.h
//  DemoCode
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface HyAudioVideoCaptureButton : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic,copy) void(^longPressBlock)(BOOL end);

- (void)resetTransform;

@end

NS_ASSUME_NONNULL_END
