//
//  iHttpAdmin.m
//  
//
//  Created by Jack on 3/12/09.
//  Copyright 2009 Jack. All rights reserved.
//

#import "iHttpAdmin.h"

#import "Configure.h"

#define  IPHOTO_TIMEOUT		60

#define COUNT_MESSAGE_ONE_PAGE			@"15"
#define COUNT_COMMENTS_ONE_PAGE			@"20"

#define SPECIAL_CHARACTER @"!*'();:@&=+$,/?%#[]"

@interface iHttpAdmin () <NSURLSessionDelegate>

@end


@implementation iHttpAdmin

@synthesize errorCode_;
@synthesize error_;
@synthesize characterBuffer;
@synthesize delegate_;
@synthesize _sesstiontask;


+ (NSString*) escapeURIComponent:(NSString*)src {
    
    if (src == nil)
        return nil;
    
    
    NSString *encodedString = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)src,
                                            NULL,
                                            (CFStringRef)SPECIAL_CHARACTER,
                                            kCFStringEncodingUTF8 );

    
    return encodedString;
}
- (id)init {
	if((self = [super init]))
	{
		delegate_ = nil;
		//archiveParser_ = [[ArchiveParser alloc] init];
		curPage = 1;
		curCommentPage_ = 1;
		curPublicPage = 1;
		curMyCommentPage = 1;
		//[self loadInformation];
	}
	return self;
}
- (void)dealloc {
	
	[_sesstiontask cancel];
	
}

- (void)httpConnectStart {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)httpConnectEnd {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)sendUrlRequest:(NSString*)url param:(NSDictionary*)param{
	self.characterBuffer = [NSMutableData data];
	done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	//
	
	NSMutableURLRequest *theRequest = nil;
	
	NSString *paramData = @"";
	for(NSString *key in [param allKeys]){
		if([paramData isEqualToString:@""]){
			paramData = [NSString stringWithFormat:@"%@=%@",key, [iHttpAdmin escapeURIComponent:[param valueForKey:key]]];
		}
		else {
			paramData = [NSString stringWithFormat:@"%@&%@=%@",paramData, key, [iHttpAdmin escapeURIComponent:[param valueForKey:key]]];
		}
	}
	//NSLog(@"request url:%@", url);
	//NSLog(@"request param:%@", paramData);
	
    if([paramData length])
        url = [NSString stringWithFormat:@"%@?%@",url,paramData];
	
	
	theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
										 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
									 timeoutInterval:IPHOTO_TIMEOUT];
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setTimeoutInterval:IPHOTO_TIMEOUT];
    [theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
	
	[characterBuffer setLength:0];
	
    received_ = 0;
	total_ = 1;
    
	self.error_ = nil;
    
    
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
    
    
}

- (void)sendUrlRequestWithMethod:(NSString*)url param:(NSDictionary*)param method:(NSString*)method{
    
    self.characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //
    
    NSMutableURLRequest *theRequest = nil;
    
    NSString *paramData = @"";
    for(NSString *key in [param allKeys]){
        if([paramData isEqualToString:@""]){
            paramData = [NSString stringWithFormat:@"%@=%@",key, [iHttpAdmin escapeURIComponent:[param valueForKey:key]]];
        }
        else {
            paramData = [NSString stringWithFormat:@"%@&%@=%@",paramData, key, [iHttpAdmin escapeURIComponent:[param valueForKey:key]]];
        }
    }
    
    if([paramData length])
        url = [NSString stringWithFormat:@"%@?%@",url,paramData];
    
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:IPHOTO_TIMEOUT];
    [theRequest setHTTPMethod:method];
    [theRequest setTimeoutInterval:IPHOTO_TIMEOUT];
    [theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    

    [characterBuffer setLength:0];
    
    received_ = 0;
    total_ = 1;
    
    self.error_ = nil;
    
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
}

