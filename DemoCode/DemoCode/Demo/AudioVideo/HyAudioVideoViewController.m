//
//  HyAudioVideoViewController.m
//  DemoCode
//
//  Created by Hy on 2018/3/11.
//  Copyright © 2018 Hy. All rights reserved.
//

#import "HyAudioVideoViewController.h"
#import <HyCategoriess/HyCategories.h>
#import "HyAudioVideoCodecViewController.h"
#import "HyAudioVideoCaptureViewController.h"


@implementation HyAudioVideoViewController

- (void)hy_viewDidLoad {
    [super hy_viewDidLoad];
    
    __weak typeof(self) _self = self;
    
    UITableView *tableView =
    [UITableView hy_tableViewWithFrame:self.view.bounds style:UITableViewStylePlain tableViewData:@[@"Capture", @"Codec"] cellClasses:@[UITableViewCell.class] headerFooterViewClasses:nil delegateConfigure:^(HyTableViewDelegateConfigure *configure) {
        [[configure configCellWithData:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            cell.textLabel.text = (NSString *)cellData;
        }] configDidSelectRowAtIndexPath:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            __strong typeof(_self) self = _self;
            UIViewController *vc = indexPath.row ? HyAudioVideoCodecViewController.new : HyAudioVideoCaptureViewController.new;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (@available(iOS 11.0, *)){
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    [self.view addSubview:tableView];
}

@end
