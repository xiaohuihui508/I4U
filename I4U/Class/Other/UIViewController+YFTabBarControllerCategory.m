//
//  UIViewController+YFTabBarControllerCategory.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIViewController+YFTabBarControllerCategory.h"
#import "YFTabBerViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (YFTabBarControllerCategory)
#pragma mark -
#pragma mark - public Methods

- (UIViewController *)yf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index {
    [self checkTabBarChildControllerValidityAtIndex:index];
    [self.navigationController popToRootViewControllerAnimated:NO];
    YFTabBerViewController *tabBarController = [self yf_tabBarController];
    tabBarController.selectedIndex = index;
    UIViewController *selectedTabBarChildViewController = tabBarController.selectedViewController;
    return [selectedTabBarChildViewController yf_getViewControllerInsteadIOfNavigationController];
}

- (void)yf_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                          completion:(YFPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self yf_popSelectTabBarChildViewControllerAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (UIViewController *)yf_popSelectTabBarChildViewControllerForClassType:(Class)classType {
    YFTabBerViewController *tabBarController = [self yf_tabBarController];
    NSArray *viewControllers = tabBarController.viewControllers;
    NSInteger atIndex = [self yf_indexForClassType:classType inViewControllers:viewControllers];
    return [self yf_popSelectTabBarChildViewControllerAtIndex:atIndex];
}

- (void)yf_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                               completion:(YFPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self yf_popSelectTabBarChildViewControllerForClassType:classType];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (void)yf_pushOrPopToViewController:(UIViewController *)viewController
                            animated:(BOOL)animated
                            callback:(YFPushOrPopCallback)callback {
    if (!callback) {
        [self.navigationController pushViewController:viewController animated:animated];
        return;
    }
    
    void (^popSelectTabBarChildViewControllerCallback)(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) = ^(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) {
        if (shouldPopSelectTabBarChildViewController) {
            [self yf_popSelectTabBarChildViewControllerAtIndex:index completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
                [selectedTabBarChildViewController.navigationController pushViewController:viewController animated:animated];
            }];
        } else {
            [self.navigationController pushViewController:viewController animated:animated];
        }
    };
    NSArray<__kindof UIViewController *> *otherSameClassTypeViewControllersInCurrentNavigationControllerStack = [self yf_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:viewController];
    
    YFPushOrPopCompletionHandler completionHandler = ^(BOOL shouldPop,
                                                       __kindof UIViewController *viewControllerPopTo,
                                                       BOOL shouldPopSelectTabBarChildViewController,
                                                       NSUInteger index
                                                       ) {
        if (!otherSameClassTypeViewControllersInCurrentNavigationControllerStack || otherSameClassTypeViewControllersInCurrentNavigationControllerStack.count == 0) {
            shouldPop = NO;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if (shouldPop) {
                [self.navigationController popToViewController:viewControllerPopTo animated:animated];
                return;
            }
            popSelectTabBarChildViewControllerCallback(shouldPopSelectTabBarChildViewController, index);
        });
    };
    callback(otherSameClassTypeViewControllersInCurrentNavigationControllerStack, completionHandler);
}

