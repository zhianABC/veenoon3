//
//  ConverUtil.h
//  testecb
//
//  Created by chen jack on 2017/5/12.
//  Copyright © 2017年 chen jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConverUtil : NSObject

+ (NSString *)md5Encode:( NSString *)str;

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text;

/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;

/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

@end
