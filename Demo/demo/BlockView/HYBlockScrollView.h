//
//  HYBlockScrollView.h
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ScrollViewVoiBlock)(UIScrollView *scrollView);
typedef BOOL(^ScrollViewBoolBlock)(UIScrollView *scrollView);
typedef UIView *(^ScrollViewViewBlock)(UIScrollView *scrollView);
typedef void (^ScrollViewDecelerateBlock)(UIScrollView *scrollView, BOOL willDecelerate);
typedef void (^ScrollViewBeginZoomingBlock)(UIScrollView *scrollView, UIView *view);
typedef void (^ScrollViewEndZoomingBlock)(UIScrollView *scrollView, UIView *view, CGFloat scale);
typedef void (^ScrollViewVelocityBlock)(UIScrollView *scrollView,
                                        CGPoint velocity,
                                        CGPoint targetContentOffset);

@interface HYBlockScrollViewConfigure : NSObject
// 属性给子类用
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidScrollBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidZoomBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewWillBeginDeceleratingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidEndDeceleratingBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidEndScrollingAnimationBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidScrollToTopBlock;
@property (nonatomic,copy, readonly) ScrollViewVoiBlock scrollViewDidChangeAdjustedContentInsetBlock;
@property (nonatomic,copy, readonly) ScrollViewBoolBlock scrollViewShouldScrollToTopBlock;
@property (nonatomic,copy, readonly) ScrollViewViewBlock viewForZoomingInScrollViewBlock;
@property (nonatomic,copy, readonly) ScrollViewBeginZoomingBlock scrollViewWillBeginZoomingBlock;
@property (nonatomic,copy, readonly) ScrollViewEndZoomingBlock scrollViewDidEndZoomingBlock;
@property (nonatomic,copy, readonly) ScrollViewVelocityBlock scrollViewWillEndDraggingBlock;
@property (nonatomic,copy, readonly) ScrollViewDecelerateBlock scrollViewDidEndDraggingBlock;

- (instancetype)configScrollViewDidScroll:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewDidZoom:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewWillBeginDragging:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewWillBeginDecelerating:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewDidEndDecelerating:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewDidEndScrollingAnimation:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewDidScrollToTop:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewDidChangeAdjustedContentInset:(ScrollViewVoiBlock)block;
- (instancetype)configScrollViewShouldScrollToTop:(ScrollViewBoolBlock)block;
- (instancetype)configScrollViewForZoomingInScrollView:(ScrollViewViewBlock)block;
- (instancetype)configScrollViewWillBeginZooming:(ScrollViewBeginZoomingBlock)block;
- (instancetype)configScrollViewDidEndZooming:(ScrollViewEndZoomingBlock)block;
- (instancetype)configScrollViewWillEndDragging:(ScrollViewVelocityBlock)block;
- (instancetype)configScrollViewDidEndDragging:(ScrollViewDecelerateBlock)block;
@end



typedef void(^ScrollViewConfigureBlock)(HYBlockScrollViewConfigure *configure);
@interface HYBlockScrollView : UIScrollView

@property (nonatomic,strong,readonly) HYBlockScrollViewConfigure *configure;


/**
 block 创建方式
 
 @param frame frame
 @param configureBlock configureBlock
 @return HYBlockTextField
 */
+ (instancetype)blockScrollViewWithFrame:(CGRect)frame
                          configureBlock:(ScrollViewConfigureBlock)configureBlock;



@end



















