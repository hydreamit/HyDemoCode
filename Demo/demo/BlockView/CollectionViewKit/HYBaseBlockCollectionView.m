//
//  HYBaseBlockCollectionView.m
//  HYWallet
//
//  Created by huangyi on 2018/6/1.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseBlockCollectionView.h"
#import "HYBaseCollectionViewCell.h"
#import "HYBaseCollectionCellModel.h"
#import "HYBaseCollectionSectionModel.h"
#import "HYBaseCollectionHeaderFooterView.h"


@interface HYBaseBlockCollectionViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderViewClasses;
@property (nonatomic,strong) NSArray *registerFooterViewClasses;
@property (nonatomic,copy) NSArray<NSString *> *(^sectionAndCellKeyBlock)(void);
@property (nonatomic,copy) NSInteger(^numberOfSectionsBlock)(UICollectionView *collectionView);
@property (nonatomic,copy) NSInteger(^numberOfItemsInSectionBlock)(UICollectionView *collectionView, NSInteger section);

@property (nonatomic,copy) Class(^cellClassForRowBlock)(HYBaseCollectionCellModel *cellModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (HYBaseCollectionSectionModel *sectionModel,
                                 HYSeactionViewKinds seactionViewKinds,
                                 NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configCellBlock) (HYBaseCollectionViewCell *cell,
                                                    HYBaseCollectionCellModel *cellModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( HYBaseCollectionHeaderFooterView *headerFooterView,
                                                                HYBaseCollectionSectionModel *sectionModel,
                                                                HYSeactionViewKinds seactionViewKinds,
                                                                NSIndexPath *indexPath);
@end

@implementation HYBaseBlockCollectionViewConfigure
- (instancetype)configEmptyViewConfigure:(configureBlock)configure {
    if (configure) {
        self.emptyViewConfigure = [configure copy];
    }
    return self;
}
- (instancetype)configRegisterCellClasses:(NSArray<Class> *)classes {
    self.registerCellClasses = classes;
    return self;
}
- (instancetype)configHeaderViewClasses:(NSArray<Class> *)classes {
    self.registerHeaderViewClasses = classes;
    return self;
}
- (instancetype)configFooterViewClasses:(NSArray<Class> *)classes {
    self.registerFooterViewClasses = classes;
    return self;
}
- (instancetype)configSectionAndCellKey:(NSArray<NSString *> *(^)(void))block {
    self.sectionAndCellKeyBlock = block;
    return self;
}


- (instancetype)configCellClassForRow:(Class(^)(HYBaseCollectionCellModel *cellModel, NSIndexPath * indexPath))block {
    self.cellClassForRowBlock = [block copy];
    return self;
}

- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseCollectionSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSIndexPath *indexPath))block {
    self.headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}

- (instancetype)configCell:(void(^)(HYBaseCollectionViewCell *cell,
                                    HYBaseCollectionCellModel *cellModel,
                                    NSIndexPath *indexPath))block {
    self.configCellBlock = [block copy];
    return self;
    
}

- (instancetype)configHeaderFooterView:(void(^)(HYBaseCollectionHeaderFooterView *headerFooterView,
                                                HYBaseCollectionSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSIndexPath *indexPath))block {
    self.configHeaderFooterViewBlock = [block copy];
    return self;
}
@end



@interface HYBaseBlockCollectionView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) HYRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) HYBaseCollectionViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@property (nonatomic,copy) NSString *sectionKey;
@property (nonatomic,copy) NSString *cellKey;
@property (nonatomic,strong) HYBaseBlockCollectionViewConfigure *configure;
@end


