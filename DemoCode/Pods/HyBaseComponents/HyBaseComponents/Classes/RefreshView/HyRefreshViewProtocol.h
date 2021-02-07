//
//  HyRefreshViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HyRefreshViewProtocol <NSObject>

+ (instancetype)refreshViewWithScrollView:(UIScrollView *)scrollView
                            refreshAction:(void(^_Nullable)(void))refreshAction;

- (void)beginRefreshing;

- (void)endRefreshing;

- (void)setHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
