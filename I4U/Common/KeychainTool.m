//
//  KeychainTool.m
//  I4U
//
//  Created by Darcy on 2019/5/9.
//  Copyright © 2019 CY. All rights reserved.
//

#import "KeychainTool.h"

@implementation KeychainTool

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id )kSecClassGenericPassword,
            (__bridge_transfer id)kSecClass,service,
            (__bridge_transfer id)kSecAttrService,service,
            (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,
            (__bridge_transfer id)kSecAttrAccessible,
            nil];
}

+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey {
    
    NSMutableDictionary *keychainQury = [self getKeyChainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQury);
    [keychainQury setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQury, NULL);
    
}

+ (NSString *)readkeychainValue:(NSString *)sKey {
    
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:sKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    
    return ret;
    
}

+ (void)deleteKeychainValue:(NSString *)sKey {
    
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:sKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    
}

//保存用户信息目录
+ (NSString *)getUserInfoPath:(NSString *)key {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    //获取所有信息字典
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",documentPath,key];
    return filePath;
}

@end
