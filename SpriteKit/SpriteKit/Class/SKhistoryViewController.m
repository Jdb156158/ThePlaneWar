//
//  SKhistoryViewController.m
//  SpriteKit
//
//  Created by Jdb on 16/2/23.
//  Copyright © 2016年 CpSoft. All rights reserved.
//

#import "SKhistoryViewController.h"

@interface SKhistoryViewController ()

@end

@implementation SKhistoryViewController
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    UINavigationBar *nav = [[UINavigationBar alloc]init];
    nav.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);
    nav.backgroundColor = [UIColor blackColor];
    [self.view addSubview:nav];
    
    UIView *backview = [[UIView alloc] init];
    backview.backgroundColor = [UIColor blackColor];
    backview.frame = nav.frame;
    [nav addSubview:backview];
    
    UIButton * BackBtn = [[UIButton alloc]init];
    BackBtn.tag = 9;
    BackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [BackBtn setTitle:@"<返回" forState:UIControlStateNormal];
    [BackBtn setFrame:CGRectMake(5, 0, 50, 44)];
    BackBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [BackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [BackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backview addSubview:BackBtn];
    
    UILabel * titlename = [[UILabel alloc]init];
    [titlename setText:@"历史战绩"];
    titlename.textColor = [UIColor whiteColor];
    titlename.font = [UIFont systemFontOfSize:15.0f];
    titlename.textAlignment = NSTextAlignmentCenter;
    [titlename setFrame:CGRectMake((CGRectGetWidth(self.view.frame)-100)/2, 0, 120, 44)];
    [backview addSubview:titlename];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)back:(UIButton *)secoint
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //标签栏显示
    if (!pagesContainer)
    {
        pagesContainer = [[DAPagesContainer alloc] init];
    }
    [pagesContainer willMoveToParentViewController:self];
    pagesContainer.view.frame = CGRectMake(0,44,self.view.bounds.size.width,self.view.bounds.size.height-44);//self.view.bounds;
    pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:pagesContainer.view];
    [pagesContainer didMoveToParentViewController:self];
    
    SKhistoryjindianViewController *historyjindian = [[SKhistoryjindianViewController alloc] init];
    historyjindian.title = @"经典模式";
    
    SKhistorytiaozhanViewController *historytiaozhan = [[SKhistorytiaozhanViewController alloc] init];
    historytiaozhan.title = @"挑战模式";
    
    pagesContainer.viewControllers = @[historyjindian,historytiaozhan];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [pagesContainer updateLayoutForNewOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
