//
//  NSObject+HyRACExtension.h
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HyRACExtension)

#pragma mark - SEL
@property (nonatomic,copy,readonly) RACSignal<RACTuple *> *(^signalForSelector)(SEL);
@property (nonatomic,copy,readonly) RACSignal<RACTuple *> *(^signalForSelectorFromProtocol)(SEL, Protocol *);
@property (nonatomic,copy,readonly) RACSignal *(^liftSelectorWithSignals)(SEL, NSArray<RACSignal *> *);

@end

NS_ASSUME_NONNULL_END
