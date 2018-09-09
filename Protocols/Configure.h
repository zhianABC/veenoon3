//
//  Configure.h
//  HomeSearch
//
//  Created by Jack chen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>



#define POSTDataSeparator			@"----------sadkfjaskdjfkjsadfjj3234234"

#define   WEB_API_URL           @"http://39.106.67.198:8080/api"
#define   NEW_API_U2P           @"/v1/utility/u2p"

#define   NEW_API_LOGIN         @"GetUserLoginInfoServelet"
#define   NEW_API_SCAN_QR       @"/v1/qr/"
#define   NEW_API_REG_ADM       @"/v1/admission/register"
#define   NEW_API_EVENT_LIST    @"/v1/event/listing"
#define   NEW_API_CHECKIN       @"/v1/admission/chkin"
#define   NEW_API_CHECKIN_BAR   @"/v1/emergcode/chkin"

typedef void(^RequestBlock)(id lParam,id rParam);

static NSString * audio_process_name = @"音频处理";
static NSString * audio_power_sequencer = @"电源管理";
static NSString * audio_mixer_name = @"混音会议";
static NSString * audio_handtohand_name = @"有线会议";
static NSString * audio_wireless_name = @"无线会议";
static NSString * video_touying_name = @"投影机";
static NSString * video_camera_name = @"摄像机";
static NSString * env_dimmer_light  = @"照明";
static NSString * video_process_name  = @"视频处理";
static NSString * env_blind_name = @"电动马达";
static NSString * other_air_quality = @"空气质量";

#define   HOME_LIST_CELL_COLOR   [UIColor colorWithRed:0xe1/255.0 green:0xe1/255.0 blue:0xe1/255.0 alpha:1.0]
#define   ASK_ANSWER_CELL_COLOR  [UIColor colorWithRed:0xee/255.0 green:0xf3/255.0 blue:0xf6/255.0 alpha:1.0]
#define   REPLY_CELL_COLOR       [UIColor colorWithRed:199.0/255.0 green:202.0/255.0 blue:204.0/255.0 alpha:1.0]


#define   DRAG_OFF_SET		70



static inline BOOL checkEnglish(int from, int to, NSString* text)
{
    //65－90 A-Z
    //97-122  a-z
    //48-57 0-9
    const char* ch = [text UTF8String];
    
    int max = to;
    if(max > (int)[text length])
        max = (int)[text length];
    
    for(int i = from; i < max; i++){
        
        char c = ch[i];
        if( (c >= '0' && c <= '9') || (c>='a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_')
        {
            continue;
        }
        else
        {
            return NO;
        }
        
    }
    
    return YES;
}

static inline BOOL checkIsNumber(int from, int to, NSString* text)
{
    //65－90 A-Z
    //97-122  a-z
    //48-57 0-9
    const char* ch = [text UTF8String];
    
    int max = to;
    if(max > (int)[text length])
        max = (int)[text length];
    
    for(int i = from; i < max; i++){
        
        char c = ch[i];
        if(c >= '0' && c <= '9')
        {
            continue;
        }
        else
        {
            return NO;
        }
        
    }
    
    return YES;
}

static inline NSString *md5Encode( NSString *str ) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *string = [NSString stringWithFormat:
						@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
						result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
						];
    return [string lowercaseString];
}


//EEE MMM dd HH:mm:ss z yyyy
static inline NSDate* nsstringToNSDate(NSString *datestring)
{
	NSString *tmpdateString = datestring;
		
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	
	// set default time zone by device own zone.
	[formatter setTimeZone:[NSTimeZone defaultTimeZone]];
	
	// convert the time keep on 24-hour
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"US"];
	[formatter setLocale:usLocale];

	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *date = [formatter dateFromString:tmpdateString];

	return date;
}

