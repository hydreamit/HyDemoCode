//
//  HYBlockTextField.m
//  Demo
//
//  Created by huangyi on 2018/5/19.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTextField.h"

@interface HYBlockTextFieldConfigure() <QMUITextFieldDelegate>
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

#pragma mark — UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return
    self.textFieldShouldBeginEditingBlock ?
    self.textFieldShouldBeginEditingBlock(textField) : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldDidBeginEditingBlock ?
    self.textFieldDidBeginEditingBlock(textField) : nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return
    self.textFieldShouldEndEditingBlock ?
    self.textFieldShouldEndEditingBlock(textField) : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.textFieldDidEndEditingBlock ?
    self.textFieldDidEndEditingBlock(textField) : nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return
    self.textFieldShouldChangeBlock ?
    self.textFieldShouldChangeBlock(textField, range, string) : YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return
    self.textFieldShouldClearBlock ?
    self.textFieldShouldClearBlock(textField) : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return
    self.textFieldShouldReturnBlock ?
    self.textFieldShouldReturnBlock(textField) : YES;
}
@end



@interface HYBlockTextField ()
@property (nonatomic,strong) HYBlockTextFieldConfigure *configure;
@end


@implementation HYBlockTextField

+ (instancetype)blockTextFieldWithFrame:(CGRect)frame
                         configureBlock:(TextFieldConfigureBlock)configureBlock {
    
    HYBlockTextField *textField = [[self alloc] initWithFrame:frame];
    textField.configure = [[HYBlockTextFieldConfigure alloc] init];
    !configureBlock ?: configureBlock(textField.configure);
    textField.delegate = textField.configure;
    return textField;
}

@end












