//
//  UIView+YFTabBarControllerCategory.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//


@end
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YFTabBarControllerCategory)

- (BOOL)yf_isPlusButton;
- (BOOL)yf_isTabButton;
- (BOOL)yf_isTabImageView;
- (BOOL)yf_isTabLabel;
- (BOOL)yf_isTabBadgeView;

+ (UIView *)yf_tabBadgePointViewWithClolor:(UIColor *)color radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
