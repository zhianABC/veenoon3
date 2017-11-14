//
//  SSUser.m
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "SSUser.h"
#import "UserDefaultsKV.h"
#import "SBJson4.h"
#import "WebClient.h"

@interface SSUser ()
{
    WebClient *_client;
}

@end

@implementation SSUser

@synthesize userId;
@synthesize fullname;
@synthesize realname;
@synthesize cellphone;
@synthesize email;
@synthesize avatarurl;
@synthesize address;

@synthesize companyname;
@synthesize ranktitle;
@synthesize telphone;
@synthesize bizcardurl;

@synthesize wechat;

@synthesize fax;

@synthesize tags;

@synthesize ctime;

@synthesize status;

@synthesize wb_personid;

@synthesize companyid;

@synthesize memo;

@synthesize lastNote;

@synthesize seatno;
@synthesize hotel;
@synthesize traffic;

@synthesize cuid;
@synthesize cuname;

@synthesize role;
@synthesize url;

@synthesize source;

@synthesize _eventAdmission;

@synthesize certno;

- (void) updateWithDictionary:(NSDictionary*)data{
    
}

- (void) syncUsersAdmission:(int)eventid
{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/v1/admission/listing";
    _client._httpMethod = @"GET";
    
    
    User *u = [UserDefaultsKV getUser];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  u._authtoken,@"token",
                                  nil];
    
    [param setObject:[NSString stringWithFormat:@"%d", self.userId] forKey:@"uid"];
    
    if(eventid)
    {
        [param setObject:[NSString stringWithFormat:@"%d", eventid] forKey:@"eventid"];
    }
    
    _client._requestParam = param;
    
    
    IMP_BLOCK_SELF(SSUser);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
        
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 0)
                {
                    
                    [block_self processAttendee:v];
                }
                
                return;
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        
    }];
    
}

- (void) processAttendee:(NSDictionary*)v{
    
    NSArray* admissionList = [v objectForKey:@"list"];
    if([admissionList count])
    {
        NSDictionary *dic = [admissionList objectAtIndex:0];
        self._eventAdmission = dic;
        
    }
}



@end
