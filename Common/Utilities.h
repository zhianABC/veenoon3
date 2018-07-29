//
//  Utilities.h
//  
//
//  Created by Error on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject
{

}

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;

+ (NSString*)intToString:(int)intVal;

+ (NSString*)checkFileExsitWithUrl:(NSString*)url mime:(NSString*)mime;

+ (BOOL) validateEmail:(NSString*)emailStr;
+ (BOOL) IsValidMobeilTel:(const char*)pszTel;
+ (void) showMessage:(NSString*)message ctrl:(UIViewController*)ctrl;
@end
