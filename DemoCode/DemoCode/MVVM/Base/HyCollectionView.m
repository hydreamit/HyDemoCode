//
//  HyCollectionView.m
//  DemoCode
//
//  Created by Hy on 2017/11/21.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyCollectionView.h"
#import "HyListViewModel.h"
#import <HyCategoriess/HyCategories.h>


@interface HyCollectionView ()
@property (nonatomic,strong) id<HyListViewModelProtocol> listViewModel;
@property (nonatomic,strong) id<HyRefreshViewFactoryProtocol> refreshViewFactory;
@end


@implementation HyCollectionView

- (void)hy_colletionViewLoad {
    if (self.listViewModel) {
        [self.hy_delegateConfigure configSectionAndCellDataKey:^NSArray<NSString *> *{
            return @[@"listModel.listModelArray", @"listModelArray"];
        }];
    }
}

- (void)configRefreshFramework:(nullable NSString *)framework
                   refreshType:(HyListViewRefreshType)refreshType
           refreshRequestInput:(id (^_Nullable)(HyListViewRequestDataType type))inputBlock
           refreshCustomAction:(HyListViewRefreshAction(^ _Nullable)(BOOL isHeaderRefresh))actionBlock {
    
    if (refreshType == HyListViewRefreshTypeNone) {return;}

       __weak typeof(self) _self = self;
       void (^headerRefresh)(void) = (actionBlock ? actionBlock(YES) : nil) ?:
       ((refreshType == HyListViewRefreshTypePullDown ||
       refreshType == HyListViewRefreshTypePullDownAndUp) ?
        ^{  __strong typeof(_self) self = _self;
            id input = inputBlock ? inputBlock(HyListViewRequestDataTypeNew) : nil;
            [self.listViewModel requestListDataWithInput:input type:HyListViewRequestDataTypeNew];
       } : nil);

       void (^footerRefresh)(void) = (actionBlock ? actionBlock(NO) : nil) ?:
       ((refreshType == HyListViewRefreshTypePullUp ||
       refreshType == HyListViewRefreshTypePullDownAndUp) ?
        ^{   __strong typeof(_self) self = _self;
            id input = inputBlock ? inputBlock(HyListViewRequestDataTypeMore) : nil;
            [self.listViewModel requestListDataWithInput:input type:HyListViewRequestDataTypeMore];
       } : nil);

    self.refreshViewFactory =
    [HyRefreshViewManager refreshViewFactoryWithFramework:framework ?: KEY_MJRefresh
                                                  scrollView:self
                                         headerRefreshAction:headerRefresh
                                         footerRefreshAction:footerRefresh];
}

- (void)headerBeginRefreshing {
    [self.refreshViewFactory.getHeaderRefreshView beginRefreshing];
}

- (void)footerBeginRefreshing {
    [self.refreshViewFactory.getFooterRefreshView beginRefreshing];
}

- (id<HyRefreshViewFactoryProtocol>)getRefreshViewFactory {
    return self.refreshViewFactory;
}

- (void)setHy_collectionViewData:(id)hy_collectionViewData {
    [super setHy_collectionViewData:hy_collectionViewData];
    
    if ([hy_collectionViewData conformsToProtocol:@protocol(HyListViewModelProtocol)]) {
        self.listViewModel = hy_collectionViewData;
    }
}

- (void)setListViewModel:(id<HyListViewModelProtocol>)listViewModel {
    
    if (listViewModel != _listViewModel) {
        
        if (_listViewModel) {
            [_listViewModel requestListSuccessHandler:nil failureHandler:nil];
            listViewModel.reloadListViewBlock = nil;
        }
        
        __weak typeof(self) _self = self;
       [listViewModel requestListSuccessHandler:^(id  _Nonnull input,
                                                   id<HyListModelProtocol> _Nonnull listData,
                                                   HyListViewRequestDataType type,
                                                   BOOL noMore) {
           
           __strong typeof(_self) self = _self;
           [self reloadData];
           if (type == HyListViewRequestDataTypeNew) {
               [self.refreshViewFactory.getHeaderRefreshView endRefreshing];
           } else {
               [self.refreshViewFactory.getFooterRefreshView  endRefreshing];
           }
           [self.refreshViewFactory.getFooterRefreshView setHidden:noMore];
           
       } failureHandler:^(id  _Nonnull input,
                          NSError * _Nonnull error,
                          HyListViewRequestDataType type) {

               __strong typeof(_self) self = _self;
               if (type == HyListViewRequestDataTypeNew) {
                   [self.refreshViewFactory.getHeaderRefreshView endRefreshing];
               } else {
                   [self.refreshViewFactory.getFooterRefreshView  endRefreshing];
               }
               if (self.listViewModel.listModel.listModelArray.count <= 0) {
                   [self reloadData];
                   [self.refreshViewFactory.getFooterRefreshView setHidden:YES];
               }
       }];
       
       [self.hy_delegateConfigure configSectionAndCellDataKey:^NSArray<NSString *> *{
           return @[@"listModel.listModelArray", @"listModelArray"];
       }];
       
       listViewModel.reloadListViewBlock = ^(id  _Nonnull parameter) {
           __strong typeof(_self) self = _self;
           [self reloadData];
       };
    }
    _listViewModel = listViewModel;
}

@end
