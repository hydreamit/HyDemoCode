//
//  ViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySocketViewController.h"
#import <Masonry/Masonry.h>
#import <HyCategoriess/HyCategories.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HyCocoaSyncSocketFactory.h"
#import "HyCFSocketFactory.h"


@interface HySocketViewController ()
@property (nonatomic,weak) UIView *layoutView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) id<HySocketFactoryProtocol> socketFactory;
@end


@implementation HySocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
//    self.socketFactory = HyCFSocketFactory.socketFactory(@"10.10.10.50", @"8040");
    self.socketFactory = HyCocoaSyncSocketFactory.socketFactory(@"10.10.10.50", @"8040");
    [self.socketFactory.server bindAndListenWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"服务器开启监听成功");
        }
    }];
    [self.socketFactory.client(@"A") connectWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"客户端A -- 连接成功");
        }
    }];
    [self.socketFactory.client(@"B") connectWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"客户端B -- 连接成功");
        }
    }];
    
    [self.view addSubview:self.scrollView];
    [self serverInputView];
    [self clientInputViewWithArray:@[@"A", @"B"]];
    [self clientInputViewWithArray:@[@"B", @"A"]];
}

- (void)serverInputView {
    
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    self.layoutView = view;
    
    UILabel *titleL = UILabel.new;
    titleL.text = @"服务器";
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:13];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.top.mas_equalTo(5);
    }];
    
    UITextField *textf = [[UITextField alloc] init];
    textf.font = [UIFont systemFontOfSize:13];
    textf.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textf];
    [textf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL);
        make.top.mas_equalTo(titleL.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 25));
    }];
    
    UIButton *btnOne = [self buttonWithTitle:@"发送给 A"];
    [view addSubview:btnOne];
    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL);
        make.top.mas_equalTo(textf.mas_bottom).offset(5);
        make.size.equalTo(textf);
    }];
        
    UIButton *btnTwo = [self buttonWithTitle:@"发送给 B"];
    btnTwo.backgroundColor = UIColor.greenColor;
    [view addSubview:btnTwo];
    [btnTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btnOne.mas_bottom).offset(5);
        make.size.left.equalTo(btnOne);
    }];
    
    __weak typeof(self) _self = self;
    typedef void (^ClickBlock)(UIButton *);
    ClickBlock (^btnBlock)(NSString *) = ^ClickBlock(NSString *ID) {
        return ^(UIButton *btn){
            __strong typeof(_self) self = _self;
            if (textf.text.length) {
                id<HySocketMessageProtocol> message = HySocketMessage.message(textf.text, ID, 0);
                [self.socketFactory.server sendMessage:message];
                textf.text = @"";
            }
        };
    };
    [btnOne hy_clickBlock:btnBlock(@"A")];
    [btnTwo hy_clickBlock:btnBlock(@"B")];
    
    NSMutableArray<id<HySocketMessageProtocol>> *mArray = @[].mutableCopy;
    UITableView *table  =
    [UITableView hy_tableViewWithFrame:CGRectMake(140, 0, self.view.bounds.size.width - 150, 110) style:UITableViewStylePlain tableViewData:mArray cellClasses:@[UITableViewCell.class] headerFooterViewClasses:nil delegateConfigure:^(HyTableViewDelegateConfigure *configure) {
       [configure configCellWithData:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
           cell.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
           cell.textLabel.backgroundColor = UIColor.groupTableViewBackgroundColor;
           cell.textLabel.font = [UIFont systemFontOfSize:13];
           id<HySocketMessageProtocol> message  = cellData;
           if (message.targetID) {
               cell.textLabel.text = [NSString stringWithFormat:@"%@给%@发消息: %@",message.sourceID, message.targetID, message.content];
           } else {
               cell.textLabel.text = [NSString stringWithFormat:@"%@发来心跳包💗: %@",message.sourceID, message.content];
           }
       }];
    }];
    table.backgroundColor = UIColor.groupTableViewBackgroundColor;
    table.rowHeight = 25;
    [view addSubview:table];
    
    [self.socketFactory.server recvClientMessageWithHandler:^(id<HySocketMessageProtocol> _Nonnull message, id  _Nonnull socket) {
        if (message) {
            [mArray addObject:message];
            [[RACScheduler mainThreadScheduler] schedule:^{
                [table reloadData];
            }];
        }
    }];
}

- (void)clientInputViewWithArray:(NSArray<NSString *> *)array {
    
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.whiteColor;
    [self.scrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.layoutView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    self.layoutView = view;
    
    UILabel *titleL = UILabel.new;
    titleL.text = [NSString stringWithFormat:@"客户端%@", array.firstObject];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:13];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.top.mas_equalTo(5);
    }];
    
    UITextField *textf = [[UITextField alloc] init];
    textf.font = [UIFont systemFontOfSize:13];
    textf.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textf];
    [textf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL);
        make.top.mas_equalTo(titleL.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(120, 25));
    }];
    
    UIButton *btnOne = [self buttonWithTitle:[NSString stringWithFormat:@"发送给 %@", array[1]]];
    [view addSubview:btnOne];
    [btnOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleL);
        make.top.mas_equalTo(textf.mas_bottom).offset(5);
        make.size.equalTo(textf);
    }];
    __weak typeof(self) _self = self;
    [btnOne hy_clickBlock:^(UIButton * _Nonnull button) {
        __strong typeof(_self) self = _self;
        if (textf.text.length) {
            [self.socketFactory.client(array.firstObject) sendMessage:HySocketMessage.message(textf.text, array.lastObject, 0)];
            textf.text = @"";
        }
    }];

    NSMutableArray<id<HySocketMessageProtocol>> *mArray = @[].mutableCopy;
    UITableView *table  =
    [UITableView hy_tableViewWithFrame:CGRectMake(140, 0, self.view.bounds.size.width - 150, 80) style:UITableViewStylePlain tableViewData:mArray cellClasses:@[UITableViewCell.class] headerFooterViewClasses:nil delegateConfigure:^(HyTableViewDelegateConfigure *configure) {
        [configure configCellWithData:^(UITableViewCell *cell, id cellData, NSIndexPath *indexPath) {
            cell.contentView.backgroundColor = UIColor.groupTableViewBackgroundColor;
            cell.textLabel.backgroundColor = UIColor.groupTableViewBackgroundColor;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            id<HySocketMessageProtocol> message  = cellData;
            if (message.sourceID) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@发来消息: %@",message.sourceID, message.content];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"服务器推来消息: %@", message.content];
            }
        }];
    }];
    table.backgroundColor = UIColor.groupTableViewBackgroundColor;
    table.rowHeight = 25;
    [view addSubview:table];
    [self.socketFactory.client(array.firstObject) recvMessageWithHandler:^(id<HySocketMessageProtocol> _Nonnull message) {
        if (message) {
            [mArray addObject:message];
            [[RACScheduler mainThreadScheduler] schedule:^{
                [table reloadData];
            }];
        }
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UIButton *)buttonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.cornerRadius = 3.0;
    btn.backgroundColor = UIColor.orangeColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

@end
