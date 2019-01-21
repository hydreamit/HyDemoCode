//
//  HYBlockTextField.h
//  Demo
//
//  Created by huangyi on 2018/5/19.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TextFieldVoiBlock)(UITextField *textField);
typedef BOOL(^TextFieldBoolBlock)(UITextField *textField);
typedef BOOL(^TextFieldShouldChangeBlock)(UITextField *textField,
                                          NSRange range,
                                          NSString *replacementString);

@interface HYBlockTextFieldConfigure : NSObject
- (instancetype)configTextFieldShouldChange:(TextFieldShouldChangeBlock)block;
- (instancetype)configTextFieldShouldBeginEditing:(TextFieldBoolBlock)block;
- (instancetype)configTextFieldShouldEndEditing:(TextFieldBoolBlock)block;
- (instancetype)configTextFieldShouldReturn:(TextFieldBoolBlock)block;
- (instancetype)configTextFieldDidBeginEditing:(TextFieldVoiBlock)block;
- (instancetype)configTextFieldDidEndEditing:(TextFieldVoiBlock)block;
- (instancetype)configTextFieldShouldClear:(TextFieldBoolBlock)block;
@end



typedef void(^textFieldConfigureBlock)(HYBlockTextFieldConfigure *configure);
@interface HYBlockTextField : QMUITextField


/**
 创建方式
 
 @param frame frame
 @param configure configure
 @return HYBlockTextField
 */
+ (instancetype)blockTextFieldWithFrame:(CGRect)frame
                              configure:(HYBlockTextFieldConfigure *)configure;


/**
 block 创建方式

 @param frame frame
 @param configureBlock configureBlock
 @return HYBlockTextField
 */
+ (instancetype)blockTextFieldWithFrame:(CGRect)frame
                         configureBlock:(textFieldConfigureBlock)configureBlock;


@end























