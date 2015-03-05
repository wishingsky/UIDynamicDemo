//
//  ViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-9-18.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIProgressView *block1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *block2;
@property(nonatomic,strong) UIDynamicAnimator *animator;

@end

@implementation ViewController

-(UIDynamicAnimator *)animator
 {
    if (_animator==nil) {
        //创建物理仿真器（ReferenceView:参照视图，设置仿真范围）
        self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
 }

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //1. 重力行为+碰撞行为
//  [self testGravityAndCollsion];
    
    //2. 用三条线作为边界
//   [self testGravityAndCollision1];
    
    //3. 用圆作为边界
   [self testGravityAndCollision2];
}

/**
   * 重力行为+碰撞行为
*/
-(void)testGravityAndCollsion
{
    //1. 重力行为
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]init];
    [gravity addItem:self.redView];

    //2. 碰撞检测行为
    UICollisionBehavior *collision=[[UICollisionBehavior alloc] initWithItems:@[self.redView, self.block1, self.block2]];
    
    //让参照视图的边框成为碰撞检测的边界
    collision.translatesReferenceBoundsIntoBoundary=YES;
    collision.collisionDelegate = self;
    
    //3.执行仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

/**
 *  用3根线作为边界
 */
- (void)testGravityAndCollision1
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.redView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.redView, self.block1, self.block2]];
    
    //添加三条直线作为碰撞边界
    [collision addBoundaryWithIdentifier:@"line1" fromPoint:CGPointMake(320, 0) toPoint:CGPointMake(320, 350)];
    [collision addBoundaryWithIdentifier:@"line2" fromPoint:CGPointMake(320, 350) toPoint:CGPointMake(0, 450)];
    [collision addBoundaryWithIdentifier:@"line3" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, 450)];
    
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

/**
    *  用圆作为边界
    */
- (void)testGravityAndCollision2
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.redView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.redView, self.block1, self.block2]];
    
    // 添加一个椭圆为碰撞边界
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 20, 320, 500)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

#pragma mark - UICollisionBehavior Delegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
//    if ([item1 isEqual:self.redView] && [item2 isEqual:self.block1]) {
        UIGravityBehavior *g = [[UIGravityBehavior alloc] initWithItems:@[item1, item2]];
        [self.animator addBehavior:g];
//    }
}

@end
