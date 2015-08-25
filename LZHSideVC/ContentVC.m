//
//  contentVC.m
//  LZHSideVC
//
//  Created by 李振华 on 15/8/24.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import "ContentVC.h"

@implementation ContentVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"ContentVC will appear...");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"ContentVC did appear...");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"ContentVC will disappear...");
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"ContentVC did disappear...");
}
@end
