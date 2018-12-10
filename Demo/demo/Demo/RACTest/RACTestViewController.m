//
//  RACTestViewController.m
//  demo
//
//  Created by huangyi on 2018/11/15.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACTestViewController.h"
#import "RACTestTextFieldView.h"
#import "RACTestViewModel.h"
#import "HYBlockTextField.h"
#import "HYBlockTextView.h"


@interface RACTestViewController ()
@property (nonatomic,strong) UIButton *popButton;
@property (nonatomic,strong) UIButton *pushButton;
@property (nonatomic,strong) RACTestViewModel *viewModel;
@property (nonatomic,strong) RACTestTextFieldView *accountTextFieldView;
@property (nonatomic,strong) RACTestTextFieldView *codeTextFieldView;
@end


@implementation RACTestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configLayout];
}

- (void)configViewModel {
    RAC(self.viewModel, account) = self.accountTextFieldView.textSignal;
    RAC(self.viewModel, code) = self.codeTextFieldView.textSignal;
    self.pushButton.rac_command = self.viewModel.pushCommand;
    self.popButton.rac_command = self.viewModel.popCommand;
}

- (void)configUI {
    [self.view addSubview:self.accountTextFieldView];
    [self.view addSubview:self.codeTextFieldView];
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.popButton];
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
    
    [self.pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.accountTextFieldView);
        make.top.mas_equalTo(self.codeTextFieldView.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
    }];
    
    [self.popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.pushButton);
        make.top.mas_equalTo(self.pushButton.mas_bottom).offset(30);
    }];
}

- (UIButton *)pushButton {
    return Hy_Lazy(_pushButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:@"Push" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]]
                          forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor]]
                          forState:UIControlStateDisabled];
        button;
    }));
}

- (UIButton *)popButton {
    return Hy_Lazy(_popButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"Pop" forState:UIControlStateNormal];
        button.hidden = self.navigationController.childViewControllers.count < 2;
        button;
    }));
}

- (RACTestTextFieldView *)accountTextFieldView {
    return Hy_Lazy(_accountTextFieldView, ({
        
        RACTestTextFieldView *textFieldView = [[RACTestTextFieldView alloc] init];
        textFieldView.textField.placeholder = @"输入手机号码";
        textFieldView.maxLength = 11;
        textFieldView;
    }));
}

- (RACTestTextFieldView *)codeTextFieldView {
    return Hy_Lazy(_codeTextFieldView, ({
        
        RACTestTextFieldView *textFieldView = [[RACTestTextFieldView alloc] init];
        textFieldView.textField.placeholder = @"输入验证码";
        textFieldView.maxLength = 6;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#3C8FF9"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        textFieldView.rightView = btn;
        btn.rac_command = self.viewModel.codeCommand;
        textFieldView;
    }));
}

//- (HYBlockTextField *)textField {
//    return Hy_Lazy(_textField, ({
//        
//        HYBlockTextField *textField =
//        [HYBlockTextField blockTextFieldWithFrame:CGRectZero configureBlock:^(HYBlockTextFieldConfigure *configure) {
//            [[[[[configure configTextFieldShouldBeginEditing:^BOOL(UITextField *textField) {
//                
//                [self handleKeyboardWithView:textField spacing:10];
//                return YES;
//            }] configTextFieldDidBeginEditing:^(UITextField *textField) {
//                
//                NSLog(@"textFieldDidBeginEditing");
//            }] configTextFieldShouldChange:^BOOL(UITextField *textField, NSRange range, NSString *replacementString) {
//                
//                return YES;
//            }] configTextFieldShouldReturn:^BOOL(UITextField *textField) {
//                
//                [textField resignFirstResponder];
//                return YES;
//            }] configTextFieldDidEndEditing:^(UITextField *textField) {
//                
//                NSLog(@"textFieldDidEndEditing");
//            }];
//        }];
//        textField.placeholder = @"输入文字后Push";
//        textField.borderStyle = UITextBorderStyleRoundedRect;
//        textField;
//    }));
//}
//
//- (HYBlockTextView *)textView {
//    return Hy_Lazy(_textView, ({
//        
//        HYBlockTextView *textView =
//        [HYBlockTextView blockTextViewWithFrame:CGRectZero configureBlock:^(HYBlockTextViewConfigure *configure) {
//            [[[[[configure configTextViewShouldBeginEditing:^BOOL(UITextView *textView) {
//                
//                [self handleKeyboardWithView:textView spacing:10];
//                return YES;
//            }] configTextViewDidBeginEditing:^(UITextView *textView) {
//                
//                NSLog(@"textViewDidBeginEditing");
//            }] configTextViewShouldChangeTextInRange:^BOOL(UITextView *textView, NSRange range, NSString *text) {
//                
//                return YES;
//            }] configTextViewDidEndEditing:^(UITextView *textView) {
//                
//                NSLog(@"textViewEndEditing");
//            }] configTextViewShouldEndEditing:^BOOL(UITextView *textView) {
//                return YES;
//            }];
//            
//        }];
//        
//        textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        textView;
//    }));
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