static inline BOOL dayDiff(NSDate* today, NSDate* other)
{
	int iToday = 0;
	int iOther = 0;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd"];
	iToday = [[formatter stringFromDate:today] intValue];
	iOther = [[formatter stringFromDate:other] intValue];

	return iToday == iOther;
}

//~!@#$%^&*()_-+=\/?.,<>
static inline BOOL checkPassword(int minLength, int maxLength, NSString* text)
{
	//33-47
	//58-64
	//91-96
	//123-126
	//65－90 A-Z
	//97-122  a-z
	//48-57 0-9
	
	if([text length] < minLength || [text length] > maxLength){
		return NO;
	}
	const char* ch = [text UTF8String];
	
	for(int i = 0; i < [text length]; i++){
		
		int chv = ch[i];
		
		if(chv>=33 && chv<=126)
		{
			continue;
		}
		else 
		{
			return NO;
		}

	}
	
	return YES;
}

static inline BOOL checkAccount(int minLength, int maxLength, NSString* text)
{
	//65－90 A-Z
	//97-122  a-z
	//48-57 0-9
	if([text length] < minLength || [text length] > maxLength){
		return NO;
	}
	const char* ch = [text UTF8String];
	
	for(int i = 0; i < [text length]; i++){
	
		char c = ch[i];
		if( (c >= '0' && c <= '9') || (c>='a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_')
		{
			continue;
		}
		else 
		{
			return NO;
		}

	}
	
	return YES;
}



//////////////// create form data //////////////////////
static inline NSMutableData* internalPreparePOSTData(NSDictionary*param, BOOL endmark) {
    NSMutableData *data=[NSMutableData data];
    
    NSArray *keys=[param allKeys];
    unsigned i, c=[keys count];
    for (i=0; i<c; i++) {
		NSString *k=[keys objectAtIndex:i];
		NSString *v=[param objectForKey:k];
		
		NSString *addstr = [NSString stringWithFormat:
							@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
							POSTDataSeparator, k, v];
		[data appendData:[addstr dataUsingEncoding:NSUTF8StringEncoding]];
    }
	
    if (endmark) {
		NSString *ending = [NSString stringWithFormat: @"--%@--", POSTDataSeparator];
		[data appendData:[ending dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return data;
}

////////////////////// insert image ///////////////////////////////////
static inline NSData* prepareUploadData(NSMutableDictionary *info, float quality)
{
    UIImage *image = [info objectForKey:@"photo"];
    if(image==nil){
		return internalPreparePOSTData(info, YES);
	}
    
	float q = quality;
	
	
    NSData *data = UIImageJPEGRepresentation(image, q);
	
	//NSLog(@"%d", [data bytes]);
	
    NSString *content_type = @"image/jpg";
    
    [info removeObjectForKey:@"photo"];
    [info removeObjectForKey:@"quality"];
	
	NSString *filename = [info objectForKey:@"filename"];
    
	[info removeObjectForKey:@"filename"];
	
    NSMutableData *cooked = internalPreparePOSTData(info, NO);
    
    
    NSString *filename_str = [NSString stringWithFormat:
							  @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",
							  POSTDataSeparator, filename,@"pic.jpg", content_type];
	
	
    [cooked appendData:[filename_str dataUsingEncoding:NSUTF8StringEncoding]];
	

//	NSString *string = [[NSString alloc] initWithData:cooked encoding:NSUTF8StringEncoding];
//	NSLog(@"cooked = %@", string);
//	[string release];
	
    [cooked appendData:data];    
    
    NSString *endmark = [NSString stringWithFormat: @"\r\n--%@--", POSTDataSeparator];
    [cooked appendData:[endmark dataUsingEncoding:NSUTF8StringEncoding]];
	
    return cooked;
}



///////////////
inline static UIColor* createColorByHex(NSString *hexColor)
{
    
    if (hexColor == nil) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];	
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}



typedef enum{
	PULLREFRESHPULLING,
	PULLREFRESHNORMAL,
	PULLREFRESHLOADING,	
} PullRefreshState;


