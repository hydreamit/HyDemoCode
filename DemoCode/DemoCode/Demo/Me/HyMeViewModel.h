//
//  HyMeViewModel.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyViewModel.h"
#import "HyMeModel.h"
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyMeViewModel : HyViewModel

@property (nonatomic,strong) HyMeModel *model;

@property (nonatomic,strong) RACCommand *codeCommand;
@property (nonatomic,strong) RACCommand *pushCommand;
@property (nonatomic,strong) RACCommand *popCommand;

@end

NS_ASSUME_NONNULL_END
