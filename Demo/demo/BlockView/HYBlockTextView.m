//
//  HYBlockTextView.m
//  Demo
//
//  Created by huangyi on 2018/5/31.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockTextView.h"


@interface HYBlockTextViewConfigure ()
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
@end


@interface HYBlockTextView () <UITextViewDelegate>
@property (nonatomic,strong) HYBlockTextViewConfigure *configure;
@end

@implementation HYBlockTextView
+ (instancetype)blockTextViewWithFrame:(CGRect)frame
                             configure:(HYBlockTextViewConfigure *)configure {
    HYBlockTextView *textView = [[self alloc] init];
    textView.configure = configure;
    textView.delegate = textView;
    textView.frame = frame;
    return textView;
}

+ (instancetype)blockTextViewWithFrame:(CGRect)frame
                        configureBlock:(textViewConfigureBlock)configureBlock {
    HYBlockTextView *textView = [[self alloc] init];
    !configureBlock ?: configureBlock(textView.configure);
    textView.delegate = textView;
    textView.frame = frame;
    return textView;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return
    !self.configure.textViewShouldBeginEditing ?:
    self.configure.textViewShouldBeginEditing(textView);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return
    !self.configure.textViewShouldEndEditing ?:
    self.configure.textViewShouldEndEditing(textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    !self.configure.textViewDidBeginEditing ?:
    self.configure.textViewDidBeginEditing(textView);
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    !self.configure.textViewDidEndEditing ?:
    self.configure.textViewDidEndEditing(textView);
}

- (void)textViewDidChange:(UITextView *)textView {
    !self.configure.textViewDidChange ?:
    self.configure.textViewDidChange(textView);
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    !self.configure.textViewDidChangeSelection ?:
    self.configure.textViewDidChangeSelection(textView);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
     return
    !self.configure.textViewShouldChangeTextInRange ?:
    self.configure.textViewShouldChangeTextInRange(textView, range, text);
}

- (HYBlockTextViewConfigure *)configure {
    return Hy_Lazy(_configure, ({
        [[HYBlockTextViewConfigure alloc] init];
    }));
}

@end







