//
//  left.m
//  LZHSideVC
//
//  Created by 李振华 on 15/8/24.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import "LeftVC.h"

@implementation LeftVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"LeftVC will appear...");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"LeftVC did appear...");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"LeftVC will disappear...");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"LeftVC did disappear...");
}
@end