- (void) postJSONData:(NSString*)url body:(NSData*)body{
    
    //self.uploadPool = [[NSAutoreleasePool alloc] init];
    self.characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //
    
    NSMutableURLRequest *theRequest = nil;
    
    
    theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:IPHOTO_TIMEOUT];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:body];
    [theRequest setTimeoutInterval:IPHOTO_TIMEOUT];
    //[theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [characterBuffer setLength:0];
    
    received_ = 0;
    total_ = 1;
    
    self.error_ = nil;
    
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
    
}



- (void) finishPostRequest{
	
	[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
	
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
	NSString *stringData = [[NSString alloc] initWithData:characterBuffer encoding:NSUTF8StringEncoding];
    if(stringData == nil)
    {
        stringData = [[NSString alloc] initWithData:characterBuffer encoding:gbkEncoding];
    }
    
  
	if(delegate_ && [delegate_ respondsToSelector:@selector(didReceiveStringData:)]){
		[delegate_ didReceiveStringData:stringData];
	}
	[characterBuffer setLength:0];
	
	
}

- (void) finishPostRequestWithError{
	
	[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];

  
	received_ = 0;
	total_ = 1;
    
	[characterBuffer setLength:0];
	
	
}

- (void)postUrlRequest:(NSString*)url param:(NSDictionary*)param{
	//self.uploadPool = [[NSAutoreleasePool alloc] init];
	self.characterBuffer = [NSMutableData data];
	done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	//
	
	NSMutableURLRequest *theRequest = nil;
	
	NSString *paramData = @"";
	for(NSString *key in [param allKeys]){
        
        id val = [param valueForKey:key];
        
        if([val isKindOfClass:[NSNumber class]])
        {
            val = [NSString stringWithFormat:@"%d", [val intValue]];
        }
        
        if([paramData isEqualToString:@""]){
            paramData = [NSString stringWithFormat:@"%@=%@",key, [iHttpAdmin escapeURIComponent:val]];
        }
        else {
            paramData = [NSString stringWithFormat:@"%@&%@=%@",paramData, key, [iHttpAdmin escapeURIComponent:val]];
        }
	}
//	NSLog(@"request url:%@", url);
//	NSLog(@"request param:%@", paramData);
	
	NSData *elementData = [paramData dataUsingEncoding:NSUTF8StringEncoding];
	
	theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
										 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
									 timeoutInterval:IPHOTO_TIMEOUT];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody:elementData];
	[theRequest setTimeoutInterval:IPHOTO_TIMEOUT];
    [theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    
	
	[characterBuffer setLength:0];
	
    received_ = 0;
	total_ = 1;
    
	self.error_ = nil;
    
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
    
}


