//
//  HYBaseBlockTableView.m
//  HYWallet
//
//  Created by huangyi on 2018/5/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "HYBaseBlockTableView.h"
#import "HYBaseTableViewCell.h"
#import "HYBaseTableCellModel.h"
#import "HYBaseTableSectionModel.h"
#import "HYBaseTableViewHeaderFooterView.h"


@interface HYBaseBlockTableViewConfigure ()
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSArray *registerCellClasses;
@property (nonatomic,strong) NSArray *registerHeaderViewClasses;
@property (nonatomic,strong) NSArray *registerFooterViewClasses;
@property (nonatomic,strong) NSArray *registerHeaderFooterViewClasses;
@property (nonatomic,copy) NSInteger(^numberOfSections)(UITableView *tableView);
@property (nonatomic,copy) NSInteger(^numberOfRowsInSection)(UITableView *tableView, NSInteger section);

@property (nonatomic,copy) NSArray<NSString *> *(^sectionAndCellKeyBlock)(void);

@property (nonatomic,copy) Class(^cellClassForRowBlock)(HYBaseTableCellModel *cellModel,NSIndexPath * indexPath);
@property (nonatomic,copy) Class(^headerFooterViewClassAtSectionBlock)
                                (HYBaseTableSectionModel *sectionModel,
                                HYSeactionViewKinds seactionViewKinds,
                                NSUInteger section);
@property (nonatomic,copy) void (^configCellBlock) (HYBaseTableViewCell *cell,
                                                    HYBaseTableCellModel *cellModel,
                                                    NSIndexPath *indexPath);
@property (nonatomic,copy) void (^configHeaderFooterViewBlock)( HYBaseTableViewHeaderFooterView *headerFooterView,
                                                                HYBaseTableSectionModel *sectionModel,
                                                                HYSeactionViewKinds seactionViewKinds,
                                                                NSUInteger section);
@end
@implementation HYBaseBlockTableViewConfigure
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
- (instancetype)configSectionAndCellKey:(NSArray<NSString *> *(^)(void))block {
    self.sectionAndCellKeyBlock = block;
    return self;
}

- (instancetype)configRegisterHeaderFooterViewClasses:(NSArray<Class> *(^)(HYSeactionViewKinds seactionViewKinds))block {
    
    NSArray *headArray = block(SeactionHeaderView);
    NSArray *footerArray = block(SeactionFooterView);
    NSMutableArray *array = [NSMutableArray arrayWithArray:headArray];
    [footerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![array containsObject:obj]) {
            [array addObject:obj];
        }
    }];
    
    self.registerHeaderViewClasses = headArray;
    self.registerFooterViewClasses = footerArray;
    self.registerHeaderFooterViewClasses = array;
    return self;
}

