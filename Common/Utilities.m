//
//  Utilities.m
//  MobileLooks
//
//  Created by jack on 8/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "Configure.h"

@implementation Utilities

+ (NSString*)intToString:(int)intVal{
	
	int tVal = intVal;
    
    if(tVal == 0)
        return @"0";
	
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	int tm = tVal/1000;
	int td = tVal%1000;
	
	if(td>=100){
		NSString *s = [NSString stringWithFormat:@"%d", td];
		[temp addObject:s];
	}
	else {
		if(tm > 0){
			NSString *s = [NSString stringWithFormat:@"0%02d", td];
			[temp addObject:s];
		}
		else {
			NSString *s = [NSString stringWithFormat:@"%02d", td];
			[temp addObject:s];
		}
	}

	while (tm > 1000) {
		
		tVal = tm;
		
		tm = tVal/1000;
		td = tVal%1000;
		
		if(td>=100){
			NSString *s = [NSString stringWithFormat:@"%d", td];
			[temp addObject:s];
		}
		else {
			if(tm > 0){
				NSString *s = [NSString stringWithFormat:@"0%02d", td];
				[temp addObject:s];
			}
			else {
				NSString *s = [NSString stringWithFormat:@"%02d", td];
				[temp addObject:s];
			}
		}
		
	}
	
	if(tm > 0){
		NSString *s = [NSString stringWithFormat:@"%d", tm];
		[temp addObject:s];
	}

	NSString *res = @"";
	
	for(int i = [temp count] - 1; i>= 0; i--){
		
		if(i == [temp count] - 1){
			res = [NSString stringWithFormat:@"%@", [temp objectAtIndex:i]];
		}
		else
			res = [NSString stringWithFormat:@"%@,%@", res, [temp objectAtIndex:i]];
		
	}
	
	return res;
}


+(NSString *)bundlePath:(NSString *)fileName {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)savedKeyFrameImagePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"video_choosed_key_frame.png"];	
	return imagePath;
}

+(NSString *)savedVideoPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:@"video_choosed.mov"];
	
	return videoPath;
}

+(void)createCarModelDir:(NSString*)model{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:model];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if(![fileManager fileExistsAtPath:dir]){
		[fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
	}
}

+(void)removeFilePath:(NSString*)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
        [fileManager removeItemAtPath:path error:nil];
    }
}

+(void)writeToCarModel:(NSString*)model filename:(NSString*)filename data:(NSData*)data{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dir = [documentsDirectory stringByAppendingPathComponent:model];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if(![fileManager fileExistsAtPath:dir]){
		[fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
	}
	
	NSString *filePath = [dir stringByAppendingPathComponent:filename];
	
	[data writeToFile:filePath atomically:YES];
}
+(void)modifyFileDate:(NSString *)path interval:(NSTimeInterval)interval{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]){
		
		NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:nil];
		NSMutableDictionary *newAttr = [NSMutableDictionary dictionaryWithDictionary:attr];
		[newAttr setObject:[NSDate dateWithTimeIntervalSince1970:interval] forKey:NSFileCreationDate];
		[newAttr setObject:[NSDate dateWithTimeIntervalSince1970:interval] forKey:NSFileModificationDate];
		[fileManager setAttributes:newAttr ofItemAtPath:path error:nil];
		
	}
}

+(BOOL)isNeedUpadate:(NSString*)path timestamp:(NSTimeInterval)timestamp{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:path]){
		NSDictionary *attr = [fileManager attributesOfItemAtPath:path error:nil];
		NSDate *old = [attr objectForKey:NSFileCreationDate];
		NSDate *new = [NSDate dateWithTimeIntervalSince1970:timestamp];
		
		if([old isEqualToDate:new]){
			return NO;
		}
	}
	return YES;
}


+ (NSString*) checkFileExsitWithUrl:(NSString *)url mime:(NSString*)mime
{
    NSString *fileName = md5Encode(url);
    NSString *ext = @".pdf";
    if([mime isEqualToString:@"video/mp4"])
    {
        ext = @".mp4";
    }
    else if([mime isEqualToString:@"video/quicktime"])
    {
        ext = @".mov";
    }
    
    fileName = [NSString stringWithFormat:@"BookAssets/%@%@", fileName,ext];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbPath])
    {
        return nil;
    }
    
    return dbPath;
}

+ (BOOL) validateEmail:(NSString*)emailStr {
    if (emailStr == nil || [emailStr isEqualToString:@""] || [emailStr length] == 0) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\w+([-+.]\\\\w+)*@\\\\w+([-.]\\\\w+)*\\\\.\\\\w+([-.]\\\\w+)*'"];
    BOOL ok = [predicate evaluateWithObject:emailStr];
    return ok;
}


+ (BOOL) IsValidMobeilTel:(const char*)pszTel
{
    BOOL tyle = YES;
    int len = (int)strlen(pszTel);
    
    if(pszTel == NULL || len<1)
    {
        return NO;
    }
    
    
    if(len != 11)
    {
        return NO;
    }
    int i = 0;
    while (i < len)
    {
        if(!isdigit(pszTel[i]))
        {
            return NO;
        }
        
        if(i == 0)
        {
            if(pszTel[i] != '1')
            {
                return NO;
            }
        }
        
        i++;
    }
    return tyle;
}


+ (void) showMessage:(NSString*)message ctrl:(UIViewController*)ctrl{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *takeAction = [UIAlertAction
                                 actionWithTitle:@"确定"
                                 style:UIAlertActionStyleDefault
                                 handler:nil];
    [alert addAction:takeAction];
    
    [ctrl presentViewController:alert animated:YES
                     completion:nil];
}

+ (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}

@end