@implementation HYBaseBlockCollectionView
+ (instancetype)colletionViewWithFrame:(CGRect)frame
                                layout:(UICollectionViewLayout *)layout
                           refreshType:(HYRefreshType)refreshType
                         refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                             viewModel:(HYBaseCollectionViewModel *)viewModel
                             configure:(HYBaseBlockCollectionViewConfigure *)configure {
    
    typedef void(^action)(void);
    RefreshAction (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        RefreshAction action = ^{
            if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
                HYCollectionViewLoadDataType type = isHeaderFresh ?
                HYCollectionViewLoadDataTypeNew : HYCollectionViewLoadDataTypeMore;
                [viewModel.collectionViewExecuteCommand(type) execute:nil];
            }
        };
        return
        refreshAction ? (refreshAction(isHeaderFresh) ?: action) : action;
    };
    
    action headerBlock =
    (refreshType == HYRefreshTypePullDown || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;
    
    action footerBlock =
    (refreshType == HYRefreshTypePullUp || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;
    
    HYBaseBlockCollectionView *collectionView =
    [self collectionViewWithFrame:frame
                           layout:layout
                        configure:configure
            headerRefreshCallback:headerBlock
            footerRefreshCallback:footerBlock];
    
    collectionView.refreshType = refreshType;
    if ([viewModel isKindOfClass:RACSignal.class]) {
        RACSignal *signal = (RACSignal *)viewModel;
        @weakify(collectionView);
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(collectionView);
            collectionView.viewModel = x;
            if ([x isKindOfClass:HYBaseCollectionViewModel.class]) {
                collectionView.nsewDataCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(0);
                collectionView.pullDownCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(1);
                collectionView.pullUpCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(2);
                [collectionView configViewModel];
            }
        }];
    } else {
        collectionView.viewModel = viewModel;
    }
    if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        collectionView.nsewDataCommand = viewModel.collectionViewExecuteCommand(0);
        collectionView.pullDownCommand = viewModel.collectionViewExecuteCommand(1);
        collectionView.pullUpCommand = viewModel.collectionViewExecuteCommand(2);
    }
    [collectionView configCollectionViewBlockWithConfigure:configure];
    if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        [collectionView configViewModel];
    }
    return collectionView;
}