- (instancetype)configCellClassForRow:(Class(^)(HYBaseTableCellModel *cellModel,NSIndexPath * indexPath))block {
    self.cellClassForRowBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterViewClassAtSection:(Class(^)(HYBaseTableSectionModel *sectionModel,
                                                               HYSeactionViewKinds seactionViewKinds,
                                                               NSUInteger section))block {
    self.headerFooterViewClassAtSectionBlock = [block copy];
    return self;
}
- (instancetype)configCell:(void(^)(HYBaseTableViewCell *cell,
                                    HYBaseTableCellModel *cellModel,
                                    NSIndexPath *indexPath))block {
    self.configCellBlock = [block copy];
    return self;
}
- (instancetype)configHeaderFooterView:(void(^)(HYBaseTableViewHeaderFooterView *headerFooterView,
                                                HYBaseTableSectionModel *sectionModel,
                                                HYSeactionViewKinds seactionViewKinds,
                                                NSUInteger section))block {
    self.configHeaderFooterViewBlock = [block copy];
    return self;
}
@end


@interface HYBaseBlockTableView ()
@property (nonatomic,copy) void(^signalSub)(id value);
@property (nonatomic,copy) void(^errorsSub)(id value);
@property (nonatomic,copy) void(^executingSub)(id value);
@property (nonatomic,assign) HYRefreshType refreshType;
@property (nonatomic,strong) RACCommand *pullUpCommand;
@property (nonatomic,strong) RACCommand *pullDownCommand;
@property (nonatomic,strong) RACCommand *nsewDataCommand;
@property (nonatomic,strong) HYBaseTableViewModel *viewModel;
@property (nonatomic,copy) configureBlock emptyViewConfigure;
@property (nonatomic,strong) NSMutableArray<RACDisposable *> *disposees;
@property (nonatomic, strong) HYBaseBlockTableViewConfigure *configure;
@property (nonatomic,copy) NSString *sectionKey;
@property (nonatomic,copy) NSString *cellKey;
@end


@implementation HYBaseBlockTableView
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                       refreshType:(HYRefreshType)refreshType
                     refreshAction:(RefreshAction(^)(BOOL isHeaderFresh))refreshAction
                         viewModel:(HYBaseTableViewModel *)viewModel
                         configure:(HYBaseBlockTableViewConfigure *)configure {
    
    RefreshAction (^refresh)(BOOL isHeaderFresh) = ^(BOOL isHeaderFresh){
        RefreshAction action = ^{
            if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
                HYTableViewLoadDataType type = isHeaderFresh ?
                HYTableViewLoadDataTypeNew : HYTableViewLoadDataTypeMore;
                [viewModel.tableViewExecuteCommand(type) execute:nil];
            }
        };
        return
        refreshAction ? (refreshAction(isHeaderFresh) ?: action) : action;
    };
    
    RefreshAction headerBlock =
    (refreshType == HYRefreshTypePullDown || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(YES) : nil;
    
    RefreshAction footerBlock =
    (refreshType == HYRefreshTypePullUp || refreshType == HYRefreshTypePullDownAndUp) ?
    refresh(NO) : nil;
    
    HYBaseBlockTableView *tableView =
    [self tableViewWithFrame:frame
                       style:style
                   configure:configure
       headerRefreshCallback:headerBlock
       footerRefreshCallback:footerBlock];
    
    tableView.refreshType = refreshType;
    if ([viewModel isKindOfClass:RACSignal.class]) {
        RACSignal *signal = (RACSignal *)viewModel;
        @weakify(tableView);
        [signal subscribeNext:^(id  _Nullable x) {
            @strongify(tableView);
            tableView.viewModel = x;
            if ([x isKindOfClass:HYBaseTableViewModel.class]) {
                tableView.nsewDataCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(0);
                tableView.pullDownCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(1);
                tableView.pullUpCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(2);
                [tableView configViewModel];
            }
        }];
    } else {
        tableView.viewModel = viewModel;
    }
    if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
        tableView.nsewDataCommand = viewModel.tableViewExecuteCommand(0);
        tableView.pullDownCommand = viewModel.tableViewExecuteCommand(1);
        tableView.pullUpCommand = viewModel.tableViewExecuteCommand(2);
    }
    [tableView configTableViewBlockWithConfigure:configure];
    if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
        [tableView configViewModel];
    }
    return tableView;
}

- (void)reloadWithViewModel:(id)viewModel
                 sectionKey:(NSString *)sectionKey
                    cellKey:(NSString *)cellKey {
    
    _sectionKey = sectionKey;
    _cellKey = cellKey;
    if (self.viewModel != viewModel) {
        if ([viewModel isKindOfClass:RACSignal.class]) {
            RACSignal *signal = (RACSignal *)viewModel;
            @weakify(self);
            [signal subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                self.viewModel = x;
                if ([x isKindOfClass:HYBaseTableViewModel.class]) {
                    self.nsewDataCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(0);
                    self.pullDownCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(1);
                    self.pullUpCommand = ((HYBaseTableViewModel *)x).tableViewExecuteCommand(2);
                    [self configViewModel];
                }
            }];
        } else {
            self.viewModel = viewModel;
            if ([viewModel isKindOfClass:HYBaseTableViewModel.class]) {
                self.nsewDataCommand = ((HYBaseTableViewModel *)viewModel).tableViewExecuteCommand(0);
                self.pullDownCommand = ((HYBaseTableViewModel *)viewModel).tableViewExecuteCommand(1);
                self.pullUpCommand = ((HYBaseTableViewModel *)viewModel).tableViewExecuteCommand(2);
                [self configViewModel];
            }
        }
    }
    [self reloadData];
}

