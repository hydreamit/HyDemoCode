//
//  HyNewsViewModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/22.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyNewsViewModel.h"
#import "HyNewsModel.h"

@interface HyNewsViewModel ()
@property (nonatomic, strong)HyNewsModel *model;
@end

@implementation HyNewsViewModel
@dynamic model;

- (void)viewModelLoad {
    [super viewModelLoad];

    
}

@end
