//
//  AppDelegate.m
//  LZHSideVC
//
//  Created by LZH　 on 15/8/13.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import "AppDelegate.h"
#import "LZHSideViewController.h"
#import "ContentVC.h"
#import "LeftVC.h"
#import "RightVC.h"
@interface AppDelegate (){
    LZHSideViewController *VC;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:0.4269 green:0.9973 blue:1.0 alpha:1.0];
    
    
    LeftVC *leftVC = [LeftVC new];
    leftVC.view.backgroundColor = [UIColor whiteColor];
    RightVC *rightVC = [RightVC new];
    rightVC.view.backgroundColor = [UIColor grayColor];
    ContentVC *contentVC = [ContentVC new];
    contentVC.view.backgroundColor = [UIColor blueColor];
    UIButton *le = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    le.frame = CGRectMake(50, 150, 50, 20);
    le.backgroundColor = [UIColor whiteColor];
    [le addTarget:self action:@selector(left) forControlEvents:UIControlEventTouchUpInside];
    [contentVC.view addSubview:le];
    
    UIButton *ri = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ri.frame = CGRectMake(250, 150, 50, 20);
    ri.backgroundColor = [UIColor redColor];
    [ri addTarget:self action:@selector(right) forControlEvents:UIControlEventTouchUpInside];
    [contentVC.view addSubview:ri];
    
   VC = [[LZHSideViewController alloc] initWithContentViewController:contentVC leftViewController:leftVC rightViewController:rightVC];
    VC.isEnableShadow = YES;
    VC.shadowColor = [UIColor yellowColor];
    VC.shadowOpacity = 1;
    VC.shadowOffset = CGSizeMake(0, 0);
    VC.shadowRadius = 20;
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)left{

    [VC showLeftSideViewController];
}

- (void)right{
    [VC showRightSideViewController];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
