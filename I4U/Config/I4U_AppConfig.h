//
//  I4U_AppConfig.h
//  I4U
//
//  Created by Darcy on 2019/4/17.
//  Copyright © 2019 CY. All rights reserved.
//

#ifndef I4U_AppConfig_h
#define I4U_AppConfig_h

///MARK: 网络请求环境
#ifdef DEBUG

///预发布环境和测试环境
#define N_HostSiteMain @"http://dev.i4u.net.cn"//预发布环境
#define WebMain @"http://m.yingfeng365.top" //WEB

#else

///正式环境主站点（勿动)
#define N_HostSiteMain @"http://www.i4u.net.cn"//正式环境
#define WebMain @"http://m.yingfeng365.com" //WEB

#endif

///MARK:APP基本色=========
#define kConfigNorColor    mHexColor(0x919090) //主题未选中的颜色
#define kConfigColor       mHexColor(0x27B0E1) //主题色
#define kLineColor         mHexColor(0xF0F0F0) //分割线的颜色
#define kBottomColor       mHexColor(0xFFFFFF) //背景色
#define kBlackColor        mHexColor(0x333333) //主标题颜色值
#define kTabbarLingColor   mHexColor(0xCCCCCC) //导航栏分割线和tabbar分割线
#define kTabbarBackColor   mHexColor(0xF8F8F8) //tabbar的背景色
#define kWhiteColor        mHexColor(0xFFFFFF) //白色的字体颜色




///MARK: app 基本字体大小
#define kFont12             [UIFont systemFontOfSize:12]
#define kFont13             [UIFont systemFontOfSize:13]
#define kFont14             [UIFont systemFontOfSize:14]
#define kFont15             [UIFont systemFontOfSize:15]
#define kFont16             [UIFont systemFontOfSize:16]



///MARK: rgb颜色转换（16进制->10进制）
#define mHexColor(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define mHexColorAlpha(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:a]


#endif /* I4U_AppConfig_h */
