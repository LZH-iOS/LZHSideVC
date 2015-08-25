//
//  LZHSideViewController.m
//  LZHSideVC
//
//  Created by LZH　 on 15/8/13.
//  Copyright (c) 2015年 LZH　. All rights reserved.
//

#import "LZHSideViewController.h"

@interface LZHSideViewController ()<UIGestureRecognizerDelegate>
/**
 *  左右视图容器
 */
@property (strong, nonatomic) UIView *sideViewContainer;
/**
 *  中间视图容器
 */
@property (strong, nonatomic) UIView *contentViewContainer;
/**
 *  左侧视图显示标记
 */
@property (assign, nonatomic) BOOL leftVisible;
/**
 *  右侧视图显示标记
 */
@property (assign, nonatomic) BOOL rightVisible;
/**
 *  中间视图button（点击隐藏左右视图）
 */
@property (strong, nonatomic) UIButton *contentButton;
/**
 *  纪录手势触发上次的point
 */
@property (assign, nonatomic) CGPoint oldPoint;
@end

@implementation LZHSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initChildViewControllers];
}
/**
 *  初始化控制器方法
 *
 *  @param contentViewController 中间控制器
 *  @param leftViewController    左边控制器
 *  @param rightViewController   右边控制器
 */
-(id)initWithContentViewController:(UIViewController *)contentViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController{
    self = [super init];
    if (self) {
        _contentViewController = contentViewController;
        _leftViewController = leftViewController;
        _rightViewController = rightViewController;
        _panGestureEnabled = YES;
//        _contentViewScaleValue = 0.7;
//        _isScaleContentView = YES;
        _gestureRecognizerRange = 20.0;
        _animationDuration = 0.35;
        _leftSideDistance = [UIScreen mainScreen].bounds.size.width*2/3;
        _rightSideDistance = [UIScreen mainScreen].bounds.size.width*2/3;
    }
    return self;
    
}
#pragma mark - setter
- (void)setIsEnableShadow:(BOOL)isEnableShadow{
    if (_isEnableShadow != isEnableShadow) {
        _isEnableShadow = isEnableShadow;
    }
    if (!isEnableShadow) {
        [self resetSHadow];
    }
}

-(void)setLeftViewController:(UIViewController *)leftViewController{
    if (_leftViewController == leftViewController) {
        return;
    }
    [self removeChildVC:_leftViewController];
    _leftViewController = leftViewController;
    
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.view.bounds;
    self.leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.sideViewContainer addSubview:self.leftViewController.view];
    [self.leftViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.contentViewContainer];
}

-(void)setRightViewController:(UIViewController *)rightViewController{
    if (_rightViewController == rightViewController) {
        return;
    }
    [self removeChildVC:_rightViewController];
    _leftViewController = rightViewController;
    
    [self addChildViewController:self.rightViewController];
    self.rightViewController.view.frame = self.view.bounds;
    self.rightViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.sideViewContainer addSubview:self.leftViewController.view];
    [self.rightViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.contentViewContainer];
}

/**
 *  初始化子视图控制器
 */
- (void)initChildViewControllers{
    _sideViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _sideViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_sideViewContainer];
    _contentViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentViewContainer];

    if (self.leftViewController) {
        [self addChildViewController:self.leftViewController];
        self.leftViewController.view.frame = self.view.bounds;
        self.leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.sideViewContainer addSubview:self.leftViewController.view];
        [self.leftViewController didMoveToParentViewController:self];
    }
    if (self.rightViewController) {
        [self addChildViewController:self.rightViewController];
        self.rightViewController.view.frame = self.view.bounds;
        self.rightViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.sideViewContainer addSubview:self.rightViewController.view];
        [self.rightViewController didMoveToParentViewController:self];
    }
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.contentViewContainer addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    self.contentButton = ({
        UIButton *button = [UIButton new];
        button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [button addTarget:self action:@selector(hideSideViewContainer) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    if (self.panGestureEnabled) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
}

#pragma  mark - panGestureRecognizerAction

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer{
    if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:didRecognizePanGesture:)]) {
        [self.delegate sideViewController:self didRecognizePanGesture:panGestureRecognizer];
    }
    CGPoint point = [panGestureRecognizer translationInView:self.view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self addContentButton];
        if (self.isEnableShadow) {
            [self setupShadow];
        }
        self.oldPoint = point;
    }else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        //仿射变换
        /**
         *  CGAffineTransform t = CGAffineTransformMake(CGFloat a, CGFloat b, CGFloat c, CGFloat d, CGFloat tx, CGFloat ty);
         *  x' = ax + cy + tx
         *  y' = bx + dy + ty
         */
