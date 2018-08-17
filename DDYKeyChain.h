//
//  DDYKeyChain.h
//  DDYAuthorityManager
//
//  Created by SmartMesh on 2018/6/25.
//  Copyright © 2018年 SmartMeshFoundation. All rights reserved.
//

#import <Foundation/Foundation.h>
// 钥匙串使用
@import Security;

@interface DDYKeyChain : NSObject

/** 钥匙串保存 */
+ (void)saveKeyChainWithService:(NSString *)service data:(id)data;
/** 钥匙串读取 */
 + (id)loadKeyChainWithService:(NSString *)service;
/** 钥匙串删除 */
+ (void)deleteKeyChainWithService:(NSString *)service;

@end
