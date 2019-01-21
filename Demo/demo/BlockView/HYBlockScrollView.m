//
//  HYBlockScrollView.m
//  Demo
//
//  Created by huangyi on 2018/5/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBlockScrollView.h"

@interface HYBlockScrollViewConfigure ()
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
@end



@interface HYBlockScrollView () <UIScrollViewDelegate>
@property (nonatomic,strong) HYBlockScrollViewConfigure *configure;
@end

@implementation HYBlockScrollView

+ (instancetype)blockScrollViewWithFrame:(CGRect)frame
                               configure:(HYBlockScrollViewConfigure *)configure {
    HYBlockScrollView *scrollView = [[self alloc] init];
    scrollView.configure = configure;
    scrollView.delegate = scrollView;
    return scrollView;
}

+ (instancetype)blockScrollViewWithFrame:(CGRect)frame
                          configureBlock:(scrollViewConfigureBlock)configureBlock {
    HYBlockScrollView *scrollView = [[self alloc] init];
    !configureBlock ?: configureBlock(scrollView.configure);
     scrollView.delegate = scrollView;
    return scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollBlock ?:
     self.configure.scrollViewDidScrollBlock(scrollView);
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView  {
    !self.configure.scrollViewDidZoomBlock ?:
     self.configure.scrollViewDidZoomBlock(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDraggingBlock ?:
     self.configure.scrollViewWillBeginDraggingBlock(scrollView);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewWillBeginDeceleratingBlock ?:
    self.configure.scrollViewWillBeginDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndDeceleratingBlock ?:
     self.configure.scrollViewDidEndDeceleratingBlock(scrollView);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidEndScrollingAnimationBlock ?:
    self.configure.scrollViewDidEndScrollingAnimationBlock(scrollView);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return
    self.configure.viewForZoomingInScrollViewBlock ?
    self.configure.viewForZoomingInScrollViewBlock(scrollView) : nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.configure.scrollViewWillEndDraggingBlock ?
    self.configure.scrollViewWillEndDraggingBlock(scrollView, velocity, *targetContentOffset) : nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.configure.scrollViewDidEndDraggingBlock ?
    self.configure.scrollViewDidEndDraggingBlock(scrollView, decelerate) : nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    self.configure.scrollViewWillBeginZoomingBlock ?
    self.configure.scrollViewWillBeginZoomingBlock(scrollView, view) : nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    self.configure.scrollViewDidEndZoomingBlock ?
    self.configure.scrollViewDidEndZoomingBlock(scrollView, view, scale) : nil;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return
    self.configure.scrollViewShouldScrollToTopBlock ?
    self.configure.scrollViewShouldScrollToTopBlock(scrollView) : YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidScrollToTopBlock ?:
    self.configure.scrollViewDidScrollToTopBlock(scrollView);
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    !self.configure.scrollViewDidChangeAdjustedContentInsetBlock ?:
    self.configure.scrollViewDidChangeAdjustedContentInsetBlock(scrollView);
}

- (HYBlockScrollViewConfigure *)configure {
    return Hy_Lazy(_configure, ({
        [[HYBlockScrollViewConfigure alloc] init];
    }));
}

@end













