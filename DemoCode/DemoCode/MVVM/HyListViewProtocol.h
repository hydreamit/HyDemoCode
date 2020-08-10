//
//  HyListViewProtocol.h
//  DemoCode
//
//  Created by Hy on 2017/11/21.
//  Copyright © 2017 Hy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyListViewModelProtocol.h"
#import "HyRefreshViewFactoryProtocol.h"

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM(NSUInteger, HyListViewRefreshType) {
    HyListViewRefreshTypeNone,
    HyListViewRefreshTypePullDown,
    HyListViewRefreshTypePullUp,
    HyListViewRefreshTypePullDownAndUp
};


@protocol HyListViewInvokerProtocol <NSObject>
@optional;
- (id<HyListEntityProtocol>)listViewDataProviderForKey:(NSString *)key;
@end

typedef void(^HyListViewRefreshAction)(void);
@protocol HyListViewProtocol <NSObject>
@optional


@property (nonatomic, copy) NSString *key;

- (void)configRefreshFramework:(nullable NSString *)framework
                   refreshType:(HyListViewRefreshType)refreshType
           refreshRequestInput:(id (^_Nullable)(HyListActionType type))inputBlock
           refreshCustomAction:(HyListViewRefreshAction(^ _Nullable)(BOOL isHeaderRefresh))actionBlock;

- (void)headerBeginRefreshing;
- (void)footerBeginRefreshing;
- (id<HyRefreshViewFactoryProtocol>)getRefreshViewFactory;

@end

NS_ASSUME_NONNULL_END