- (void)yf_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *fromViewController = [self yf_getViewControllerInsteadIOfNavigationController];
    NSArray *childViewControllers = fromViewController.navigationController.childViewControllers;
    if (childViewControllers.count > 0) {
        if ([[childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
    }
    [fromViewController.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)yf_getViewControllerInsteadIOfNavigationController {
    BOOL isNavigationController = [[self class] isSubclassOfClass:[UINavigationController class]];
    if (isNavigationController) {
        return ((UINavigationController *)self).viewControllers[0];
    }
    return self;
}

#pragma mark - public method

- (BOOL)yf_isPlusChildViewController {
    if (!YFPlusChildViewController) {
        return NO;
    }
    return (self == YFPlusChildViewController);
}

- (void)yf_showTabBadgePoint {
    if (self.yf_isPlusChildViewController) {
        return;
    }
    [self.yf_tabButton yf_showTabBadgePoint];
}

- (void)yf_removeTabBadgePoint {
    if (self.yf_isPlusChildViewController) {
        return;
    }
    [self.yf_tabButton yf_removeTabBadgePoint];
}

- (BOOL)yf_isShowTabBadgePoint {
    if (self.yf_isPlusChildViewController) {
        return NO;
    }
    return [self.yf_tabButton yf_isShowTabBadgePoint];
}

- (void)yf_setTabBadgePointView:(UIView *)tabBadgePointView {
    if (self.yf_isPlusChildViewController) {
        return;
    }
    [self.yf_tabButton yf_setTabBadgePointView:tabBadgePointView];
}

- (UIView *)yf_tabBadgePointView {
    if (self.yf_isPlusChildViewController) {
        return nil;
    }
    return [self.yf_tabButton yf_tabBadgePointView];;
}

- (void)yf_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    if (self.yf_isPlusChildViewController) {
        return;
    }
    return [self.yf_tabButton yf_setTabBadgePointViewOffset:tabBadgePointViewOffset];
}

//offset如果都是整数，则往右下偏移
- (UIOffset)yf_tabBadgePointViewOffset {
    if (self.yf_isPlusChildViewController) {
        return UIOffsetZero;
    }
    return [self.yf_tabButton yf_tabBadgePointViewOffset];
}

- (BOOL)yf_isEmbedInTabBarController {
    if (self.yf_tabBarController == nil) {
        return NO;
    }
    if (self.yf_isPlusChildViewController) {
        return NO;
    }
    BOOL isEmbedInTabBarController = NO;
    UIViewController *viewControllerInsteadIOfNavigationController = [self yf_getViewControllerInsteadIOfNavigationController];
    for (NSInteger i = 0; i < self.yf_tabBarController.viewControllers.count; i++) {
        UIViewController * vc = self.yf_tabBarController.viewControllers[i];
        if ([vc yf_getViewControllerInsteadIOfNavigationController] == viewControllerInsteadIOfNavigationController) {
            isEmbedInTabBarController = YES;
            [self yf_setTabIndex:i];
            break;
        }
    }
    return isEmbedInTabBarController;
}

- (void)yf_setTabIndex:(NSInteger)tabIndex {
    objc_setAssociatedObject(self, @selector(yf_tabIndex), @(tabIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)yf_tabIndex {
    if (!self.yf_isEmbedInTabBarController) {
        return NSNotFound;
    }
    
    id tabIndexObject = objc_getAssociatedObject(self, @selector(yf_tabIndex));
    NSInteger tabIndex = [tabIndexObject integerValue];
    return tabIndex;
}

- (UIControl *)yf_tabButton {
    if (!self.yf_isEmbedInTabBarController) {
        return nil;
    }
    UITabBarItem *tabBarItem;
    UIControl *control;
    @try {
        tabBarItem = self.yf_tabBarController.tabBar.items[self.yf_tabIndex];
        control = [tabBarItem yf_tabButton];
    } @catch (NSException *exception) {}
    return control;
}


#pragma mark -
#pragma mark - Private Methods

- (NSArray<__kindof UIViewController *> *)yf_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:(UIViewController *)viewController {
    NSArray *currentNavigationControllerStack = [self.navigationController childViewControllers];
    if (currentNavigationControllerStack.count < 2) {
        return nil;
    }
    NSMutableArray *mutableArray = [currentNavigationControllerStack mutableCopy];
    [mutableArray removeObject:self];
    currentNavigationControllerStack = [mutableArray copy];
    
    __block NSMutableArray *mutableOtherViewControllersInNavigationControllerStack = [NSMutableArray arrayWithCapacity:currentNavigationControllerStack.count];
    
    [currentNavigationControllerStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *otherViewController = obj;
        if ([otherViewController isKindOfClass:[viewController class]]) {
            [mutableOtherViewControllersInNavigationControllerStack addObject:otherViewController];
        }
    }];
    return [mutableOtherViewControllersInNavigationControllerStack copy];
}

- (void)checkTabBarChildControllerValidityAtIndex:(NSUInteger)index {
    YFTabBerViewController *tabBarController = [self yf_tabBarController];
    @try {
        UIViewController *viewController;
        viewController = tabBarController.viewControllers[index];
        UIButton *plusButton = YFExternPlusButton;
        BOOL shouldConfigureSelectionStatus = (YFPlusChildViewController) && ((index != YFPlusButtonIndex) && (viewController != YFPlusChildViewController));
        if (shouldConfigureSelectionStatus) {
            plusButton.selected = NO;
        }
    } @catch (NSException *exception) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------------------------------------------------------------\n \
        class name: %@                                                                                    \n \
        ------line: %@                                                                                    \n \
        ----reason: The Class Type or the index or its NavigationController you pass in method `-cyl_popSelectTabBarChildViewControllerAtIndex` or `-cyl_popSelectTabBarChildViewControllerForClassType` is not the item of CYLTabBarViewController \n \
        ------ END ---------------------------------------------------------------------------------------\n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__)];
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:reason
                                     userInfo:nil];
    }
}

- (NSInteger)yf_indexForClassType:(Class)classType inViewControllers:(NSArray *)viewControllers {
    __block NSInteger atIndex = NSNotFound;
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *obj_ = [obj yf_getViewControllerInsteadIOfNavigationController];
        if ([obj_ isKindOfClass:classType]) {
            atIndex = idx;
            *stop = YES;
            return;
        }
    }];
    return atIndex;
}


@end
