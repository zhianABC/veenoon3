//
//  HttpFileGetter.m
//  
//
//  Created by jack on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HttpFileGetter.h"
//#import "URLCache.h"


@implementation HttpFileGetter
@synthesize characterBuffer, connection;
@synthesize url_;
@synthesize delegate_;
@synthesize photo;
@synthesize fileName_;
@synthesize targetUpdate;

- (void)httpConnectStart {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
- (void)httpConnectEnd {
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	
    [UIApplication sharedApplication].idleTimerDisabled = NO;
	//bLoading_ = NO;
}

- (void) fillPhoto{
    
    if(isCancel)return;
	
	//received_ == total_
	if([characterBuffer length] >= total_){
		
		NSData* imageData = [characterBuffer copy];
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NSString* cachesDirectory = [paths objectAtIndex:0];
		NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:fileName_];
		[imageData writeToFile:fullPathToFile atomically:NO];
        
        [imageData release];
		
        if(delegate_ && [delegate_ respondsToSelector:@selector(didEndLoadingFile:success:)]){
            [delegate_ didEndLoadingFile:self success:YES];
        }
	}
	else
    {
        if(delegate_ && [delegate_ respondsToSelector:@selector(didEndLoadingFile:success:)]){
            [delegate_ didEndLoadingFile:self success:NO];
        }
    }

}

- (void) downloadImage:(NSString*)url{
	
	_subThreed = [NSThread currentThread];
	
	//self.uploadPool = [[NSAutoreleasePool alloc] init];
	self.characterBuffer = [NSMutableData data];
	done = NO;
	
	received_ = 0;
	
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	
	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	if(connection){
		self.connection = nil;
	}
	
	//self.characterBuffer = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.gloria.cc/yhoa/CD/newoa_images/TouXiangNan.jpg"]];
	connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	[self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    if (connection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
	
//	NSLog(@"%@", url);
//	self.photo = [UIImage imageWithData:characterBuffer];
//	if(photo == nil)NSLog(@"nil = %@", url);
	
	 self.connection = nil;
	
	[self performSelectorOnMainThread:@selector(fillPhoto) withObject:nil waitUntilDone:YES];
	
    // Release resources used only in this thread.
   
    //[uploadPool release];
   // self.uploadPool = nil;
	
	_subThreed = nil;
	
	bLoading_ = NO;
	
	
}
- (void) startLoading:(NSString*) url{
	
	if(url == nil){
		NSLog(@"Error: nil url");
		if(delegate_ && [delegate_ respondsToSelector:@selector(didEndLoadingFile:success:)]){
            [delegate_ didEndLoadingFile:self success:NO];
        }
		return;
	}
	
    isCancel = NO;
    
	bLoading_ = YES;
	
	[characterBuffer setLength:0];
	
	received_ = 0;
	total_ = 1;
	
	self.url_ = url;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    NSString* savedPath = [cachesDirectory stringByAppendingPathComponent:fileName_];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:savedPath error:nil];
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_request setDownloadDestinationPath:savedPath];
    [_request setDownloadProgressDelegate:self];
    [_request showAccurateProgress];
    [_request setDelegate:self];
    [_request setTimeOutSeconds:30];
    [_request setAllowResumeForFileDownloads:YES];

    [_request startAsynchronous];
    
    
    
	//[NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:url];
}

- (void) setProgress:(float)progress{
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didLoadingProgress:progress:)]){
        [delegate_ didLoadingProgress:self progress:progress];
    }
    
    //[self updateProgress];
    
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    bLoading_ = NO;
    
    [_request setDelegate:nil];
    _request = nil;
    
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didEndLoadingFile:success:)]){
        [delegate_ didEndLoadingFile:self success:YES];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
    bLoading_ = NO;
    [_request setDelegate:nil];
    _request = nil;
    
    NSLog(@"%@", [request.error description]);
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didEndLoadingFile:success:)]){
        [delegate_ didEndLoadingFile:self success:NO];
    }
}


- (void) cancel{
    
    isCancel = YES;
    delegate_ = nil;
    
    if(_request)
    {
        [_request setDelegate:nil];
        [_request cancel];
        _request = nil;
    }
    
	if(self.connection){
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self.connection cancel];
		self.connection = nil;
	}
	
	@try {
		if(_subThreed){
			[_subThreed cancel];
			_subThreed = nil;
		}
	}
	@catch (NSException * e) {
		
	}
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:fileName_];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:fullPathToFile error:nil];
}

- (void) updateProgress{
	
	if(total_){
		
		float progress = (float)received_/total_;
		//NSLog(@"%f", progress);
		
		if(delegate_ && [delegate_ respondsToSelector:@selector(didLoadingProgress:progress:)]){
			[delegate_ didLoadingProgress:self progress:progress];
		}
			
			//[NSString stringWithFormat:@"%d%%", (int)(progress*100
	}
}

#pragma mark NSURLConnection Delegate methods

/*
 Disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
	[characterBuffer setLength:0];
	
	done = YES;
	[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
	NSLog(@"%@",[error localizedDescription]);
	
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Process the downloaded chunk of data.
	
	received_ += [data length];
	
	//float per = [data length];
	
	if(received_ == total_){
		//bLoading_ = NO;
	}
	
	[characterBuffer appendData:data];
	//[self performSelectorOnMainThread:@selector(updateProgress) withObject:nil waitUntilDone:NO];
	
	if(delegate_ && [delegate_ respondsToSelector:@selector(didLoadingPerProgress:progress:)]){
		[delegate_ didLoadingPerProgress:self progress:(float)received_/(float)total_];
	}
	
	
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    // Set the condition which ends the run loop.
    done = YES; 
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
		NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
		
		total_ = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
		
		//NSLog(@"%lld", total_);
	}
	
}

- (BOOL) isLoading{
	return bLoading_;
}

- (void)dealloc{
	[fileName_ release];
	delegate_ = nil;
	[photo release];
	[url_ release];
	//connection.delegate = nil;
	[connection cancel];
	[connection release];
	[characterBuffer release];
	//[uploadPool release];
	[super dealloc];
}


@end
