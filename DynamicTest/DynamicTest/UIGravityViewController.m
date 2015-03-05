//
//  UIGravityViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-10-11.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "UIGravityViewController.h"

@interface UIGravityViewController ()

@property (weak, nonatomic) IBOutlet UIView *aView;
@property(nonatomic,strong) UIDynamicAnimator *animator;

@end

@implementation UIGravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. 创建仿真器，设置参考系
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.aView.layer.cornerRadius = 35;
    [self.aView setTransform:CGAffineTransformRotate( CGAffineTransformIdentity, -M_PI/2)];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self testGravity];
    [self testGravityProperty];
//    [self testGravityAndBoundaryCollision];
}

/**
 *  重力行为
 */
-(void)testGravity
{
    //2.创建仿真行为（进行怎样的仿真效果？）
        //重力行为
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]init];
    
    //3.添加物理仿真元素
    [gravity addItem:self.aView];
    
    //4.执行仿真，让物理仿真元素执行仿真行为
    [self.animator addBehavior:gravity];
}

/**
 *  测试重力行为的属性
 （注意：要先设置重力方向再设置加速度，否则加速度不起作用）
 */
- (void)testGravityProperty
{
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]init];
        
    //（1）设置重力的方向（是一个角度）
//    gravity.angle=(M_PI_4);
    
    //（2）设置重力的加速度,重力的加速度越大，碰撞就越厉害
    
//    gravity.magnitude=10;
    
    //（3）设置重力的方向（是一个二维向量）
//  gravity.gravityDirection=CGVectorMake(1, 1);
    
    [gravity addItem:self.aView];
    
    [self.animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.aView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.aView]];
    
    itemBehavior.elasticity = 1.0;    //1 弹性碰撞 0无弹性
    itemBehavior.allowsRotation = YES; //是否转动
    itemBehavior.resistance = 1.f;    // 0 无速度阻尼，即空气阻力
    itemBehavior.friction = 1.0;      //摩擦力
    
    [self.animator addBehavior:itemBehavior];
}

/**
 *重力+边界碰撞
 */

- (void)testGravityAndBoundaryCollision
{
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]initWithItems:@[self.aView]];
    UICollisionBehavior *collision=[[UICollisionBehavior alloc] initWithItems:@[self.aView]];
    //让参照视图的边框成为碰撞检测的边界
    collision.translatesReferenceBoundsIntoBoundary=YES;
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
