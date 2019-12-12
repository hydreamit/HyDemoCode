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
@synthesize listModelArray = _listModelArray;

- (NSMutableArray<NSObject<HyListModelProtocol> *> *)listModelArray {
    if (!_listModelArray) {
        _listModelArray = @[].mutableCopy;
    }
    return _listModelArray;
}

@end
