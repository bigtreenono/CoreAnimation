//
//  ViewController.m
//  CALayer
//
//  Created by hdf on 15/12/31.
//  Copyright © 2015年 董知樾. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *classString = self.array[indexPath.row];
    Class class = NSClassFromString(classString);
    UIViewController *layerVC = (UIViewController *)[[class alloc]init];
    layerVC.title = classString;
    layerVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:layerVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSArray *)array{
    if (!_array) {
        _array = @[@"CALayerType",@"CATextLayerType",@"CAShapeLayerType",@"CATiledLayerType",@"CAGradientLayerType",@"CAEmitterLayerType",@"CAReplicatorLayerType",@"CAScrollLayerType",@"CATransformLayerType"];
    }
    return _array;
}

@end