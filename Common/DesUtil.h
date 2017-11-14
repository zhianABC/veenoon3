//
//  DesUtil.h
//  testecb
//
//  Created by chen jack on 2017/5/12.
//  Copyright © 2017年 chen jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject
{
    
}
/**
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;

@end
