//
//  WebClient.m
//  HomeSearch
//
//  Created by Jack chen on 12/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WebClient.h"
#import "Configure.h"
#import "SHA1.h"

@implementation WebClient

@synthesize _requestParam;
@synthesize _method;
@synthesize statues_code;
@synthesize _httpMethod;

@synthesize _failBlock;
@synthesize _successBlock;
@synthesize _progressBlock;

@synthesize _body;

- (id)initWithDelegate:(id)aDelegate {
	if((self = [super init]))
	{
		// Store reference to delegate
		//delegate = aDelegate;
		
		_httpAdmin = [[iHttpAdmin alloc] init];
		_httpAdmin.delegate_ = self;
		
		_method = nil;
		
	}
	return self;
}

- (void) releaseDelegate{
	delegate = nil;
	_httpAdmin.delegate_ = nil;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Request Managment
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)requestBodyWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock{
    
    
    self._successBlock = susessBlock;
    self._failBlock = failBlock;
    
	if(_method==nil)_method=@"";
	
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_requestParam];
    [dic removeObjectForKey:@"method"];

    
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    
    NSString *source = @"iPad自注册版本";
    if([userName length] > 0){
        source = [NSString stringWithFormat:@"%@ － iPad自注册版本", userName];
        
    }
    
    [dic setObject:source forKey:@"Source"];

    
    NSString *rootApi = WEB_API_URL;
	NSString *url = [NSString stringWithFormat:@"%@%@", rootApi, _method];
	
	NSString *baseUrl = [dic objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
		[dic removeObjectForKey:@"baseUrl"];
	}
	
    [_httpAdmin postUrlRequestWithBody:url body:_body];
    
}

- (void)requestWithSusessBlock:(RequestBlock) susessBlock FailBlock:(RequestBlock)failBlock{
    
    self._successBlock = susessBlock;
    self._failBlock = failBlock;
    
	if(_method==nil)_method=@"";
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_requestParam];
    
    if([dic objectForKey:@"out_url"])
    {
        [dic removeObjectForKey:@"out_url"];
    }
	else
    {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        
        NSString *source = @"iPad门禁";
        if([userName length] > 0){
            source = [NSString stringWithFormat:@"%@ － iPad门禁", userName];
            
        }
        
        [dic setObject:source forKey:@"Source"];
    }
    
    NSString *url = WEB_API_URL;
    
    
    if(1)
    {
        int secs = [[NSDate date] timeIntervalSince1970];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
        [dic setObject:EXPO_APP_KEY forKey:@"app_key"];
        [dic setObject:[NSString stringWithFormat:@"%d", secs] forKey:@"timestamp"];
        [dic setObject:version forKey:@"app_ver"];
        
        NSString *deviceToken = [[UIDevice currentDevice].identifierForVendor UUIDString];
        if(deviceToken == nil)
            deviceToken = @"00000000-0000-0000-0000-000000000000";
        [dic setObject:deviceToken forKey:@"app_uuid"];
        
        if(![dic objectForKey:@"i18n_lang"])
        {
            [dic setObject:@"zh-cn" forKey:@"i18n_lang"];
        }
        
        
        NSString *sign_txt = [NSString stringWithFormat:@"app_key=%@&app_secret=%@&timestamp=%d", EXPO_APP_KEY, EXPO_APP_SEC, secs];
        NSString *signature = [SHA1 SHA1Digest:sign_txt];
        
        [dic setObject:signature forKey:@"signature"];
        
        url = [NSString stringWithFormat:@"%@%@",NEW_WEB_API_URL, _method];
    }
    
    
	NSString *baseUrl = [dic objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
		[dic removeObjectForKey:@"baseUrl"];
	}
	
    if([_httpMethod isEqualToString:@"POST"])
        [_httpAdmin postUrlRequest:url param:dic];
    else
        [_httpAdmin sendUrlRequest:url param:dic];
    
}