- (void)reloadData {
    [super reloadData];
    
    if (self.emptyViewConfigure &&
        ![self.viewModel isKindOfClass:HYBaseTableViewModel.class]) {
        if ([self getSectionCount] <= 1 &&
            [self getCellCountWithSection:0] == 0) {
            [self showEmptyView];
        } else {
            [self dismissEmptyView];
        }
    }
}

- (void)configTableViewBlockWithConfigure:(HYBaseBlockTableViewConfigure *)configure {
    if (configure.emptyViewConfigure) {
        self.emptyViewConfigure = configure.emptyViewConfigure;
    }
    
    [self registerCellWithCellClasses:configure.registerCellClasses];
    [self registerHeaderFooterWithViewClasses:configure.registerHeaderFooterViewClasses];
    
    @weakify(self);
    if (!configure.numberOfSections) {
        [configure configNumberOfSections:^NSInteger(UITableView *tableView) {
            @strongify(self)
            return [self getSectionCount];
        }];
    }
    if (!configure.numberOfRowsInSection) {
        [configure configNumberOfRowsInSection:^NSInteger(UITableView *tableView, NSInteger section) {
            @strongify(self)
            return [self getCellCountWithSection:section];
        }];
    }
    
    [[[[[[configure configCellForRowAtIndexPath:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
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
            if (class_getSuperclass(cellClass) == HYBaseTableViewCell.class) {
                return [cellClass cellWithTableView:tableView
                                          indexPath:indexPath
                                          viewModel:self.viewModel];
            }
            return
            [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
        }return nil;
    }] configWillDisplayCell:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath) {
        @strongify(self)
        if ([cell isKindOfClass:HYBaseTableViewCell.class]) {
            ((HYBaseTableViewCell *)cell).cellModel = [self getCellModelWithIndexPath:indexPath];
            [((HYBaseTableViewCell *)cell) reloadCellData];
        }
        configure.configCellBlock ?
        configure.configCellBlock((HYBaseTableViewCell *)cell, [self getCellModelWithIndexPath:indexPath], indexPath) : nil;
    }] configViewForHeaderInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        id headerClass;
        if (configure.headerFooterViewClassAtSectionBlock) {
            headerClass = configure.headerFooterViewClassAtSectionBlock([self getSectionModelWithSection:section],0, section);;
        } else {
            NSArray *array = configure.registerHeaderViewClasses;
            if (array.count == 1) {
                headerClass = array.firstObject;
            };
        }
        
        if (class_getSuperclass(headerClass) == HYBaseTableViewHeaderFooterView.class) {
            return [headerClass
                    headerFooterViewWithTableView:tableView
                    section:section
                    isHeader:YES
                    viewModel:self.viewModel];
        } else if(class_getSuperclass(headerClass) == UITableViewHeaderFooterView.class) {
            return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerClass)];
        } else if([headerClass isKindOfClass:UIView.class]) {
            return headerClass;
        }
        return nil;
    }] configWillDisplayHeaderView:^(UITableView *tableView,UIView *view,NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:HYBaseTableViewHeaderFooterView.class]) {
            ((HYBaseTableViewHeaderFooterView *)view).sectionModel = [self getSectionModelWithSection:section];
            [((HYBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((HYBaseTableViewHeaderFooterView *)view,
                                              [self getSectionModelWithSection:section], 0, section) : nil;
    }] configViewForFooterInSection:^UIView *(UITableView *tableView, NSInteger section) {
        @strongify(self)
        
        id footerClass;
        if (configure.headerFooterViewClassAtSectionBlock) {
            footerClass = configure.headerFooterViewClassAtSectionBlock([self getSectionModelWithSection:section],1, section);
        } else {
            NSArray *array = configure.registerFooterViewClasses;
            if (array.count == 1) {
                footerClass = array.firstObject;
            };
        }
        
        if (class_getSuperclass(footerClass) == HYBaseTableViewHeaderFooterView.class) {
            return [footerClass
                    headerFooterViewWithTableView:tableView
                    section:section
                    isHeader:NO
                    viewModel:self.viewModel];
        } else if(class_getSuperclass(footerClass) == UITableViewHeaderFooterView.class) {
            return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(footerClass)];
        } else if([footerClass isKindOfClass:UIView.class]) {
            return footerClass;
        }
        return nil;
    }] configWillDisplayFooterView:^(UITableView *tableView, UIView *view, NSInteger section) {
        @strongify(self)
        if ([view isKindOfClass:HYBaseTableViewHeaderFooterView.class]) {
            ((HYBaseTableViewHeaderFooterView *)view).sectionModel = [self getSectionModelWithSection:section];
            [((HYBaseTableViewHeaderFooterView *)view) reloadHeaderFooterViewData];
        }
        configure.configHeaderFooterViewBlock ?
        configure.configHeaderFooterViewBlock((HYBaseTableViewHeaderFooterView *)view,
                                              [self getSectionModelWithSection:section], 1, section) : nil;
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
        [self.viewModel isKindOfClass:HYBaseTableViewModel.class]) {
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
        [self.viewModel isKindOfClass:HYBaseTableViewModel.class]) {
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
        [self.viewModel isKindOfClass:HYBaseTableViewModel.class]) {
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
        [self.viewModel isKindOfClass:HYBaseTableViewModel.class]) {
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
            !self.signalSub ?: self.signalSub(x);
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
                if (self.emptyViewConfigure) {
                    if (self.viewModel.sectionModels.count) {
                        [self dismissEmptyView];
                    } else {
                        [self showEmptyView];
                    }
                }
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
                   executingSub:(void(^)(id value))executingSub {
    self.signalSub = [signaleSub copy];
    self.errorsSub = [erresSub copy];
    self.executingSub = [executingSub copy];
}

- (void)insertcellWithcellModel:(HYBaseTableCellModel *)cellModel
                        atIndexPath:(NSIndexPath *)indexPath
                   withRowAnimation:(UITableViewRowAnimation)animation {
    
    if (!cellModel || !indexPath) { return; }
    
    if (indexPath.section > self.viewModel.sectionModels.count - 1) {
        return;
    }
    
    HYBaseTableSectionModel *sectionModel = [self.viewModel getSectionModelAtSection:indexPath.section];
    if (indexPath.row > sectionModel.cellModels.count) {
        return;
    }
    
    NSArray *paths = [NSArray arrayWithObject:indexPath];
    [sectionModel.cellModels insertObject:cellModel atIndex:indexPath.row];
    [self insertRowsAtIndexPaths:paths withRowAnimation:animation];
}

- (void)hy_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
                 withRowAnimation:(UITableViewRowAnimation)animation {
 
    if (!indexPaths || indexPaths.count <= 0) {
        return;
    }
    
    NSMutableArray *MindexArray = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.section > self.viewModel.sectionModels.count - 1) {
            return;
        } else {
            NSInteger count =
            [self.viewModel getSectionModelAtSection:indexPath.section].cellModels.count;
            if (indexPath.row >  count - 1) {
                return;
            } else {
                
                [[self.viewModel getSectionModelAtSection:indexPath.section].cellModels removeObjectAtIndex:indexPath.row];
                [MindexArray addObject:indexPath];
            }
        }
    }
    MindexArray.count ?
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation] : nil ;
}

- (void)hy_moveRowAtIndexPath:(NSIndexPath *)atIndexPath
                  toIndexPath:(NSIndexPath *)toIndexPath {
    
    if (![self isCorretIndexPath:atIndexPath] ||
        ![self isCorretIndexPath:toIndexPath]) {
        return;
    }
    
    HYBaseTableCellModel *cellModel = [self.viewModel getCellModelAtIndexPath:atIndexPath];
    
    [[self.viewModel getSectionModelAtSection:atIndexPath.section].cellModels removeObjectAtIndex:atIndexPath.row];
    
    [[self.viewModel getSectionModelAtSection:atIndexPath.section].cellModels insertObject:cellModel atIndex:toIndexPath.row];

    [self  moveRowAtIndexPath:atIndexPath toIndexPath:toIndexPath];
  
}

- (BOOL)isCorretIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section > self.viewModel.sectionModels.count - 1) {
        return NO;
    }
    if (indexPath.row > [self.viewModel getSectionModelAtSection:indexPath.section].cellModels.count - 1) {
        return NO;
    }
    return YES;
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










