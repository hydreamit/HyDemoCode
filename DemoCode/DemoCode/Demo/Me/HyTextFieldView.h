//
//  HyTextFieldView.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTextFieldView : UIView

@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) RACSignal *textSignal;

@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIColor *lineNormalColor;
@property (nonatomic,strong) UIColor *lineSelectedColor;
@property (nonatomic,assign) NSInteger maxLength;

@end

NS_ASSUME_NONNULL_END
