//
//  UICollectionView+HySignalExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UICollectionView+HySignalExtension.h"


@implementation UICollectionView (HySignalExtension)

- (void)setHy_collectionViewData:(id)hy_collectionViewData {
    
    if ([hy_collectionViewData isKindOfClass:RACSignal.class]) {
        objc_setAssociatedObject(self,
                                 @selector(hy_collectionViewDataSignal),
                                 hy_collectionViewData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(self);
        [self hy_collectionViewDataSignalDisposable:
        [[(RACSignal *)hy_collectionViewData deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            objc_setAssociatedObject(self,
                                     @selector(hy_collectionViewData),
                                     x,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self reloadData];
        }]];
        
    } else {
        objc_setAssociatedObject(self,
                                 @selector(hy_collectionViewData),
                                 hy_collectionViewData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RACSignal *)hy_collectionViewDataSignal {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)hy_collectionViewDataSignalDisposable:(RACDisposable *)disp {
    RACDisposable *disposable = objc_getAssociatedObject(self, _cmd);
    if (disposable != NULL) {
        [disposable dispose];
    }
    objc_setAssociatedObject(self,
                             _cmd,
                             disp,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
