//
//  HyRefreshAnimationView.h
//  DemoCode
//
//  Created by huangyi on 2019/12/10.
//  Copyright © 2019 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyRefreshAnimationView : UIView

- (void)changeWithPercent:(CGFloat)percent;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
