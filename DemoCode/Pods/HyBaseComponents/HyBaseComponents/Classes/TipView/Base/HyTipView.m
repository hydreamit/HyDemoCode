//
//  HyTipView.m
//  DemoCode
//
//  Created by Hy on 2017/12/2.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyTipView.h"
#import "HyTipViewAnimationProtocol.h"
#import "HyTipViewPositionProtocol.h"


@interface HyTipViewBackgroundView : UIButton <HyTipViewBackgroundViewProtocol>
@property (nonatomic,copy) void(^block)(void);
@end

@implementation HyTipViewBackgroundView
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super addTarget:self action:@selector(btnAction) forControlEvents:controlEvents];
}
- (void)addActionBlock:(void(^)(void))block {
    self.block = [block copy];
}
- (void)btnAction {
    !self.block ?: self.block();
}
@end


@interface HyTipView ()
@property (nonatomic,weak) UIView *toView;
@property (nonatomic,weak) UIView *contentV;
@property (nonatomic,strong) HyTipViewBackgroundView *backgroundV;
@property (nonatomic,strong) NSMutableArray<NSValue *> *rectValues;
@property (nonatomic,strong) NSMutableArray<NSValue *> *notRectValues;
@end


@implementation HyTipView

+ (UIView<HyTipViewProtocol> *(^)(UIView *contentView, CGFloat backViewAlpha))tipView {
    return ^UIView<HyTipViewProtocol> *(UIView *contentView, CGFloat backViewAlpha) {
        
        if (!contentView) {
           return nil;
        }

        HyTipView *tipView = [[self alloc] initWithFrame:CGRectZero];
        tipView.contentV = contentView;
        
        if (backViewAlpha > 0.01) {
            tipView.backgroundV.backgroundColor = UIColor.blackColor;
            tipView.backgroundV.alpha = backViewAlpha;
        }
        [tipView addSubview:tipView.backgroundV];
        [tipView addSubview:contentView];
        
        return tipView;
    };
}

- (void (^)(UIView *toView, id<HyTipViewPositionProtocol> position, id<HyTipViewAnimationProtocol> animation))show {
     __weak typeof(self) _self = self;
     return ^(UIView *toView, id<HyTipViewPositionProtocol> position, id<HyTipViewAnimationProtocol> animation){
        __strong typeof(_self) self = _self;
        
        self.frame = toView.bounds;
        [toView addSubview:self];
        self.toView = toView;
        
         if ([position conformsToProtocol:@protocol(HyTipViewPositionProtocol)] &&
             [position respondsToSelector:@selector(positionAction)]) {
             position.positionAction(self);
         }

         if ([animation conformsToProtocol:@protocol(HyTipViewAnimationProtocol)] &&
             [animation respondsToSelector:@selector(animation)]) {
             animation.animation(self);
         }
    };
}

- (void(^)(id<HyTipViewAnimationProtocol> animation))dismiss {
     __weak typeof(self) _self = self;
     return ^(id<HyTipViewAnimationProtocol> animation){
        __strong typeof(_self) self = _self;
         if ([animation conformsToProtocol:@protocol(HyTipViewAnimationProtocol)] &&
             [animation respondsToSelector:@selector(animation)]) {
             animation.animation(self);
         }
    };
}

- (UIView<HyTipViewProtocol> *(^)(NSArray<UIView *> *inViews))responseForInTipViews {
    __weak typeof(self) _self = self;
    return ^UIView<HyTipViewProtocol> *(NSArray<UIView *> *inViews){
        __strong typeof(_self) self = _self;
        
        NSMutableArray *array = @[].mutableCopy;
        [inViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
        [self.rectValues addObjectsFromArray:array];
        return self;
    };
}

- (UIView<HyTipViewProtocol> *(^)(NSArray<UIView *> *outViews))responseForOutTipViews {
    __weak typeof(self) _self = self;
    return ^UIView<HyTipViewProtocol> *(NSArray<UIView *> *outViews){
        __strong typeof(_self) self = _self;
        
        NSMutableArray *array = @[].mutableCopy;
        [outViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:[NSValue valueWithCGRect:[obj.superview convertRect:obj.frame toView:self]]];
        }];
        [self.notRectValues addObjectsFromArray:array];
        return self;
    };
}

- (UIView<HyTipViewProtocol> *(^)(NSArray<NSValue *> *rectValues))notResponseRectValues {
    __weak typeof(self) _self = self;
    return ^UIView<HyTipViewProtocol> *(NSArray<NSValue *> *rectValues){
        __strong typeof(_self) self = _self;
        [self.notRectValues addObjectsFromArray:rectValues];
        return self;
    };
}

- (UIView<HyTipViewProtocol> *(^)(NSArray<NSValue *> *rectValues))responseRectValues {
    __weak typeof(self) _self = self;
    return ^UIView<HyTipViewProtocol> *(NSArray<NSValue *> *rectValues){
        __strong typeof(_self) self = _self;
        [self.rectValues addObjectsFromArray:rectValues];
        return self;
    };
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *histV = [super hitTest:point withEvent:event];
//    if (histV == self.contentView) {
//        return histV;
//    }
//    return nil;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    BOOL (^checkContains)(NSArray<NSValue *> *) = ^BOOL (NSArray<NSValue *> *rectValues){
        __block BOOL contains = NO;
        [rectValues enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = obj.CGRectValue;
            if (CGRectContainsPoint(rect, point)) {
                contains = YES;
                *stop = YES;
            }
        }];
        return contains;
    };
    
    if (self.rectValues.count) {
        return checkContains(self.rectValues);
    } else if (self.notRectValues.count) {
        return !checkContains(self.notRectValues);
    }
    
    return [super pointInside:point withEvent:event];
}

- (UIView *)toView {
    return self.toView;
}

- (UIView *)contentView {
    return self.contentV;
}

- (UIView *)backgroundView {
    return self.backgroundV;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundV.frame = self.bounds;
}

- (HyTipViewBackgroundView *)backgroundV {
    if (!_backgroundV){
        _backgroundV = [HyTipViewBackgroundView buttonWithType:UIButtonTypeCustom];
        [_backgroundV addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundV;
}- (void)action{}

- (NSMutableArray<NSValue *> *)rectValues {
    if (!_rectValues){
        _rectValues = @[].mutableCopy;
    }
    return _rectValues;
}

- (NSMutableArray<NSValue *> *)notRectValues {
    if (!_notRectValues){
        _notRectValues = @[].mutableCopy;
    }
    return _notRectValues;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
