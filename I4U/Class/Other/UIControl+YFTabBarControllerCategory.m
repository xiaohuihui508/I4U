//
//  UIControl+YFTabBarControllerCategory.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIControl+YFTabBarControllerCategory.h"
#import <objc/runtime.h>
#import "UIView+YFTabBarControllerCategory.h"

@implementation UIControl (YFTabBarControllerCategory)
- (void)yf_showTabBadgePoint {
    [self yf_setShowTabBadgePointIfNeeded:YES];
}

- (void)yf_removeTabBadgePoint {
    [self yf_setShowTabBadgePointIfNeeded:NO];
}

- (BOOL)yf_isShowTabBadgePoint {
    return !self.yf_tabBadgePointView.hidden;
}

- (void)yf_setShowTabBadgePointIfNeeded:(BOOL)showTabBadgePoint {
    @try {
        [self yf_setShowTabBadgePoint:showTabBadgePoint];
    } @catch (NSException *exception) {
        NSLog(@"CYLPlusChildViewController do not support set TabBarItem red point");
    }
}

- (void)yf_setShowTabBadgePoint:(BOOL)showTabBadgePoint {
    if (showTabBadgePoint && self.yf_tabBadgePointView.superview == nil) {
        [self addSubview:self.yf_tabBadgePointView];
        [self bringSubviewToFront:self.yf_tabBadgePointView];
        self.yf_tabBadgePointView.layer.zPosition = MAXFLOAT;
        // X constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.yf_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:0
                                         toItem:self.yf_tabImageView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:self.yf_tabBadgePointViewOffset.horizontal]];
        //Y constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.yf_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:0
                                         toItem:self.yf_tabImageView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:self.yf_tabBadgePointViewOffset.vertical]];
    }
    self.yf_tabBadgePointView.hidden = showTabBadgePoint == NO;
    self.yf_tabBadgeView.hidden = showTabBadgePoint == YES;
}

- (void)yf_setTabBadgePointView:(UIView *)tabBadgePointView {
    if (tabBadgePointView.superview) {
        [tabBadgePointView removeFromSuperview];
    }
    
    tabBadgePointView.hidden = YES;
    objc_setAssociatedObject(self, @selector(yf_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)yf_tabBadgePointView {
    UIView *tabBadgePointView = objc_getAssociatedObject(self, @selector(yf_tabBadgePointView));
    
    if (tabBadgePointView == nil) {
        tabBadgePointView = self.cyl_defaultTabBadgePointView;
        objc_setAssociatedObject(self, @selector(yf_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tabBadgePointView;
}

- (void)yf_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    objc_setAssociatedObject(self, @selector(yf_tabBadgePointViewOffset), [NSValue valueWithUIOffset:tabBadgePointViewOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//offset如果都是正数，则往右下偏移
- (UIOffset)yf_tabBadgePointViewOffset {
    id tabBadgePointViewOffsetObject = objc_getAssociatedObject(self, @selector(yf_tabBadgePointViewOffset));
    UIOffset tabBadgePointViewOffset = [tabBadgePointViewOffsetObject UIOffsetValue];
    return tabBadgePointViewOffset;
}

- (UIView *)cyl_tabBadgeView {
    for (UIView *subview in self.subviews) {
        if ([subview yf_isTabBadgeView]) {
            return (UIView *)subview;
        }
    }
    return nil;
}

- (UIImageView *)cyl_tabImageView {
    for (UIImageView *subview in self.subviews) {
        if ([subview yf_isTabImageView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (UILabel *)cyl_tabLabel {
    for (UILabel *subview in self.subviews) {
        if ([subview yf_isTabLabel]) {
            return (UILabel *)subview;
        }
    }
    return nil;
}

#pragma mark - private method

- (UIView *)cyl_defaultTabBadgePointView {
    UIView *defaultRedTabBadgePointView = [UIView yf_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    return defaultRedTabBadgePointView;
}


@end
