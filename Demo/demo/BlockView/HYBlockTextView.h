//
//  HYBlockTextView.h
//  Demo
//
//  Created by huangyi on 2018/5/31.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HYBlockTextViewConfigure : NSObject

- (instancetype)configTextViewShouldBeginEditing:(BOOL(^)(UITextView *textView))block;
- (instancetype)configTextViewShouldEndEditing:(BOOL(^)(UITextView *textView))block;
- (instancetype)configTextViewDidBeginEditing:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidEndEditing:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidChange:(void(^)(UITextView *textView))block;
- (instancetype)configTextViewDidChangeSelection:(void(^)(UITextView *textView))block;

- (instancetype)configTextViewShouldChangeTextInRange:(BOOL(^)(UITextView *textView, NSRange range, NSString *text))block;

@end


typedef void(^TextViewConfigureBlock)(HYBlockTextViewConfigure *configure);
@interface HYBlockTextView : UITextView

@property (nonatomic,strong,readonly) HYBlockTextViewConfigure *configure;


/**
 block 创建方式
 
 @param frame frame
 @param configureBlock configureBlock
 @return HYBlockTextField
 */
+ (instancetype)blockTextViewWithFrame:(CGRect)frame
                        configureBlock:(TextViewConfigureBlock)configureBlock;


@end