- (void)reloadData {
    [super reloadData];
    
    if (self.emptyViewConfigure &&
        ![self.viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        if ([self getSectionCount] <= 1 &&
            [self getCellCountWithSection:0] == 0) {
            [self showEmptyView];
        } else {
            [self dismissEmptyView];
        }
    }
}

- (id)getViewModel {
    return self.viewModel;
}

- (void)reloadWithViewModel:(id)viewModel
                 sectionKey:(NSString *)sectionKey
                    cellKey:(NSString *)cellKey {
    
    self.sectionKey = sectionKey;
    self.cellKey = cellKey;
    if (self.viewModel != viewModel) {
        if ([viewModel isKindOfClass:RACSignal.class]) {
            RACSignal *signal = (RACSignal *)viewModel;
            @weakify(self);
            [signal subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                self.viewModel = x;
                if ([x isKindOfClass:HYBaseCollectionViewModel.class]) {
                    self.nsewDataCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(0);
                    self.pullDownCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(1);
                    self.pullUpCommand = ((HYBaseCollectionViewModel *)x).collectionViewExecuteCommand(2);
                    [self configViewModel];
                }
            }];
        } else {
            self.viewModel = viewModel;
            if ([viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
                self.nsewDataCommand = ((HYBaseCollectionViewModel *)viewModel).collectionViewExecuteCommand(0);
                self.pullDownCommand = ((HYBaseCollectionViewModel *)viewModel).collectionViewExecuteCommand(1);
                self.pullUpCommand = ((HYBaseCollectionViewModel *)viewModel).collectionViewExecuteCommand(2);
                [self configViewModel];
            }
        }
    }
    [self reloadData];
}

- (void)configCollectionViewBlockWithConfigure:(HYBaseBlockCollectionViewConfigure *)configure {
    @weakify(self);
    
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }
    
    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderWithViewClasses:configure.registerHeaderViewClasses];
    [self registerFooterWithViewClasses:configure.registerFooterViewClasses];
    
    if (!configure.numberOfSectionsBlock) {
        [configure configNumberOfSections:^NSInteger(UICollectionView *collectionView) {
            @strongify(self)
            return [self getSectionCount];
        }];
    }
    if (!configure.numberOfItemsInSectionBlock) {
        [configure configNumberOfItemsInSection:^NSInteger(UICollectionView *collectionView, NSInteger section) {
            @strongify(self)
            return [self getCellCountWithSection:section];
        }];
    }
    
    [[[[configure configCellForItemAtIndexPath:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
        @strongify(self)
        
        Class cellClass;
        if (configure.cellClassForRowBlock) {
            cellClass = configure.cellClassForRowBlock([self getCellModelWithIndexPath:indexPath] ,indexPath);
        } else {
            NSArray *array = configure.registerCellClasses;
            if (array.count == 1) {
                cellClass = array.firstObject;
            };
        }
        if (cellClass) {
            if (class_getSuperclass(cellClass) == HYBaseCollectionViewCell.class) {
                return
                [cellClass cellWithColletionView:collectionView
                                       indexPath:indexPath
                                       viewModel:self.viewModel];
            }
            return
            [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
        }return nil;
    }] configWillDisplayCell:^(UICollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:HYBaseCollectionViewCell.class]) {
            ((HYBaseCollectionViewCell *)cell).cellModel = [self getCellModelWithIndexPath:indexPath];
            [((HYBaseCollectionViewCell *)cell) reloadCellData];
        }
        
        configure.configCellBlock ?
        configure.configCellBlock((HYBaseCollectionViewCell *)cell, [self getCellModelWithIndexPath:indexPath], indexPath) : nil;
    }] configSeactionHeaderFooterView:^UICollectionReusableView *(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath) {
        
        id secionHeaderClass;
        id secionFooterClass;
        if (configure.headerFooterViewClassAtSectionBlock) {
            
            secionHeaderClass = configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:indexPath.section], 0, indexPath);
            
            secionFooterClass = configure.headerFooterViewClassAtSectionBlock([self.viewModel getSectionModelAtSection:indexPath.section], 1, indexPath);
            
        } else {
            NSArray *headerArray = configure.registerHeaderViewClasses;
            if (headerArray.count == 1) {
                secionHeaderClass = headerArray.firstObject;
            };
            
            NSArray *footerArray = configure.registerFooterViewClasses;
            if (footerArray.count == 1) {
                secionFooterClass = footerArray.firstObject;
            };
        }
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (class_getSuperclass(secionHeaderClass) == HYBaseCollectionHeaderFooterView.class) {
                return
                [secionHeaderClass headerFooterViewWithCollectionView:collectionView
                                                            indexPath:indexPath
                                                             isHeader:YES
                                                            viewModel:self.viewModel];
                
            } else if(class_getSuperclass(secionHeaderClass) == UICollectionReusableView.class) {
                return
                [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                   withReuseIdentifier:NSStringFromClass(secionHeaderClass)
                                                          forIndexPath:indexPath];
                
            } else if([secionHeaderClass isKindOfClass:UIView.class]) {
                return secionHeaderClass;
            }
        }
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (class_getSuperclass(secionFooterClass) == HYBaseCollectionHeaderFooterView.class) {
                return
                [secionFooterClass headerFooterViewWithCollectionView:collectionView
                                                            indexPath:indexPath
                                                             isHeader:YES
                                                            viewModel:self.viewModel];
                
            } else if(class_getSuperclass(secionFooterClass) == UICollectionReusableView.class) {
                return
                [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                   withReuseIdentifier:NSStringFromClass(secionFooterClass)
                                                          forIndexPath:indexPath];
                
            } else if([secionFooterClass isKindOfClass:UIView.class]) {
                return secionFooterClass;
            }
        }return nil;
    }] configWillDisPlayHeaderFooterView:^void (UICollectionView *collectionView, UICollectionReusableView *view, NSString *kind, NSIndexPath *indexPath) {
        @strongify(self)
        if ([view isKindOfClass:HYBaseCollectionHeaderFooterView.class]) {
            ((HYBaseCollectionHeaderFooterView *)view).sectionModel = [self getSectionModelWithSection:indexPath.section];
            [((HYBaseCollectionHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((HYBaseCollectionHeaderFooterView *)view, [self getSectionModelWithSection:indexPath.section], ![kind isEqualToString:UICollectionElementKindSectionHeader], indexPath) : nil;
    }];
}

- (NSInteger)getSectionCount {
    
    id sectionData = [self getSectionKeyData];
    if ([self isArrayWithData:sectionData]) {
        return ((NSArray *)sectionData).count;
    }
    
    if ([self isArrayWithData:self.viewModel] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        return ((NSArray *)self.viewModel).count;
    }
    
    if (![self getSectionKey].length && ![self getCellKey].length &&
        [self.viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        if (self.viewModel.sectionModels.count > 0) {
            return self.viewModel.sectionModels.count;
        }
    }
    return 1;
}

- (NSInteger)getCellCountWithSection:(NSInteger)section {
    
    id cellData = [self getCellKeyData];
    if ([self isArrayWithData:cellData]) {
        return ((NSArray *)cellData).count;
    }
    
    if ([self isArrayWithData:self.viewModel] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        return ((NSArray *)self.viewModel).count;
    }
    
    if (![self getSectionKey].length && ![self getCellKey].length &&
        [self.viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        return [self.viewModel getSectionModelAtSection:section].cellModels.count;
    }
    return 0;
}

- (id)getCellModelWithIndexPath:(NSIndexPath *)indexPath {
    
    id cellData = [self getCellKeyData];
    if ([self isArrayWithData:cellData]) {
        if (((NSArray *)cellData).count > indexPath.row) {
            return ((NSArray *)cellData)[indexPath.row];
        }
    }
    
    if ([self isArrayWithData:self.viewModel] &&
        ![self getSectionKey].length && ![self getCellKey].length) {
        if (((NSArray *)self.viewModel).count > indexPath.row) {
            return ((NSArray *)self.viewModel)[indexPath.row];
        }
    }
    
    if (![self getSectionKey].length && ![self getCellKey].length &&
        [self.viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        return [self.viewModel getCellModelAtIndexPath:indexPath];
    }
    
    return self.viewModel;
}

- (id)getSectionModelWithSection:(NSInteger)section {
    
    id sectionData = [self getSectionKeyData];
    if ([self isArrayWithData:sectionData]) {
        if (((NSArray *)sectionData).count > section) {
            return ((NSArray *)sectionData)[section];
        }
    }
    
    if ([self isArrayWithData:self.viewModel] &&
        ![self getSectionKey].length && [self getCellKey].length) {
        if (((NSArray *)self.viewModel).count > section) {
            return ((NSArray *)self.viewModel)[section];
        }
    }
    
    if (![self getSectionKey].length && ![self getCellKey].length &&
        [self.viewModel isKindOfClass:HYBaseCollectionViewModel.class]) {
        return [self.viewModel getSectionModelAtSection:section];
    }
    
    return self.viewModel;
}

- (id)getSectionKeyData {
    if ([self getSectionKey].length) {
        if ([self isObjectWithData:self.viewModel]) {
            NSArray *keys = [[self getSectionKey] componentsSeparatedByString:@"."];
            if (keys.count) {
                return [self.viewModel valueForKeyPath:[self getCellKey]];
            } else {
                id data = self.viewModel;
                for (NSString *key in keys) {
                    if ([self isObjectWithData:data]) {
                        data = [data valueForKeyPath:key];
                    }
                }
                return data;
            }
        }
    }
    return nil;
}

- (id)getCellKeyData {
    if ([self getCellKey].length) {
        id sectionData = [self getSectionKeyData] ?: self.viewModel;
        if ([self isObjectWithData:sectionData]) {
            NSArray *keys = [[self getCellKey] componentsSeparatedByString:@"."];
            if (keys.count) {
                return [sectionData valueForKeyPath:[self getCellKey]];
            } else {
                id data = sectionData;
                for (NSString *key in keys) {
                    if ([self isObjectWithData:data]) {
                        data = [data valueForKeyPath:key];
                    }
                }
                return data;
            }
        }
    }
    return nil;
}

- (NSString *)getSectionKey {
    if (self.configure.sectionAndCellKeyBlock) {
        return self.configure.sectionAndCellKeyBlock().firstObject;
    }
    return self.sectionKey;
}

- (NSString *)getCellKey {
    if (self.configure.sectionAndCellKeyBlock) {
        return self.configure.sectionAndCellKeyBlock().lastObject;
    }
    return self.cellKey;
}

- (BOOL)isArrayWithData:(id)data {
    if ([data isKindOfClass:NSArray.class] ||
        [data isKindOfClass:NSMutableArray.class]) {
        return YES;
    }
    return NO;
}

- (BOOL)isObjectWithData:(id)data {
    if ([data isKindOfClass:NSDictionary.class] ||
        [data isKindOfClass:NSObject.class]) {
        return YES;
    }
    return NO;
}
- (void)configViewModel {
    
    @weakify(self);
    void (^subscribeSignal)(id) = ^(id x){
        @strongify(self);
        if (!self) {  return ;}
        self.signalSub ?
        ({
            self.signalSub(x);
        }):
        ({
            [self reloadData];
            switch (self.refreshType) {
                case HYRefreshTypePullDown:{
                    [self.mj_header endRefreshing];
                }break;
                case HYRefreshTypePullUp:{
                    [self.mj_footer endRefreshing];
                    if ([x isKindOfClass:[NSNumber class]]) {
                        self.mj_footer.hidden = [x boolValue];
                    }
                }break;
                case HYRefreshTypePullDownAndUp:{
                    [self.mj_header endRefreshing];
                    [self.mj_footer endRefreshing];
                    if ([x isKindOfClass:[NSNumber class]]) {
                        self.mj_footer.hidden = [x boolValue];
                    }
                }break;
                default:
                break;
            }
        });
    };
    
    void(^subscribeErrors)(NSError *x) = ^(NSError *x){
        @strongify(self);
        if (!self) {  return ;}
        self.errorsSub ?
        ({
            self.errorsSub(x);
        }):
        ({
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            
            if (self.viewModel.sectionModels.count <= 0) {
                [self reloadData];
                if (self.refreshType == HYRefreshTypePullUp ||
                    self.refreshType == HYRefreshTypePullDownAndUp) {
                    self.mj_footer.hidden = YES;
                }
            }
        });
    };
    
    void (^subscribeExecuting)(NSNumber * executing) = ^(NSNumber * executing){
        @strongify(self);
        if (!self) {  return ;}
        self.executingSub ?
        ({
            self.executingSub(executing);
        }):
        ({
            if (!executing.boolValue) {
                [MBProgressHUD hidden];
            } else {
                if (self.viewModel.currentLoadDataType == HYTableViewLoadDataTypeFirst) {
                    [MBProgressHUD showHUD];
                }
            }
        });
    };
    
    __block NSMutableArray *tempArray = @[].mutableCopy;
    NSArray *array = @[self.nsewDataCommand , self.pullDownCommand, self.pullUpCommand];
    [array enumerateObjectsUsingBlock:^(RACCommand *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![tempArray containsObject:obj]) {
            
            RACDisposable *disposeOne = [[obj.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:subscribeSignal];
            RACDisposable *disposeTwo = [obj.errors subscribeNext:subscribeErrors];
            RACDisposable *disposeThree = [[[obj.executing skip:1] deliverOnMainThread] subscribeNext:subscribeExecuting];
            
            if (disposeOne && [disposeOne isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeOne];
            }
            
            if (disposeTwo && [disposeTwo isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeTwo];
            }
            
            if (disposeThree && [disposeThree isKindOfClass:[RACDisposable class]]) {
                [self.disposees addObject:disposeThree];
            }
        }
        [tempArray addObject:obj];
    }];
}

- (void)configCommandSignaleSub:(void(^)(id value))signaleSub
                       erresSub:(void(^)(id value))erresSub
                   executingSub:(void(^)(id value))executingSub  {
    self.signalSub = [signaleSub copy];
    self.errorsSub = [erresSub copy];
    self.executingSub = [executingSub copy];
}

- (void)showEmptyView {
    if (self.emptyViewConfigure) {
        [MBProgressHUD showEmptyViewToView:self
                                 configure:self.emptyViewConfigure
                            reloadCallback:nil];
    }
}

- (void)dismissEmptyView {
    [MBProgressHUD dismissEmptyViewForView:self];
}

- (void)dealloc {
    [self.disposees makeObjectsPerformSelector:@selector(dispose)];
}

- (NSMutableArray *)disposees {
    return Hy_Lazy(_disposees, ({
        @[].mutableCopy;
    }));
}

@end












