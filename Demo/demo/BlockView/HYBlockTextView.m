//
//  HYBlockTextView.m
//  Demo
//
//  Created by huangyi on 2018/5/31.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTextView.h"


@interface HYBlockTextViewConfigure () <UITextViewDelegate>
@property (nonatomic,copy) BOOL(^textViewShouldBeginEditing)(UITextView *textView);
@property (nonatomic,copy) BOOL(^textViewShouldEndEditing)(UITextView *textView);
@property (nonatomic,copy) void(^textViewDidBeginEditing)(UITextView *textView);
@property (nonatomic,copy) void(^textViewDidEndEditing)(UITextView *textView);
@property (nonatomic,copy) void(^textViewDidChange)(UITextView *textView);
@property (nonatomic,copy) void(^textViewDidChangeSelection)(UITextView *textView);
@property (nonatomic,copy) BOOL(^textViewShouldChangeTextInRange)
                              (UITextView *textView, NSRange range, NSString *text);
@end
@implementation HYBlockTextViewConfigure
- (instancetype)configTextViewShouldBeginEditing:(BOOL(^)(UITextView *textView))block {
    self.textViewShouldBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewShouldEndEditing:(BOOL(^)(UITextView *textView))block {
    self.textViewShouldEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidBeginEditing:(void(^)(UITextView *textView))block {
    self.textViewDidBeginEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidEndEditing:(void(^)(UITextView *textView))block {
    self.textViewDidEndEditing = [block copy];
    return self;
}
- (instancetype)configTextViewDidChange:(void(^)(UITextView *textView))block {
    self.textViewDidChange = [block copy];
    return self;
}
- (instancetype)configTextViewDidChangeSelection:(void(^)(UITextView *textView))block {
    self.textViewDidChangeSelection = [block copy];
    return self;
}
- (instancetype)configTextViewShouldChangeTextInRange:(BOOL(^)(UITextView *textView, NSRange range, NSString *text))block {
    self.textViewShouldChangeTextInRange = [block copy];
    return self;
}

#pragma mark — UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return
    !self.textViewShouldBeginEditing ?:
    self.textViewShouldBeginEditing(textView);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return
    !self.textViewShouldEndEditing ?:
    self.textViewShouldEndEditing(textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    !self.textViewDidBeginEditing ?:
    self.textViewDidBeginEditing(textView);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    !self.textViewDidEndEditing ?:
    self.textViewDidEndEditing(textView);
}

- (void)textViewDidChange:(UITextView *)textView {
    !self.textViewDidChange ?:
    self.textViewDidChange(textView);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    !self.textViewDidChangeSelection ?:
    self.textViewDidChangeSelection(textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return
    !self.textViewShouldChangeTextInRange ?:
    self.textViewShouldChangeTextInRange(textView, range, text);
}

@end


@interface HYBlockTextView ()
@property (nonatomic,strong) HYBlockTextViewConfigure *configure;
@end

@implementation HYBlockTextView

+ (instancetype)blockTextViewWithFrame:(CGRect)frame
                        configureBlock:(TextViewConfigureBlock)configureBlock {
    
    HYBlockTextView *textView = [[self alloc] initWithFrame:frame];
    textView.configure = [[HYBlockTextViewConfigure alloc] init];
    !configureBlock ?: configureBlock(textView.configure);
    textView.delegate = textView.configure;
    return textView;
}

@end







