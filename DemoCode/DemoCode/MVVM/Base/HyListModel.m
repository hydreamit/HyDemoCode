//
//  HyListModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyListModel.h"
#import <objc/runtime.h>

@implementation HyListModel

- (void)setListDataArray:(NSMutableArray *)listModelArray {
    objc_setAssociatedObject(self,
                             @selector(listModelArray),
                             listModelArray,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<NSObject<HyListModelProtocol> *> *)listModelArray {
    
    id array = objc_getAssociatedObject(self, _cmd);
    if (array == NULL) {
        array = @[].mutableCopy;
        objc_setAssociatedObject(self,
                                 _cmd,
                                 array,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

@end
