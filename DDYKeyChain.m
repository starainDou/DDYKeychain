//
//  DDYKeyChain.m
//  DDYAuthorityManager
//
//  Created by SmartMesh on 2018/6/25.
//  Copyright © 2018年 SmartMeshFoundation. All rights reserved.
//

#import "DDYKeyChain.h"

@implementation DDYKeyChain

#pragma mark - 钥匙串操作
#pragma mark 配置
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword, (id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock, (id)kSecAttrAccessible,
            nil];
}

#pragma mark 钥匙串保存
+ (void)saveKeyChainWithService:(NSString *)service data:(id)data {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark 钥匙串读取
+ (id)loadKeyChainWithService:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try { ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];}
        @catch (NSException *e) { NSLog(@"Unarchive of %@ failed: %@", service, e);}
        @finally { }
    }
    if (keyData) CFRelease(keyData);
    return ret;
}

#pragma mark 钥匙串删除
+ (void)deleteKeyChainWithService:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

@end
