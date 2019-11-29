//
//  UITextField+HyExtension.h
//  HyCategories
//  https://github.com/hydreamit/HyCategories
//
//  Created by Hy on 2017/8/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTextFieldDelegateConfigure : NSObject
- (instancetype)configTextFieldShouldBeginEditing:(BOOL (^)(UITextField *textField))block;
- (instancetype)configTextFieldShouldEndEditing:(BOOL (^)(UITextField *textField))block;
- (instancetype)configTextFieldShouldReturn:(BOOL (^)(UITextField *textField))block;
- (instancetype)configTextFieldDidBeginEditing:(void (^)(UITextField *textField))block;
- (instancetype)configTextFieldDidEndEditing:(void (^)(UITextField *textField))block;
- (instancetype)configTextFieldShouldClear:(BOOL (^)(UITextField *textField))block;
- (instancetype)configTextFieldShouldChange:(BOOL (^)(UITextField *textField, NSRange range, NSString *replacementString))block;
@end



@interface UITextField (HyExtension)

@property (nonatomic,assign) UIEdgeInsets hy_textInsets;
@property (nonatomic,strong) UIColor *hy_placeholderColor;
@property (nonatomic,strong,readonly) HyTextFieldDelegateConfigure *hy_delegateConfigure;


+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                          placeholder:(NSString *)placeholder
                     placeholderColor:(UIColor *)placeholderColor
                             delegate:(id<UITextFieldDelegate>)delegate;


+ (instancetype)hy_textFieldWithFrame:(CGRect)frame
                                 font:(UIFont *)font
                                 text:(NSString *)text
                            textColor:(UIColor *)textColor
                          placeholder:(NSString *)placeholder
                     placeholderColor:(UIColor *)placeholderColor
                    delegateConfigure:(void(^)(HyTextFieldDelegateConfigure *configure))delegateConfigure;


- (NSRange)hy_selectedRange;
- (void)hy_selecteTextWithRange:(NSRange)range;
- (void)hy_selectAllText;


- (void)hy_insertOrReplaceEdittingText:(NSString *)text;
- (void)hy_setTextKeepingSelectedRange:(NSString *)text;
- (void)hy_setAttributedTextKeepingSelectedRange:(NSAttributedString *)attributedText;

@end

NS_ASSUME_NONNULL_END
