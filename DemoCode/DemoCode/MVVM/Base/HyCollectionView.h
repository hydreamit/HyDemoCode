//
//  HyCollectionView.h
//  DemoCode
//
//  Created by Hy on 2017/11/21.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyViewProtocol.h"
#import "HyListViewProtocol.h"
#import "HyRefreshViewManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HyCollectionView : UICollectionView <HyViewControllerJumpProtocol, HyListViewProtocol>

@end

NS_ASSUME_NONNULL_END
