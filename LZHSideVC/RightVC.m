//
//  rightVC.m
//  LZHSideVC
//
//  Created by 李振华 on 15/8/24.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import "RightVC.h"

@implementation RightVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"RightVC will appear...");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"RightVC did appear...");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"RightVC will disappear...");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
     NSLog(@"RightVC did disappear...");
}
@end
