//
//  DesUtil.m
//  testecb
//
//  Created by chen jack on 2017/5/12.
//  Copyright © 2017年 chen jack. All rights reserved.
//

#import "DesUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "ConverUtil.h"
@implementation DesUtil


static Byte iv[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
/*
 DES加密
 */
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    /*
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [clearText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          keyPtr,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [ConverUtil parseByteArray2HexString:bb];
    }else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
     */
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *keyData = [ConverUtil parseHexToByteArray:key];
    
    
    
    NSData* data = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [keyData bytes],
                                          [keyData length],
                                          iv,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        NSString* ciphertext = [ConverUtil parseByteArray2HexString:bb];
        
        return ciphertext;
    }
    return nil;
}

/**
 DES解密
 */
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *kivStr = @"ee2cf797325c7f2ee14e2cb8aa643478";
    
    NSData *kiv = [ConverUtil parseHexToByteArray:kivStr];
    NSData *keyData = [ConverUtil parseHexToByteArray:key];
    NSData *data = [ConverUtil parseHexToByteArray:plainText];
    
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [keyData bytes],
                                          [keyData length],
                                          [kiv bytes],
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        //NSLog(@"DES解密成功");
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];

        
        NSString* str = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        
        
        return str;
    }
    //free(buffer);
    return nil;
    
}


@end
