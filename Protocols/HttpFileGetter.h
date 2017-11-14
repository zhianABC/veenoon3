//
//  HttpFileGetter.h
//  
//
//  Created by jack on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@protocol HttpFileGetterDelegate

@optional
- (void) didEndLoadingFile:(id)object success:(BOOL)success;
- (void) didLoadingProgress:(id)object progress:(float)progress;
- (void) didLoadingPerProgress:(id)object progress:(float)progress;

@end

@interface HttpFileGetter : NSObject {
	NSURLConnection    *connection;
	NSMutableData      *characterBuffer;
	BOOL               done;
	
	NSString		  *url_;
	NSThread		  *_subThreed;
	
	id				delegate_;
	BOOL			bLoading_;
	UIImage			*photo;
	
	long long				total_;
	long long				received_;
	NSString		*fileName_;
	
	id  targetUpdate;
    
    BOOL isCancel;
    
    ASIHTTPRequest *_request;
	
}
@property (nonatomic, retain) NSURLConnection		*connection;
@property (nonatomic, retain) NSMutableData			*characterBuffer;
//@property (nonatomic, assign) NSAutoreleasePool		*uploadPool;
@property (nonatomic, retain) NSString				*url_;
@property (nonatomic, retain) UIImage				*photo;
@property (nonatomic, assign) id <HttpFileGetterDelegate> delegate_;
@property (nonatomic, retain) NSString				*fileName_;
@property (nonatomic, assign) id targetUpdate;


/*****************************************
 ** Start to loading thumb nail image
 *****************************************/
- (void) startLoading:(NSString*) url;

/*****************************************
 ** Cancel loading
 *****************************************/
- (void) cancel;

- (BOOL) isLoading;

@end
