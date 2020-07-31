//
//  HyMeModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyModel.h"
#import "HyMeView.h"


NS_ASSUME_NONNULL_BEGIN

@interface HyMeModel : HyModel<HyMeViewDataProtocol>

@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *code;

@end

NS_ASSUME_NONNULL_END
