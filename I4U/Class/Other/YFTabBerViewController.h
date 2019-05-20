//
//  YFTabBerViewController.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFTabBerViewController;
typedef void(^YFViewDidLayoutSubViewsBlock)(YFTabBerViewController *tabBarController);

FOUNDATION_EXTERN NSString *const YFTabBarItemTitle;
FOUNDATION_EXTERN NSString *const YFTabBarItemImage;
FOUNDATION_EXTERN NSString *const YFTabBarItemSelectedImage;
FOUNDATION_EXTERN NSUInteger YFTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger YFPlusButtonIndex;
FOUNDATION_EXTERN CGFloat YFPlusButtonWidth;
FOUNDATION_EXTERN CGFloat YFTabBarItemWidth;

@protocol YFTabBerViewControllerDelegate <NSObject>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;
@end
@interface YFTabBerViewController : UITabBarController<YFTabBerViewControllerDelegate, UITabBarControllerDelegate>
@property (nonatomic, copy) YFViewDidLayoutSubViewsBlock viewDidLayoutSubviewsBlock;

@property (nonatomic, assign) NSInteger beforeIndex;//新增点击对应tabbar需要返回的值


- (void)setViewDidLayoutSubViewsBlock:(YFViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock;

/*!
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;

/*!
 * The Attributes of items which is displayed on the tab bar.
 */
@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 * Customize UITabBar height
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/*!
 * To set both UIBarItem image view attributes in the tabBar,
 * default is UIEdgeInsetsZero.
 */
@property (nonatomic, readonly, assign) UIEdgeInsets imageInsets;

/*!
 * To set both UIBarItem label text attributes in the tabBar,
 * use the following to tweak the relative position of the label within the tab button (for handling visual centering corrections if needed because of custom text attributes)
 */
@property (nonatomic, readonly, assign) UIOffset titlePositionAdjustment;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                            imageInsets:(UIEdgeInsets)imageInsets
                titlePositionAdjustment:(UIOffset)titlePositionAdjustment;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                                        imageInsets:(UIEdgeInsets)imageInsets
                            titlePositionAdjustment:(UIOffset)titlePositionAdjustment;

- (void)updateSelectionStatusIfNeededForTabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/*!
 * Judge if there is plus button.
 */
+ (BOOL)havePlusButton;

/*!
 * @attention Include plusButton if exists.
 */
+ (NSUInteger)allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;

- (UIWindow *)rootWindow;

@end

@interface NSObject (YFTabBarControllerReferenceExtension)

/*!
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `CYLTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, setter=yf_setTabBarController:) YFTabBerViewController *yf_tabBarController;

@end

FOUNDATION_EXTERN NSString *const YFTabBarItemWidthDidChangeNotification;
