//
//  RACTestViewController.m
//  demo
//
//  Created by huangyi on 2018/11/15.
//  Copyright © 2018年 huangyi. All rights reserved.
//

#import "RACTestViewController.h"
#import "HYBlockTextField.h"
#import "HYBlockTextView.h"


@interface RACTestViewController ()
@property (nonatomic,strong) UIButton *pushButton;
@property (nonatomic,strong) UIButton *popButton;
@property (nonatomic,strong) HYBlockTextField *textField;
@property (nonatomic,strong) HYBlockTextView *textView;
@end


@implementation RACTestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configLayout];
    [self configSignal];
}

- (void)configSignal {
    
    self.popButton.rac_command = RACCommand.popCommand(@"",@{});
    
    RACSignal *pushEnabledSignal =
    [[self.textField.rac_textSignal merge:RACObserve(self.textField, text)]
     map:^id (NSString *value) {
         return @(value.length);
    }];
    
    self.pushButton.rac_command =
    RACCommand.pushEnabledCommand(pushEnabledSignal, @"RACTestViewController", @"", @{});
}

- (void)configUI {
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.popButton];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
}

- (void)configLayout {
    
    [self.popButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 50));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(50);
    }];
    [self.pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.popButton);
        make.centerX.equalTo(self.popButton);
        make.top.mas_equalTo(self.popButton.mas_bottom).offset(50);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 50));
        make.centerX.equalTo(self.pushButton);
        make.top.mas_equalTo(self.pushButton.mas_bottom).offset(50);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 150));
        make.centerX.equalTo(self.pushButton);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(50);
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

- (HYBlockTextField *)textField {
    return Hy_Lazy(_textField, ({
        
        HYBlockTextField *textField =
        [HYBlockTextField blockTextFieldWithFrame:CGRectZero configureBlock:^(HYBlockTextFieldConfigure *configure) {
            [[[[[configure configTextFieldShouldBeginEditing:^BOOL(UITextField *textField) {
                
                [self handleKeyboardWithView:textField spacing:10];
                return YES;
            }] configTextFieldDidBeginEditing:^(UITextField *textField) {
                
                NSLog(@"textFieldDidBeginEditing");
            }] configTextFieldShouldChange:^BOOL(UITextField *textField, NSRange range, NSString *replacementString) {
                
                return YES;
            }] configTextFieldShouldReturn:^BOOL(UITextField *textField) {
                
                [textField resignFirstResponder];
                return YES;
            }] configTextFieldDidEndEditing:^(UITextField *textField) {
                
                NSLog(@"textFieldDidEndEditing");
            }];
        }];
        textField.placeholder = @"输入文字后Push";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField;
    }));
}

- (HYBlockTextView *)textView {
    return Hy_Lazy(_textView, ({
        
        HYBlockTextView *textView =
        [HYBlockTextView blockTextViewWithFrame:CGRectZero configureBlock:^(HYBlockTextViewConfigure *configure) {
            [[[[[configure configTextViewShouldBeginEditing:^BOOL(UITextView *textView) {
                
                [self handleKeyboardWithView:textView spacing:10];
                return YES;
            }] configTextViewDidBeginEditing:^(UITextView *textView) {
                
                NSLog(@"textViewDidBeginEditing");
            }] configTextViewShouldChangeTextInRange:^BOOL(UITextView *textView, NSRange range, NSString *text) {
                
                return YES;
            }] configTextViewDidEndEditing:^(UITextView *textView) {
                
                NSLog(@"textViewEndEditing");
            }] configTextViewShouldEndEditing:^BOOL(UITextView *textView) {
                return YES;
            }];
            
        }];
        
        textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        textView;
    }));
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