- (void) postPhotoWithUrlRequest:(NSString *)url param:(NSDictionary *)param{
    self.characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *baseUrl = url;
    
    NSMutableDictionary *mparam = [NSMutableDictionary dictionaryWithDictionary:param];
    
    
    NSString *quality = [param valueForKey:@"quality"];
    if(quality == nil){
        quality = @"1.0";
    }
    
    
    NSData *reqData   = prepareUploadData(mparam, [quality floatValue]);
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:IPHOTO_TIMEOUT];
    
    [theRequest setHTTPMethod:@"POST"];
    //[theRequest setAllHTTPHeaderFields:header];
    [theRequest setHTTPBody:reqData];
    [theRequest setTimeoutInterval:20];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",POSTDataSeparator];
    [theRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    
    
    [self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    
    received_ = 0;
    total_ = 1;
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
    
}



- (void) BCR_postPhotoWithUrlRequest:(NSString *)url param:(NSDictionary *)param image:(UIImage*)image{
    
    
    self.characterBuffer = [NSMutableData data];
    done = NO;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    
    float q = 0.3;
    
    NSData *data = UIImageJPEGRepresentation(image, q);
    
    NSString *content_type = @"image/jpg";
    
    NSMutableData *cooked = [NSMutableData data];//internalPreparePOSTData(param, NO);
    
    NSString *filename_str = [NSString stringWithFormat:
                              @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",
                              POSTDataSeparator, @"upfile",@"upfile.jpg", content_type];
    
    
    [cooked appendData:[filename_str dataUsingEncoding:NSUTF8StringEncoding]];
    
    [cooked appendData:data];
    
    NSString *endmark = [NSString stringWithFormat: @"\r\n--%@--", POSTDataSeparator];
    [cooked appendData:[endmark dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *reqData   = cooked;
    
    
    NSMutableDictionary *mParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [mParam setObject:[NSString stringWithFormat:@"%d", (int)[reqData length]] forKey:@"size"];
    
    
    NSString *paramData = @"";
    for(NSString *key in [mParam allKeys]){
        if([paramData isEqualToString:@""]){
            paramData = [NSString stringWithFormat:@"%@=%@",key, [iHttpAdmin escapeURIComponent:[mParam valueForKey:key]]];
        }
        else {
            paramData = [NSString stringWithFormat:@"%@&%@=%@",paramData, key, [iHttpAdmin escapeURIComponent:[mParam valueForKey:key]]];
        }
    }
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@?%@",url,paramData];
    
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]
                                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                          timeoutInterval:IPHOTO_TIMEOUT];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:reqData];
    [theRequest setTimeoutInterval:20];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",POSTDataSeparator];
    [theRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //[theRequest setValue:@"IPHONE" forHTTPHeaderField:@"BrowserType"];
    
    
    // 创建带有代理方法的自定义 session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 创建任务
    self._sesstiontask = [session dataTaskWithRequest:theRequest];
    
    // 启动任务
    [_sesstiontask resume];
    
}


#pragma mark ----NSURLSession

// 1. 接受到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    //NSLog(@"任务完成");
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        NSInteger responseStatusCode = [httpResponse statusCode];
        if(responseStatusCode == 401)
        {
            //Need relogin
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Re_Login" object:nil];
        }
        
        total_ = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        
        //NSLog(@"%lld", total_);
    }
    
    // 必须设置对响应进行允许处理才会执行后面两个操作。
    completionHandler(NSURLSessionResponseAllow);
}

// 2. 接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    //NSLog(@"%s",__func__);
    
    received_ += [data length];
    
    [characterBuffer appendData:data];
    
    //NSLog(@"%lld-%lld", received_, total_);
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didLoadingPerProgress:progress:)]){
        [delegate_ didLoadingPerProgress:self progress:(float)received_/(float)total_];
    }
    
}

// 3. 请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
    //NSLog(@"SessionTask %s",__func__);
    
    if(!error)
    {
        [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
        // Set the condition which ends the run loop.
        done = YES;
        
        if(delegate_ && [delegate_ respondsToSelector:@selector(sendMessageFinish)]){
            [delegate_ sendMessageFinish];
        }
        
        
        [self finishPostRequest];
    }
    else
    {
        done = YES;
        [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
        //NSLog(@"%@",[error localizedDescription]);
        [characterBuffer setLength:0];
        
        NSString *nsError = @"无法连接网络，请检查您的网络。";
        self.error_ = nsError;
        
        
        if(delegate_ && [delegate_ respondsToSelector:@selector(sendMessage:didFailWithError:)]){
            [delegate_ sendMessage:self didFailWithError:nsError];
        }
        
        [self finishPostRequestWithError];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(sendMessage:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)]){
        [delegate_ sendMessage:self didSendBodyData:bytesSent totalBytesWritten:totalBytesSent totalBytesExpectedToWrite:totalBytesExpectedToSend];
    }
}






- (NSString*) errorDiscription{
	return self.error_;
}


- (void) cancel{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if(self._sesstiontask){
		[self._sesstiontask cancel];
		self._sesstiontask = nil;
	}
}

@end 
