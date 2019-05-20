//
//  UITabBarItem+YFTabBarControllerCategory.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UITabBarItem+YFTabBarControllerCategory.h"
#import <objc/runtime.h>
#import "UIControl+YFTabBarControllerCategory.h"

@implementation UITabBarItem (YFTabBarControllerCategory)

+ (void)load {
    [self yf_swizzleSetBadgeValue];
}

+ (void)yf_swizzleSetBadgeValue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yf_ClassMethodSwizzle([self class], @selector(setBadgeValue:), @selector(yf_setBadgeValue:));
    });
}

- (void)yf_setBadgeValue:(NSString *)badgeValue {
    [self.yf_tabButton yf_removeTabBadgePoint];
    [self yf_setBadgeValue:badgeValue];
}

- (UIControl *)yf_tabButton {
    UIControl *control = [self valueForKey:@"view"];
    return control;
}

#pragma mark - private method

BOOL yf_ClassMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

@end

