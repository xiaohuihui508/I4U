//
//  YFTabBarControllerConfig.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFTabBerViewController.h"

@interface YFBaseNavigationController : UINavigationController

@end


@interface YFTabBarControllerConfig : NSObject
@property (nonatomic, readonly, strong) YFTabBerViewController *tabBarController;
@end
