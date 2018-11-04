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
