//
//  UIPushViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-10-13.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "UIPushViewController.h"

@interface UIPushViewController ()

@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation UIPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSmallSquareView];
    [self createGestureRecognizer];
    [self createAnimatorAndBehaviors];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createGestureRecognizer{  //侦测视图单击
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)];
    [self.squareView addGestureRecognizer:panGestureRecognizer];
}

- (void) handlePan:(UIPanGestureRecognizer *)paramPan{
    
    [self.pushBehavior setActive:YES];
    
    CGPoint tapPoint = [paramPan locationInView:self.view];//p2
    CGPoint squareViewCenterPoint = self.squareView.center;//p1
   
    CGFloat deltaX = tapPoint.x - squareViewCenterPoint.x;
    CGFloat deltaY = tapPoint.y - squareViewCenterPoint.y;
    CGFloat angle = atan2(deltaY, deltaX);
    [self.pushBehavior setAngle:angle];  //推移的角度
    
    //勾股
    CGFloat distanceBetweenPoints =
    sqrt(pow(tapPoint.x - squareViewCenterPoint.x, 2.0) +
         pow(tapPoint.y - squareViewCenterPoint.y, 2.0));
//
    [self.pushBehavior setMagnitude:distanceBetweenPoints / 100.0f]; //推力的大小（移动速度）
    //每1个magnigude将会引起100/平方秒的加速度，这里分母越大，速度越小
    
}

- (void) createSmallSquareView{
    self.squareView =[[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    
    [self.view addSubview:self.squareView];
}

- (void) createAnimatorAndBehaviors{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    /* Create collision detection */
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.squareView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    self.pushBehavior = [[UIPushBehavior alloc]
                         initWithItems:@[self.squareView]
                         mode:UIPushBehaviorModeInstantaneous];

    [self.animator addBehavior:collision];
    [self.animator addBehavior:self.pushBehavior];
}

@end
