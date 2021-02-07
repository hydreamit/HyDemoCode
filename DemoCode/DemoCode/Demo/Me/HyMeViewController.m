//
//  HyMeViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyMeViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import <HyCategoriess/HyCategories.h>
#import "HyMeViewModel.h"
#import "HyMeView.h"


@interface HyMeViewController ()
@property (nonatomic,strong) UIButton *popButton;
@property (nonatomic,strong) UIButton *pushButton;
@end


@implementation HyMeViewController

- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    UIView<HyViewProtocol> *meView =
    [HyMeView viewWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)
                  viewModel:self.viewModel
                  parameter:nil];
    
    [self.view addSubview:meView];
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.popButton];
    [self.pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(meView.mas_bottom).offset(50);
        make.height.mas_equalTo(40);
   }];
   [self.popButton mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.height.equalTo(self.pushButton);
       make.top.mas_equalTo(self.pushButton.mas_bottom).offset(30);
   }];
}

- (void)hy_viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)viewModelDidLoad {
    
    self.pushButton.rac_command = self.viewModel.command(@"push");
    self.popButton.rac_command = self.viewModel.command(@"pop");
}

- (void)popFromViewController:(NSString *)name parameter:(id)parameter {
    [self.viewModel setModelWithParameter:parameter];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIButton *)pushButton {
    if (!_pushButton){
        _pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushButton setTitle:@"Push" forState:UIControlStateNormal];
        _pushButton.backgroundColor = UIColor.orangeColor;
        RAC(_pushButton, backgroundColor) =
        [[_pushButton rac_signalForSelector:@selector(setEnabled:)] map:^id _Nullable(RACTuple * _Nullable value) {
            return [value.first boolValue] ? UIColor.orangeColor : [UIColor hy_colorWithHexString:@"#D5DCE4"];
        }];
        _pushButton.enabled = NO;
    }
    return _pushButton;
}

- (UIButton *)popButton {
    if (!_popButton){
        _popButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _popButton.backgroundColor = [UIColor blueColor];
        [_popButton setTitle:@"Pop" forState:UIControlStateNormal];
        _popButton.hidden = self.navigationController.childViewControllers.count < 2;;
    }
    return _popButton;
}

- (void)dealloc {
    
    NSLog(@"==========xxxxxxxxxxx");
    
}

@end
