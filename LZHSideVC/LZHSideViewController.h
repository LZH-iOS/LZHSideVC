//
//  LZHSideViewController.h
//  LZHSideVC
//
//  Created by LZH　 on 15/8/13.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZHSideViewController;

@protocol LZHSideViewControllerDelegate <NSObject>
/**
 *  手势触发协议方法
 *
 *  @param sideViewController
 *  @param panGestureRecognizer
 */
- (void)sideViewController:(LZHSideViewController *)sideViewController didRecognizePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;
/**
 *  左或右视图将要显示
 *
 *  @param sideViewController
 *  @param sideViewContainerVC
 */
- (void)sideViewController:(LZHSideViewController *)sideViewController willShowSideViewController:(UIViewController *)sideViewContainerVC;
/**
 *  左或右视图已经显示
 *
 *  @param sideViewController
 *  @param sideViewContainerVC 
 */
- (void)sideViewController:(LZHSideViewController *)sideViewController didShowSideViewController:(UIViewController *)sideViewContainerVC;
@end

@interface LZHSideViewController : UIViewController
/**
 *  中间视图控制器
 */
@property (strong, readonly, nonatomic) UIViewController *contentViewController;
/**
 *  左边视图控制器
 */
@property (strong, nonatomic) UIViewController *leftViewController;
/**
 *  右边视图控制器
 */
@property (strong, nonatomic) UIViewController *rightViewController;
/**
 *  是否禁用手势(默认是开启的)
 */
@property (assign, nonatomic) BOOL panGestureEnabled;
/**
 *  侧滑动画时间(默认0.35s)
 */
@property (assign, nonatomic) double animationDuration;
/**
 *  手势侧滑距离(默认20.0)
 */
@property (assign, nonatomic) float gestureRecognizerRange;
///**
// *  是否缩放中间视图(默认缩放)
// */
//@property (assign, readwrite, nonatomic) BOOL isScaleContentView;
///**
// *  中间视图缩放比例(默认0.7)
// */
//@property (assign, nonatomic) float contentViewScaleValue;
/**
 *  左侧滑动距离(默认是屏幕的2/3)
 */
@property (assign, nonatomic) float leftSideDistance;
/**
 *  右侧滑动距离(默认是屏幕的2/3)
 */
@property (assign, nonatomic) float rightSideDistance;
/**
 *  代理
 */
@property (assign, nonatomic) id <LZHSideViewControllerDelegate> delegate;
/**
 *  是否设置阴影(默认NO)
 */
@property (assign, nonatomic) BOOL isEnableShadow;
/**
 中间视图显示时阴影相关设置
 */
@property (strong, nonatomic) UIColor *shadowColor;
@property CGSize shadowOffset;
@property CGFloat shadowRadius;
@property float shadowOpacity;
/**
 *  初始化控制器方法
 *
 *  @param contentViewController 中间控制器(不能为nil)
 *  @param leftViewController    左边控制器(可以为nil)
 *  @param rightViewController   右边控制器(可以为nil)
 */
- (id)initWithContentViewController:(UIViewController *)contentViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;
/**
 *  显示左边视图
 */
- (void)showLeftSideViewController;
/**
 *  显示右边视图
 */
- (void)showRightSideViewController;

@end
