//
//  HYBlockScrollView.m
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockScrollView.h"

@interface HYBlockScrollViewConfigure () <UIScrollViewDelegate>
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidScrollBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidZoomBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewWillBeginDraggingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewWillBeginDeceleratingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidEndDeceleratingBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidEndScrollingAnimationBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidScrollToTopBlock;
@property (nonatomic,copy) ScrollViewVoiBlock scrollViewDidChangeAdjustedContentInsetBlock;
@property (nonatomic,copy) ScrollViewBoolBlock scrollViewShouldScrollToTopBlock;
@property (nonatomic,copy) ScrollViewViewBlock viewForZoomingInScrollViewBlock;
@property (nonatomic,copy) ScrollViewBeginZoomingBlock scrollViewWillBeginZoomingBlock;
@property (nonatomic,copy) ScrollViewEndZoomingBlock scrollViewDidEndZoomingBlock;
@property (nonatomic,copy) ScrollViewVelocityBlock scrollViewWillEndDraggingBlock;
@property (nonatomic,copy) ScrollViewDecelerateBlock scrollViewDidEndDraggingBlock;
@end


@implementation HYBlockScrollViewConfigure
- (instancetype)configScrollViewDidScroll:(ScrollViewVoiBlock)block {
    self.scrollViewDidScrollBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidZoom:(ScrollViewVoiBlock)block {
    self.scrollViewDidZoomBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginDragging:(ScrollViewVoiBlock)block{
    self.scrollViewWillBeginDraggingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginDecelerating:(ScrollViewVoiBlock)block{
    self.scrollViewWillBeginDeceleratingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndDecelerating:(ScrollViewVoiBlock)block{
    self.scrollViewDidEndDeceleratingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndScrollingAnimation:(ScrollViewVoiBlock)block{
    self.scrollViewDidEndScrollingAnimationBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidScrollToTop:(ScrollViewVoiBlock)block{
    self.scrollViewDidScrollToTopBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidChangeAdjustedContentInset:(ScrollViewVoiBlock)block{
    self.scrollViewDidChangeAdjustedContentInsetBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewShouldScrollToTop:(ScrollViewBoolBlock)block{
    self.scrollViewShouldScrollToTopBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewForZoomingInScrollView:(ScrollViewViewBlock)block{
    self.viewForZoomingInScrollViewBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewWillBeginZooming:(ScrollViewBeginZoomingBlock)block{
    self.scrollViewWillBeginZoomingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndZooming:(ScrollViewEndZoomingBlock)block{
    self.scrollViewDidEndZoomingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewWillEndDragging:(ScrollViewVelocityBlock)block{
    self.scrollViewWillEndDraggingBlock = [block copy];
    return self;
}
- (instancetype)configScrollViewDidEndDragging:(ScrollViewDecelerateBlock)block{
    self.scrollViewDidEndDraggingBlock = [block copy];
    return self;
}

#pragma mark — UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollViewDidScrollBlock ?:
    self.scrollViewDidScrollBlock(scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.scrollViewDidZoomBlock ?:
    self.scrollViewDidZoomBlock(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDraggingBlock ?:
    self.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewWillBeginDeceleratingBlock ?:
    self.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.scrollViewDidEndDeceleratingBlock ?:
    self.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.scrollViewDidEndScrollingAnimationBlock ?:
    self.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.viewForZoomingInScrollViewBlock ?
    self.viewForZoomingInScrollViewBlock(scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.scrollViewWillEndDraggingBlock ?
    self.scrollViewWillEndDraggingBlock(scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scrollViewDidEndDraggingBlock ?
    self.scrollViewDidEndDraggingBlock(scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.scrollViewWillBeginZoomingBlock ?
    self.scrollViewWillBeginZoomingBlock(scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.scrollViewDidEndZoomingBlock ?
    self.scrollViewDidEndZoomingBlock(scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.scrollViewShouldScrollToTopBlock ?
    self.scrollViewShouldScrollToTopBlock(scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.scrollViewDidScrollToTopBlock ?:
    self.scrollViewDidScrollToTopBlock(scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.scrollViewDidChangeAdjustedContentInsetBlock ?:
    self.scrollViewDidChangeAdjustedContentInsetBlock(scrollView);
}

@end



@interface HYBlockScrollView ()
@property (nonatomic,strong) HYBlockScrollViewConfigure *configure;
@end

@implementation HYBlockScrollView

+ (instancetype)blockScrollViewWithFrame:(CGRect)frame
                          configureBlock:(ScrollViewConfigureBlock)configureBlock {
    
    HYBlockScrollView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.configure = [[HYBlockScrollViewConfigure alloc] init];
    !configureBlock ?: configureBlock(scrollView.configure);
    scrollView.delegate = scrollView.configure;
    return scrollView;
}

@end













