//
//  UISnapViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-9-18.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "UISnapViewController.h"

@interface UISnapViewController ()
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property(nonatomic,strong)UIDynamicAnimator *animator;

@end

@implementation UISnapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIDynamicAnimator *)animator
{
    if (_animator==nil) {
        //创建物理仿真器，设置仿真范围，ReferenceView为参照视图
        _animator=[[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取一个触摸点
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:touch.view];

    //1.创建捕捉行为
    //需要传入两个参数：一个物理仿真元素，一个捕捉点
    UISnapBehavior *snap=[[UISnapBehavior alloc]initWithItem:self.blueView snapToPoint:point];
    //设置防震系数（0~1，数值越大，震动的幅度越小）
    snap.damping=arc4random_uniform(10)/10.0;
    
    //2.执行捕捉行为
    //注意：这个控件只能用在一个仿真行为上，如果要拥有持续的仿真行为，那么需要把之前的所有仿真行为删除
    //删除之前的所有仿真行为
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
