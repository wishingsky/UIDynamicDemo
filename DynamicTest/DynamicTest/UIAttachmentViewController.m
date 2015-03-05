//
//  UIAttachmentViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-10-13.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "UIAttachmentViewController.h"

@interface UIAttachmentViewController ()

@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UIView *squareViewAnchorView;
@property (nonatomic, strong) UIView *anchorView;
@property (nonatomic, strong) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation UIAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAnchorView];  //创建锚点，基准视图，
    [self createSmallSquareView];
    [self createGestureRecognizer]; //创建拖动
    [self testAttachBehaviorToAnchor];  //创建关联动画
//    [self testAttachmentBehaviorOffset];
}
    // Do any additional setup after loading the view.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSmallSquareView{
    self.squareView = [[UIView alloc] initWithFrame:  CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    
    self.squareViewAnchorView = [[UIView alloc] initWithFrame: CGRectMake(60.0f, 0.0f, 20.0f, 20.0f)];
    self.squareViewAnchorView.backgroundColor = [UIColor brownColor];
    [self.squareView addSubview:self.squareViewAnchorView];
    
    [self.view addSubview:self.squareView];
}

- (void) createAnchorView{
    
    self.anchorView = [[UIView alloc] initWithFrame: CGRectMake(150.0f, 120.0f, 20.0f, 20.0f)];
    self.anchorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.anchorView];
}

- (void) createGestureRecognizer{
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    [self.anchorView addGestureRecognizer:panGestureRecognizer];
}

- (void) handlePan:(UIPanGestureRecognizer *)paramPan{
    CGPoint tapPoint = [paramPan locationInView:self.view];
    self.anchorView.center = tapPoint;
    
    //拖动的点作为锚点
    [self.attachmentBehavior setAnchorPoint:tapPoint];
}

- (void)testAttachBehaviorToAnchor
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.attachmentBehavior = [ [UIAttachmentBehavior alloc] initWithItem:self.squareView attachedToAnchor:self.anchorView.center];
    
    self.attachmentBehavior.damping = 0.1; //吸附行为减弱的阻力大小, 值越大，阻力越大
    self.attachmentBehavior.frequency = 1.0;//吸附行为震荡的频率，值越大，震荡越厉害
    
    [self.animator addBehavior:self.attachmentBehavior];
}

- (void) testAttachmentBehaviorOffset{
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //squareView视图右上方的点会跟着锚点一起动，带动了squareView整个视图跟着锚点一起动
    UIOffset offset = UIOffsetMake(self.squareViewAnchorView.center.x, self.squareViewAnchorView.center.y);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.squareView offsetFromCenter:offset attachedToAnchor:self.anchorView.center];
    [self.animator addBehavior:self.attachmentBehavior];
}

@end
