//
//  HyTipViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol HyTipViewBackgroundViewProtocol <NSObject>
- (void)addActionBlock:(void(^_Nullable)(void))block;
@end


@protocol HyTipViewPositionProtocol, HyTipViewAnimationProtocol;
@protocol HyTipViewProtocol <NSObject>

+ (UIView<HyTipViewProtocol> *(^)(UIView *contentView, CGFloat backViewAlpha))tipView;

- (void (^)(UIView *toView, id<HyTipViewPositionProtocol> position, id<HyTipViewAnimationProtocol> animation))show;

- (void(^)(id<HyTipViewAnimationProtocol> animation))dismiss;

- (UIView *)toView;
- (UIView *)contentView;
- (UIView<HyTipViewBackgroundViewProtocol> *)backgroundView;

@optional

- (UIView<HyTipViewProtocol> *(^)(NSArray<UIView *> *inViews))responseForInTipViews;
- (UIView<HyTipViewProtocol> *(^)(NSArray<UIView *> *outViews))responseForOutTipViews;

- (UIView<HyTipViewProtocol> *(^)(NSArray<NSValue *> *rectValues))notResponseRectValues;
- (UIView<HyTipViewProtocol> *(^)(NSArray<NSValue *> *rectValues))responseRectValues;

@end


NS_ASSUME_NONNULL_END








