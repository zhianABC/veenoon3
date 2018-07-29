//
//  User.h
//  hkeeping
//
//  Created by jack on 3/3/14.
//  Copyright (c) 2015 G-Wearable Inc. All rights reserved..
//

#import <Foundation/Foundation.h>


@interface User : NSObject

@property (nonatomic, strong) NSString* _userId;
///Token
@property (nonatomic, strong) NSString *_authtoken;

///邮箱
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zone;

@property (nonatomic, strong) NSString *_cellphone;


@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *license;

@property (nonatomic, assign) int is_engineer;

@property (nonatomic, strong) id _ctime;

- (id) initWithDicionary:(NSDictionary*)dic;

- (void) updateUserInfo:(NSDictionary*)dic;

@end
