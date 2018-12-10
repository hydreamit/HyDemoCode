//
//  RACTestViewModel.h
//  demo
//
//  Created by huangyi on 2018/12/7.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACTestViewModel : HYBaseViewModel

@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) RACCommand *codeCommand;
@property (nonatomic,strong) RACCommand *pushCommand;
@property (nonatomic,strong) RACCommand *popCommand;

@end

NS_ASSUME_NONNULL_END
