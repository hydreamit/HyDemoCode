//
//  HYBlockTextField.m
//  HYWallet
//
//  Created by huangyi on 2018/5/19.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTextField.h"

@interface HYBlockTextFieldConfigure()
@property (nonatomic,copy) TextFieldShouldChangeBlock textFieldShouldChangeBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldBeginEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldEndEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldReturnBlock;
@property (nonatomic,copy) TextFieldVoiBlock textFieldDidBeginEditingBlock;
@property (nonatomic,copy) TextFieldVoiBlock textFieldDidEndEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldClearBlock;
@end

@implementation HYBlockTextFieldConfigure
- (instancetype)configTextFieldShouldChange:(TextFieldShouldChangeBlock)block {
    self.textFieldShouldChangeBlock = block;
    return self;
}
- (instancetype)configTextFieldShouldBeginEditing:(TextFieldBoolBlock)block {
    self.textFieldShouldBeginEditingBlock = block;
    return self;
}
- (instancetype)configTextFieldShouldEndEditing:(TextFieldBoolBlock)block {
    self.textFieldShouldEndEditingBlock = block;
    return self;
}
- (instancetype)configTextFieldShouldReturn:(TextFieldBoolBlock)block {
    self.textFieldShouldReturnBlock = block;
    return self;
}
- (instancetype)configTextFieldDidBeginEditing:(TextFieldVoiBlock)block {
    self.textFieldDidBeginEditingBlock = block;
    return self;
}
- (instancetype)configTextFieldDidEndEditing:(TextFieldVoiBlock)block {
    self.textFieldDidEndEditingBlock = block;
    return self;
}
- (instancetype)configTextFieldShouldClear:(TextFieldBoolBlock)block {
    self.textFieldShouldClearBlock = block;
    return self;
}
@end



@interface HYBlockTextField () <UITextFieldDelegate>
@property (nonatomic,strong) HYBlockTextFieldConfigure *configure;
@end


@implementation HYBlockTextField

+ (instancetype)blockTextFieldWithFrame:(CGRect)frame
                        configureBlock:(textFieldConfigureBlock)configureBlock {
    HYBlockTextField *textField = [[self alloc] init];
    !configureBlock ?: configureBlock(textField.configure);
    textField.delegate = textField;
    textField.frame = frame;
    return textField;
}

+ (instancetype)blockTextFieldWithFrame:(CGRect)frame
                             configure:(HYBlockTextFieldConfigure *)configure {
    HYBlockTextField *textField = [[self alloc] init];
    textField.configure = configure;
    textField.delegate = textField;
    textField.frame = frame;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return
    self.configure.textFieldShouldBeginEditingBlock ?
    self.configure.textFieldShouldBeginEditingBlock(textField) : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.configure.textFieldDidBeginEditingBlock ?
    self.configure.textFieldDidBeginEditingBlock(textField) : nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return
    self.configure.textFieldShouldEndEditingBlock ?
    self.configure.textFieldShouldEndEditingBlock(textField) : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.configure.textFieldDidEndEditingBlock ?
    self.configure.textFieldDidEndEditingBlock(textField) : nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    return
    self.configure.textFieldShouldChangeBlock ?
    self.configure.textFieldShouldChangeBlock(textField, range, string) : YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return
    self.configure.textFieldShouldClearBlock ?
    self.configure.textFieldShouldClearBlock(textField) : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return
    self.configure.textFieldShouldReturnBlock ?
    self.configure.textFieldShouldReturnBlock(textField) : YES;
}

- (HYBlockTextFieldConfigure *)configure {
    return Hy_Lazy(_configure, ({
        [[HYBlockTextFieldConfigure alloc] init];
    }));
}

@end












