//
//  SSUser.h
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSUser : NSObject
{
    int userId;
}

@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *cellphone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatarurl;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *ranktitle;
@property (nonatomic, strong) NSString *telphone;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *certno;

@property (nonatomic, strong) NSString *wechat;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) id ctime;

@property (nonatomic, strong) NSString * bizcardurl;

@property (nonatomic, assign) int status;

@property (nonatomic, assign) int wb_personid;

@property (nonatomic, assign) int companyid;

@property (nonatomic, strong) NSString *memo;

@property (nonatomic, strong) NSString *lastNote;

@property (nonatomic, strong) NSString *seatno;
@property (nonatomic, strong) NSString *hotel;
@property (nonatomic, strong) NSString *traffic;

@property (nonatomic, assign) int cuid;
@property (nonatomic, strong) NSString *cuname;

@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *source;

@property (nonatomic, strong) NSDictionary *_eventAdmission;

- (void) updateWithDictionary:(NSDictionary*)data;

- (void) syncUsersAdmission:(int)eventid;

@end
