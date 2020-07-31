//
//  HyMeView.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyMeViewModel.h"
#import "HyView.h"

NS_ASSUME_NONNULL_BEGIN


@protocol HyMeViewDataProtocol <HyViewDataProtocol>
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *code;
@end


@interface HyMeView : HyView<HyMeViewModel *, id<HyMeViewDataProtocol>, id<HyViewEventProtocol>>

@end

NS_ASSUME_NONNULL_END
