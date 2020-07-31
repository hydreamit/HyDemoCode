//
//  HyMeView.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyMeView.h"

#import "HyTextFieldView.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <HyCategoriess/UIColor+HyExtension.h>
#import "HyMeModel.h"


@interface HyMeView ()
@property (nonatomic,strong) HyTextFieldView *accountTextFieldView;
@property (nonatomic,strong) HyTextFieldView *codeTextFieldView;
@end


@implementation HyMeView
- (void)viewLoad {
        
    [self configUI];
    [self configLayout];
    
    
    RAC(self.accountTextFieldView, text) = [RACObserve(self.dataProvider, account) distinctUntilChanged];
    RAC(self.dataProvider, account) = [self.accountTextFieldView.textSignal skip:1];

    RAC(self.codeTextFieldView, text) = [RACObserve(self.dataProvider, code) distinctUntilChanged];
    RAC(self.dataProvider, code) = [self.codeTextFieldView.textSignal skip:1];
}

- (void)configUI {
    [self addSubview:self.accountTextFieldView];
    [self addSubview:self.codeTextFieldView];
}

- (void)configLayout {
    
    [self.accountTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(50);
        make.height.mas_equalTo(36);
        make.right.mas_equalTo(-30);
    }];
    
    [self.codeTextFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTextFieldView);
        make.top.mas_equalTo(self.accountTextFieldView.mas_bottom).offset(20);
    }];
}

- (HyTextFieldView *)accountTextFieldView {
    if (!_accountTextFieldView){
        _accountTextFieldView = [[HyTextFieldView alloc] init];
        _accountTextFieldView.textField.placeholder = @"输入手机号码";
        _accountTextFieldView.maxLength = 11;;
    }
    return _accountTextFieldView;
}

- (HyTextFieldView *)codeTextFieldView {
    if (!_codeTextFieldView){
        _codeTextFieldView = [[HyTextFieldView alloc] init];
        _codeTextFieldView.textField.placeholder = @"输入验证码";
        _codeTextFieldView.maxLength = 6;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor hy_colorWithHexString:@"#3C8FF9"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btn.rac_command = self.viewModel.codeCommand;
        
        _codeTextFieldView.rightView = btn;
    }
    return _codeTextFieldView;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
