//
//  User.m
//  hkeeping
//
//  Created by jack on 3/3/14.
//  Copyright (c) 2015 G-Wearable Inc. All rights reserved..
//

#import "User.h"
#import "NSDate-Helper.h"

@implementation User
@synthesize _userId;
///Token
@synthesize _authtoken;

///名字
@synthesize companyname;

///邮箱
@synthesize province;


@synthesize city;
@synthesize zone;

@synthesize _cellphone;


@synthesize address;
@synthesize license;
@synthesize is_engineer;

@synthesize expire_time;
@synthesize active_time;

- (id) initWithDicionary:(NSDictionary*)dic{
    
    self = [super init];
    
    self._authtoken = [dic objectForKey:@"key"];
    self._userId = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"user_id"] intValue]];
    [self updateUserInfo:dic];
    
    return self;
}

- (void) updateUserInfo:(NSDictionary*)dic{
    
    NSString *value = [dic objectForKey:@"company_name"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.companyname = value;
    
    
    value = [dic objectForKey:@"province"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.province = value;
    
    
    
    value = [dic objectForKey:@"city"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.city = value;
    
    value = [dic objectForKey:@"telephone"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self._cellphone = value;
    
    value = [dic objectForKey:@"zone"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.zone = value;
    
    value = [dic objectForKey:@"address"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.address = value;
    
    value = [dic objectForKey:@"is_engineer"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.is_engineer = [value intValue];
    
    value = [dic objectForKey:@"expire_time"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.expire_time = value;
    
    value = [dic objectForKey:@"active_time"];
    if([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    self.active_time = value;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self._userId = [aDecoder decodeObjectForKey:@"userid"];
        self._authtoken = [aDecoder decodeObjectForKey:@"token"];
        
        self.companyname = [aDecoder decodeObjectForKey:@"company_name"];
        

        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        
        self.zone = [aDecoder decodeObjectForKey:@"zone"];
        
        self._cellphone = [aDecoder decodeObjectForKey:@"cellphone"];
        
        self.license = [aDecoder decodeObjectForKey:@"license"];
        
        
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.is_engineer = [[aDecoder decodeObjectForKey:@"is_engineer"] intValue];
        
        self.active_time = [aDecoder decodeObjectForKey:@"active_time"];
        self.expire_time = [aDecoder decodeObjectForKey:@"expire_time"];
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self._userId forKey:@"userid"];
    [aCoder encodeObject:self._authtoken forKey:@"token"];
    
    
    [aCoder encodeObject:self.companyname forKey:@"company_name"];
    
    
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    
    [aCoder encodeObject:self.zone forKey:@"zone"];
    
    [aCoder encodeObject:self._cellphone forKey:@"cellphone"];
    
    
    [aCoder encodeObject:self.license forKey:@"license"];
    
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:[NSNumber numberWithInt:is_engineer] forKey:@"is_engineer"];
    
    [aCoder encodeObject:self.active_time forKey:@"active_time"];
    [aCoder encodeObject:self.expire_time forKey:@"expire_time"];
}

- (BOOL) isActive{
    
    BOOL active = NO;
    
    if([active_time length])
    {
        if([expire_time length] == 0)
        {
            active = YES;
        }
        else
        {
            NSDate *date = [NSDate dateFromString:expire_time
                                       withFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *nowDate = [NSDate date];
            
            int tm = [nowDate timeIntervalSinceDate:date];
            
            if(tm < 0)
            {
                active = YES;
            }
        }
    }
    
    return active;
}

@end
