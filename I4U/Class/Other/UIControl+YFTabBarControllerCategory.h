//
//  UIControl+YFTabBarControllerCategory.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (YFTabBarControllerCategory)


- (UIView *)yf_tabBadgeView;
- (UIImageView *)yf_tabImageView;
- (UILabel *)yf_tabLabel;

/*!
 * 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-cyl_removeTabBadgePoint` 后会重新展示。
 */
- (void)yf_showTabBadgePoint;
- (void)yf_removeTabBadgePoint;
- (BOOL)yf_isShowTabBadgePoint;

@property (nonatomic, strong, setter=yf_setTabBadgePointView:, getter=yf_tabBadgePointView) UIView *yf_tabBadgePointView;
@property (nonatomic, assign, setter=yf_setTabBadgePointViewOffset:, getter=yf_tabBadgePointViewOffset) UIOffset yf_tabBadgePointViewOffset;

@end


NS_ASSUME_NONNULL_END
