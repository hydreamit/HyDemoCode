//
//  ViewController.m
//  DemoCode
//
//  Created by Hy on 2017/11/18.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "ViewController.h"
#import "HyMeViewController.h"
#import "HyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.grayColor;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    [self.class pushViewControllerWithName:@"HyNewsViewController"
                             viewModelName:@"HyNewsViewModel"
                                 parameter:nil
                                  animated:YES
                                completion:nil];
    
}



@end