//        self.contentViewScaleValue = self.isScaleContentView ? self.contentViewScaleValue: 1;
//        if (point.x > 0) {
//            self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform, 1,1 - (point.x - self.oldPoint.x)/CGRectGetWidth(self.view.bounds));
//        }else {
//            self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform, 1,1 - (self.oldPoint.x - point.x)/CGRectGetWidth(self.view.bounds));
//        }
        self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x - self.oldPoint.x, 0);
        self.oldPoint = point;
        self.leftViewController.view.hidden = self.contentViewContainer.frame.origin.x < 0;
        self.rightViewController.view.hidden = self.contentViewContainer.frame.origin.x > 0;
    }else if(panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        if ([panGestureRecognizer velocityInView:self.view].x > 0) {
            if (self.contentViewContainer.frame.origin.x < 0) {
                [self hideSideContainer:YES];
            } else {
                if (self.leftViewController) {
                    [self showLeftSideViewController];
                }
            }
        } else {
            if (self.contentViewContainer.frame.origin.x < self.gestureRecognizerRange) {
                if (self.rightViewController) {
                    [self showRightSideViewController];
                }
            } else {
                [self hideSideContainer:YES];
            }
        }
    }
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (!self.panGestureEnabled) {
        return NO;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (!self.leftVisible && !self.rightVisible ) {
            if ((point.x < self.gestureRecognizerRange || point.x > self.view.bounds.size.width - self.gestureRecognizerRange)) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark -
/**
 *  阴影设置
 */
-(void)setupShadow{
    if (self.isEnableShadow) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.contentViewContainer.layer.bounds];
        self.contentViewContainer.layer.shadowPath = path.CGPath;
        self.contentViewContainer.layer.shadowColor = self.shadowColor.CGColor;
        self.contentViewContainer.layer.shadowOffset = self.shadowOffset;
        self.contentViewContainer.layer.shadowRadius = self.shadowRadius;
        self.contentViewContainer.layer.shadowOpacity = self.shadowOpacity;
    }
}
/**
 *  重置阴影
 */
- (void)resetSHadow{
    self.contentViewContainer.layer.shadowPath = nil;
    self.contentViewContainer.layer.shadowColor = [UIColor clearColor].CGColor;
    self.contentViewContainer.layer.shadowOffset = CGSizeZero;
    self.contentViewContainer.layer.shadowRadius = 3.0;
    self.contentViewContainer.layer.shadowOpacity = 0;
}
/**
 *  删除子视图控制器
 *
 *  @param childVC
 */
- (void)removeChildVC:(UIViewController *)childVC{
    [childVC willMoveToParentViewController:nil];
    [childVC.view removeFromSuperview];
    [childVC removeFromParentViewController];
}
/**
 *  给中间视图容器添加按钮
 */
- (void)addContentButton
{
    if (self.contentButton.superview){
            return;
    }
    self.contentButton.frame = self.contentViewContainer.bounds;
    [self.contentViewContainer addSubview:self.contentButton];
}
/**
 *  隐藏左或右视图
 */
- (void)hideSideViewContainer{
    [self hideSideContainer:self.animationDuration];
}
/**
 *  显示左边视图
 */
- (void)showLeftSideViewController{
    if (!self.leftViewController) {
        return;
    }
    if (self.isEnableShadow) {
        [self setupShadow];
    }
    self.leftViewController.view.hidden = NO;
    self.rightViewController.view.hidden = YES;
    [self.leftViewController beginAppearanceTransition:YES animated:YES];
    if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:willShowSideViewController:)]) {
        [self.delegate sideViewController:self willShowSideViewController:self.leftViewController];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, self.leftSideDistance - self.contentViewContainer.frame.origin.x, 0);
//        self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform, 1,1 - (self.contentViewContainer.bounds.size.width - self.contentViewContainer.frame.origin.x)/CGRectGetWidth(self.contentViewContainer.bounds));
    } completion:^(BOOL finished) {
        [self.leftViewController endAppearanceTransition];
        if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:didShowSideViewController:)]) {
            [self.delegate sideViewController:self didShowSideViewController:self.leftViewController];
        }
        self.leftVisible = YES;
        self.rightVisible = NO;
        [self addContentButton];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}
/**
 *  显示右边视图
 */
- (void)showRightSideViewController{
    if (!self.rightViewController) {
        return;
    }
    if (self.isEnableShadow) {
        [self setupShadow];
    }
    self.leftViewController.view.hidden = YES;
    self.rightViewController.view.hidden = NO;
    [self.rightViewController beginAppearanceTransition:YES animated:YES];
    if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:willShowSideViewController:)]) {
        [self.delegate sideViewController:self willShowSideViewController:self.leftViewController];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, -(self.contentViewContainer.frame.origin.x + self.rightSideDistance), 0);
