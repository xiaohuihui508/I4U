//
//  RTConstants.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#ifndef RTConstants_h
#define RTConstants_h

#define RT_DEPRECATED(explain) __attribute__((deprecated(explain)))
#define RT_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define RT_IS_IPHONE_X (RT_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)
#define RT_IS_IPHONE_XS (RT_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 896.0f)
#define RT_IS_IOS_11  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)

#endif /* RTConstants_h */
