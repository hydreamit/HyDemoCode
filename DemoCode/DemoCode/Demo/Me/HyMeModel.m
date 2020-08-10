//
//  HyMeModel.m
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyMeModel.h"
#import "HyModelParser.h"

@implementation HyMeModel

- (void)modelLoad {
    
}

//+ (NSArray<NSString *> *)hy_modelPropertyBlacklist {
//    return @[@"account"];
//}

- (void)hy_modelDidParsedWithDictionary:(NSDictionary *)dictionary {
    NSLog(@"hy_modelDidParsedWithDictionary====%@", dictionary);
}

@end