//        self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform, 1,1 - (self.contentViewContainer.bounds.size.width + self.contentViewContainer.frame.origin.x)/CGRectGetWidth(self.contentViewContainer.bounds));
    } completion:^(BOOL finished) {
        [self.rightViewController endAppearanceTransition];
        if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:didShowSideViewController:)]) {
            [self.delegate sideViewController:self didShowSideViewController:self.leftViewController];
        }
        self.leftVisible = NO;
        self.rightVisible = YES;
        [self addContentButton];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}
/**
 *  隐藏左右视图控制器
 *
 *  @param animated
 */
- (void)hideSideContainer:(BOOL)animated{
    UIViewController *viewVC = self.leftVisible ? self.leftViewController : self.rightViewController;
    [viewVC beginAppearanceTransition:NO animated:YES];
    if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:willShowSideViewController:)]) {
        [self.delegate sideViewController:self willShowSideViewController:viewVC];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.contentViewContainer.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [viewVC endAppearanceTransition];
        if ([self.delegate conformsToProtocol:@protocol(LZHSideViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(sideViewController:didShowSideViewController:)]) {
            [self.delegate sideViewController:self didShowSideViewController:viewVC];
        }
        self.leftVisible = NO;
        self.rightVisible = NO;
        [self.contentButton removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark - 禁掉appearance callbacks和rotation callbacks的自动传递  
//NS_DEPRECATED_IOS(5_0,6_0)
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers{
    return NO;
}
//NS_AVAILABLE_IOS(6_0)
- (BOOL)shouldAutomaticallyForwardAppearanceMethods{
    return NO;
}
//NS_AVAILABLE_IOS(6_0)
- (BOOL)shouldAutomaticallyForwardRotationMethods{
    return NO;
}

#pragma mark - appearance callbacks自定义传递 只传递给contentViewController 左右VC在适当位置传递
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *viewControllers = self.childViewControllers;
    for (UIViewController *viewController in viewControllers) {
        if (viewController == self.contentViewController) {
            [viewController beginAppearanceTransition:YES animated:animated];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray *viewControllers = self.childViewControllers;
    for (UIViewController *viewController in viewControllers) {
        if (viewController == self.contentViewController) {
            [viewController endAppearanceTransition];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.childViewControllers;
    for (UIViewController *viewController in viewControllers) {
        if (viewController == self.contentViewController) {
            [viewController beginAppearanceTransition:NO animated:animated];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSArray *viewControllers = self.childViewControllers;
    for (UIViewController *viewController in viewControllers) {
        if (viewController == self.contentViewController) {
            [viewController endAppearanceTransition];
        }
    }
}

//------TODO:目前还不支持屏幕旋转

//#pragma mark - rotation callbacks自定义传递
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    
//    NSArray *viewControllers = self.childViewControllers;
//    for (UIViewController *viewController in viewControllers) {
//        [viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//        
//    } 
//}
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    
//    NSArray *viewControllers = self.childViewControllers;
//    for (UIViewController *viewController in viewControllers) {
//        [viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    }
//}
//
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    
//    NSArray *viewControllers = self.childViewControllers;
//    for (UIViewController *viewController in viewControllers) {
//        [viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    }
//}
//
///*
// *  NS_AVAILABLE_IOS(6_0)
// *  向下查看和旋转相关的ChildViewController的shouldAutorotate的值
// *  只有所有相关的子VC都支持Autorotate，才返回YES
// */
//- (BOOL)shouldAutorotate{
//    NSArray *viewControllers = self.childViewControllers;
//    BOOL shouldAutorotate = YES;
//    for (UIViewController *viewController in viewControllers) {
//        shouldAutorotate = shouldAutorotate &&  [viewController shouldAutorotate];
//    }
//    
//    return shouldAutorotate;
//}
//
///*
// *  NS_AVAILABLE_IOS(6_0)
// *  此方法会在设备旋转且shouldAutorotate返回YES的时候才会被触发
// *  根据对应的所有支持的取向来决定是否需要旋转
// *  作为容器，支持的取向还决定于自己的相关子ViewControllers
// */
//- (NSUInteger)supportedInterfaceOrientations{
//    NSUInteger supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
//    
//    NSArray *viewControllers = self.childViewControllers;
//    for (UIViewController *viewController in viewControllers) {
//        supportedInterfaceOrientations = supportedInterfaceOrientations & [viewController supportedInterfaceOrientations];
//    }
//    
//    return supportedInterfaceOrientations;
//}
//
//
///*
// *  NS_DEPRECATED_IOS(2_0, 6_0) 6.0以下，设备旋转时，此方法会被调用
// *  用来决定是否要旋转
// */
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    BOOL shouldAutorotate = YES;
//    NSArray *viewControllers = self.childViewControllers;
//    for (UIViewController *viewController in viewControllers) {
//        shouldAutorotate = shouldAutorotate &&  [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
//    }
//    return shouldAutorotate;
//}

@end
