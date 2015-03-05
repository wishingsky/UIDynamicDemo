//
//  NewtonCradleViewController.m
//  DynamicTest
//
//  Created by willie_wei on 14-9-19.
//  Copyright (c) 2014年 WCC. All rights reserved.
//

#import "NewtonCradleViewController.h"
#import "NewtonsCradleView.h"

@interface NewtonCradleViewController ()

@end

@implementation NewtonCradleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NewtonsCradleView *newtonCradleView = [[NewtonsCradleView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:newtonCradleView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
