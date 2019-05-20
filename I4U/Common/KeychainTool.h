//
//  KeychainTool.h
//  I4U
//
//  Created by Darcy on 2019/5/9.
//  Copyright © 2019 CY. All rights reserved.
/***********
 *
 * 把字符串储存到钥匙串中或（从字符串中取出字符串）或（从钥匙串中删除字符串）
 *
 *********/

#import <Foundation/Foundation.h>
#import <Security/Security.h>


NS_ASSUME_NONNULL_BEGIN

@interface KeychainTool : NSObject

/**
 *
 * 储存字符串到🔑钥匙串
 * @param sValue 对应Value
 * @param sKey 对应Key
 */

+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;

/**
 * 从🔑钥匙串获取字符串
 *
 * @param sKey 对应的key
 *
 * @return 返回储存的Value
 */

+ (NSString *)readkeychainValue:(NSString *)sKey;

/**
 * 从🔑钥匙串中删除字符串
 *
 * @param sKey 对应的key
 */

+ (void)deleteKeychainValue:(NSString *)sKey;

/**
 * 保存用户信息目录
 *
 */
+ (NSString *)getUserInfoPath:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
