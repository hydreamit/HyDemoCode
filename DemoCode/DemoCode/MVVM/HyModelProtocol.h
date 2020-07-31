//
//  HyModelProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/19.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol HyModelProtocol <NSObject>
@optional
+ (instancetype)modelWithParameter:(nullable NSDictionary *)parameter;
@property (nonatomic,strong) NSDictionary *parameter;
- (void)modelLoad;
@end



NS_ASSUME_NONNULL_END