- (void)requestWithSusessBlockWithImage:(RequestBlock)susessBlock FailBlock:(RequestBlock)failBlock{
    
    self._successBlock = susessBlock;
    self._failBlock = failBlock;
    
    if(_method==nil)_method=@"";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_requestParam];
    
    if([dic objectForKey:@"out_url"])
    {
        [dic removeObjectForKey:@"out_url"];
    }
    else
    {
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        
        NSString *source = @"iPad门禁";
        if([userName length] > 0){
            source = [NSString stringWithFormat:@"%@ － iPad门禁", userName];
            
        }
        
        [dic setObject:source forKey:@"Source"];
    }
    
    NSString *url = WEB_API_URL;
    
    
    if(1)
    {
        int secs = [[NSDate date] timeIntervalSince1970];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
        [dic setObject:EXPO_APP_KEY forKey:@"app_key"];
        [dic setObject:[NSString stringWithFormat:@"%d", secs] forKey:@"timestamp"];
        [dic setObject:version forKey:@"app_ver"];
        
        NSString *deviceToken = [[UIDevice currentDevice].identifierForVendor UUIDString];
        if(deviceToken == nil)
            deviceToken = @"00000000-0000-0000-0000-000000000000";
        [dic setObject:deviceToken forKey:@"app_uuid"];
        
        if(![dic objectForKey:@"i18n_lang"])
        {
            [dic setObject:@"zh-cn" forKey:@"i18n_lang"];
        }
        
        
        NSString *sign_txt = [NSString stringWithFormat:@"app_key=%@&app_secret=%@&timestamp=%d", EXPO_APP_KEY, EXPO_APP_SEC, secs];
        NSString *signature = [SHA1 SHA1Digest:sign_txt];
        
        [dic setObject:signature forKey:@"signature"];
        
        url = [NSString stringWithFormat:@"%@%@",NEW_WEB_API_URL, _method];
    }
    
    
    NSString *baseUrl = [dic objectForKey:@"baseUrl"];
    if(baseUrl){
        url = [NSString stringWithFormat:@"%@", baseUrl];
        [dic removeObjectForKey:@"baseUrl"];
    }
    
    
    [_httpAdmin postPhotoWithUrlRequest:url param:dic];
}



- (void)requestDealersWithInfo:(NSDictionary*)info{
	self._method = @"dealers";
	
	return;
	
	
}


- (void)postImageWithInfo:(NSDictionary*)info{
   
	if(_method==nil)_method=@"";
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
	[dic removeObjectForKey:@"method"];
	
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    
    NSString *source = @"iPad自注册版本";
    if([userName length] > 0){
        source = [NSString stringWithFormat:@"%@ － iPad自注册版本", userName];
        
    }
    
    [dic setObject:source forKey:@"Source"];

    
    NSString *rootApi = WEB_API_URL;
	NSString *url = [NSString stringWithFormat:@"%@", rootApi];
	
	NSString *baseUrl = [info objectForKey:@"baseUrl"];
	if(baseUrl){
		url = [NSString stringWithFormat:@"%@", baseUrl];
        [dic removeObjectForKey:@"baseUrl"];
	}
	[_httpAdmin postPhotoWithUrlRequest:url param:dic];
}


- (void)postImageToBCRService:(NSDictionary*)info photo:(UIImage *)photo{
    self._method = [info objectForKey:@"request"];
    
    if(_method==nil)_method=@"";
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
    [dic removeObjectForKey:@"request"];
    
    NSString *url = nil;
    NSString *baseUrl = [info objectForKey:@"baseUrl"];
    if(baseUrl){
        url = [NSString stringWithFormat:@"%@%@", baseUrl, _method];
        [dic removeObjectForKey:@"baseUrl"];
    }
    
    [_httpAdmin BCR_postPhotoWithUrlRequest:url param:dic image:photo];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark AsyncSocket Delegate Methods:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) didReceiveStringData:(NSString*)resultString{
	
    if(_successBlock)
    {
        _successBlock(resultString, self);
    }
	
}

- (void) didLoadingPerProgress:(id)object progress:(float)progress
{
    
    if(_progressBlock)
    {
        _progressBlock([NSNumber numberWithFloat:progress], self);
    }
    
    
    
}

- (void)sendMessage:(id)sender didFailWithError:(NSString*)error{
	//[self onDidReceiveError:error];
    
    if(_failBlock)
    {
        _failBlock(error, self);
    }
    
}

- (void)dealloc {
	
	delegate = nil;
	_httpAdmin.delegate_ = nil;
	
}
@end
