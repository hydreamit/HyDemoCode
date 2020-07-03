//
//  HyTextFieldView.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTextFieldView.h"
#import <Masonry/Masonry.h>
#import <HyCategoriess/UITextField+HyExtension.h>
#import <HyCategoriess/UIColor+HyExtension.h>

@interface HyTextFieldView ()
@property (nonatomic,strong) UIView *bottomLine;
@property (nonatomic,strong) RACSignal *maxLengthSignal;
@end

@implementation HyTextFieldView
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

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (void)setMaxLength:(NSInteger)maxLength {
    
    if (maxLength > 0 && !self.maxLengthSignal) {
        self.maxLengthSignal = [RACSignal return:nil];
        
        RACChannelTerminal *tem = self.textField.rac_newTextChannel;
        [[tem map:^id _Nullable(NSString *  _Nullable value) {
             return value.length > maxLength ? [value substringToIndex:maxLength] : value;
        }] subscribe:tem];
//        RAC(self.textField, text) =
//        [self.textField.rac_textSignal map:^NSString *(NSString *value) {
//            return value.length > maxLength ? [value substringToIndex:maxLength] : value;
//        }];
    }
}

- (void)initConfigre {
    self.lineNormalColor = [UIColor hy_colorWithHexString:@"#D5DCE4"];
    self.lineSelectedColor = [UIColor hy_colorWithHexString:@"#3C8FF9"];
    [self configUI];
    [self configLayout];
    self.textSignal = [self.textField.rac_textSignal merge:RACObserve(self.textField, text)];
}

- (void)configUI {
    [self addSubview:self.textField];
    [self addSubview:self.bottomLine];
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

- (UITextField *)textField {
    if (!_textField){
        @weakify(self);
        _textField = [UITextField hy_textFieldWithFrame:CGRectZero
                                                   font:[UIFont systemFontOfSize:15]
                                                   text:@""
                                              textColor:UIColor.darkTextColor
                                            placeholder:nil
                                       placeholderColor:nil
                                      delegateConfigure:^(HyTextFieldDelegateConfigure * _Nonnull configure) {
  
            configure.configTextFieldDidBeginEditing(^(UITextField * _Nonnull textField) {
                @strongify(self);
                self.bottomLine.backgroundColor = self.lineSelectedColor;
            }).configTextFieldDidEndEditing(^(UITextField * _Nonnull textField) {
                @strongify(self);
                self.bottomLine.backgroundColor = self.lineNormalColor;
            }).configTextFieldShouldReturn(^BOOL(UITextField * _Nonnull textField) {
                [textField resignFirstResponder];
                return YES;
            });
        }];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (UIView *)bottomLine {
    if (!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.lineNormalColor;
    }
    return _bottomLine;
}

@end
