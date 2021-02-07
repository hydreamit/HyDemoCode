//
//  UITableView+HySignalExtension.m
//  DemoCode
//
//  Created by Hy on 2017/11/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "UITableView+HySignalExtension.h"

@implementation UITableView (HySignalExtension)

- (void)setHy_tableViewData:(id)hy_tableViewData {
    
    if ([hy_tableViewData isKindOfClass:RACSignal.class]) {
        objc_setAssociatedObject(self,
                                 @selector(hy_tableViewDataSignal),
                                 hy_tableViewData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        @weakify(self);
        [self hy_tableViewDataSignalDisposable:
        [[(RACSignal *)hy_tableViewData deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            objc_setAssociatedObject(self,
                                     @selector(hy_tableViewData),
                                     x,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self reloadData];
        }]];
    } else {
        objc_setAssociatedObject(self,
                                 @selector(hy_tableViewData),
                                 hy_tableViewData,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RACSignal *)hy_tableViewDataSignal {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)hy_tableViewDataSignalDisposable:(RACDisposable *)disp {
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
