//
//  RACTestTextFieldView.m
//  demo
//
//  Created by huangyi on 2018/12/7.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACTestTextFieldView.h"


@interface RACTestTextFieldView ()
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) RACSignal *maxLengthSignal;
@end


@implementation RACTestTextFieldView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfigre];
    }
    return self;
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    if (rightView) {
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-12);
            make.centerY.mas_equalTo(self.textField);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.leftView) {
                make.left.mas_equalTo(self.leftView.mas_right).offset(6);
            } else {
                make.left.equalTo(self.bottomLine);
            }
            make.right.mas_equalTo(rightView.mas_left).offset(-6);
            make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(-8);
        }];
        [rightView setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
        [rightView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                   forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (void)setLeftView:(UIView *)leftView {
    _leftView = leftView;
    if (leftView) {
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.mas_equalTo(self.textField);
        }];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right).offset(6);
            if (self.rightView) {
                make.right.mas_equalTo(self.rightView.mas_left).offset(-6);
            } else {
                make.right.mas_offset(-6);
            }
            make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(-8);
        }];
        [leftView setContentHuggingPriority:UILayoutPriorityRequired
                                    forAxis:UILayoutConstraintAxisHorizontal];
        [leftView setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                  forAxis:UILayoutConstraintAxisHorizontal];
    }
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setMaxLength:(NSInteger)maxLength {
    
    if (maxLength > 0 && !self.maxLengthSignal) {
        self.maxLengthSignal =
        RAC(self.textField, text) =
        [self.textField.rac_textSignal map:^NSString *(NSString *value) {
            return value.length > maxLength ? [value substringToIndex:maxLength] : value;
        }];
    }
}

- (void)initConfigre {
    self.lineNormalColor = [UIColor colorWithHexString:@"#D5DCE4"];
    self.lineSelectedColor = [UIColor colorWithHexString:@"#3C8FF9"];
    [self configUI];
    [self configLayout];
    self.textSignal = [self.textField.rac_textSignal merge:RACObserve(self.textField, text)];
}

- (void)configUI {
    [self addSubview:self.textField];
    [self addSubview:self.bottomLine];
    UIButton * clearButton = [self.textField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"1.0.0_Hy_ClearButton"] forState:UIControlStateNormal];
}

- (void)configLayout {
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@1);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomLine);
        make.right.mas_offset(-6);
        make.bottom.mas_equalTo(self.bottomLine.mas_top).offset(-8);
    }];
}

- (HYBlockTextField *)textField {
    return Hy_Lazy(_textField, ({
        
        @weakify(self);
        HYBlockTextField *textField =
        [HYBlockTextField blockTextFieldWithFrame:CGRectZero configureBlock:^(HYBlockTextFieldConfigure *configure) {
            [[[configure configTextFieldDidBeginEditing:^(UITextField *textField) {
                @strongify(self);
                self.bottomLine.backgroundColor = self.lineSelectedColor;
            }] configTextFieldShouldReturn:^BOOL(UITextField *textField) {
                [textField resignFirstResponder];
                return YES;
            }] configTextFieldDidEndEditing:^(UITextField *textField) {
                @strongify(self);
                self.bottomLine.backgroundColor = self.lineNormalColor;
            }];
        }];
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField;
    }));
}

- (UIView *)bottomLine {
    return Hy_Lazy(_bottomLine, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = self.lineNormalColor;
        view;
    }));
}

@end

