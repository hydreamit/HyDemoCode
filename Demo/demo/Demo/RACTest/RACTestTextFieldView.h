//
//  RACTestTextFieldView.h
//  demo
//
//  Created by huangyi on 2018/12/7.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBlockTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACTestTextFieldView : UIView

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) RACSignal *textSignal;

@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) HYBlockTextField *textField;

@property (nonatomic,strong) UIColor *lineNormalColor;
@property (nonatomic,strong) UIColor *lineSelectedColor;
@property (nonatomic,assign) NSInteger maxLength;

@end

NS_ASSUME_NONNULL_END
