//
//  ViewController.m
//  Quartz2D
//
//  Created by FNNishipu on 7/1/15.
//  Copyright (c) 2015 FNNishipu. All rights reserved.
//

#import "ViewController.h"
#import "KCView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    KCView *view=[[KCView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
