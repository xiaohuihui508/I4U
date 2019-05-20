//
//  ScanVC.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "ScanVC.h"

@interface ScanVC ()

@end

@implementation ScanVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIButton *btn = [UIButton new];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.width.equalTo(150);
        make.height.equalTo(60);
    }];
    
    mWeakSelf
    [btn tapAction:^NSString * _Nullable{
        [weakSelf initUI];
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        return @"点击button的按钮";
    }];
}
- (void)initUI {
    UIWindow *window = FUWindow;
    YFTabBerViewController *root = (YFTabBerViewController*)window.rootViewController;
    [root setSelectedIndex:root.beforeIndex];
    
}



@end
