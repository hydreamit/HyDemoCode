//
//  HyRefreshAnimationView.h
//  DemoCode
//
//  Created by Hy on 2017/12/10.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyRefreshAnimationView : UIView

- (void)changeWithPercent:(CGFloat)percent;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
