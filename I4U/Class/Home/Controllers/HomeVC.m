//
//  HomeVC.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "HomeVC.h"
#import "HomeDetailVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 100, 100);//11565
    [self.view addSubview:btn];
    
    mWeakSelf
    [btn tapAction:^NSString * _Nullable{
        HomeDetailVC *vc = [[HomeDetailVC alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        return @"button的点击事件";
    }];
    
}

@end
