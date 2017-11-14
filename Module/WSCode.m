//
//  WSUser.m
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "WSCode.h"
#import "SBJson4.h"
#import "WaitDialog.h"
#import "UserDefaultsKV.h"
#import "WebClient.h"
#import "DataBase.h"

@interface WSCode ()
{
    WebClient *_checkIn;
    
   
}
@property (nonatomic, strong) NSString *_qr;
@property (nonatomic, strong) NSString *_eventId;
@end

@implementation WSCode
@synthesize _qr;
@synthesize complete;
@synthesize _eventId;

- (id) initWithDictionary:(NSDictionary*)data{
    
    if(self = [super init])
    {
        
        if([data isKindOfClass:[NSDictionary class]])
        {
            //self._rowid = [[data objectForKey:@"id"] intValue];
            self._qr = [data objectForKey:@"qr"];
            self._eventId = [data objectForKey:@"eventid"];
            //self._barcode = [data objectForKey:@"barcode"];
            //self._type = [[data objectForKey:@"type"] intValue];
        }
        
    }
    
    return self;
}

- (void) submit{

    [self checkIn:_qr];
}

- (void) checkIn:(NSString*)qr{
    
    if(qr)
    {
        if(_checkIn == nil)
        {
            _checkIn = [[WebClient alloc] initWithDelegate:self];
        }
        
        _checkIn._method = [NSString stringWithFormat:@"%@/%@",NEW_API_CHECKIN, qr];
        _checkIn._httpMethod = @"POST";
        
        User *u = [UserDefaultsKV getUser];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        if(u && u._authtoken)
        {
            [param setObject:u._authtoken forKey:@"token"];
        }
        
        if(_eventId)
            [param setObject:_eventId forKey:@"eventid"];
        else
            [param setObject:EXPO_EVENT_ID forKey:@"eventid"];
        
        
        _checkIn._requestParam = param;
        
        IMP_BLOCK_SELF(WSCode);
        [_checkIn requestWithSusessBlock:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            // NSLog(@"%@", response);
            
            SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                
                
                if([v isKindOfClass:[NSDictionary class]])
                {
                    int code = [[v objectForKey:@"code"] intValue];
                    
                    if(code == 0)
                    {
                        [block_self doneSuccess];
                        return ;
                    }
                }
                
                
                [block_self doComplete];
            };
            
            SBJson4ErrorBlock eh = ^(NSError* err) {
                
                NSLog(@"OOPS: %@", err);
                
                [block_self doComplete];
            };
            
            id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                   errorHandler:eh];
            
            id data = [response dataUsingEncoding:NSUTF8StringEncoding];
            [parser parse:data];
            
        } FailBlock:^(id lParam, id rParam) {
            
            [block_self doComplete];
        }];
    }
    
}


- (void) doComplete{
    
    if(complete)
    {
        complete(nil);
    }
}


- (void) doneSuccess{
    
    [[DataBase sharedDatabaseInstance] updateCodeStauts:_qr status:1];
    
    if(complete)
    {
        complete(nil);
    }
}


- (void) checkInEmergcode:(NSString*)emergCode{
    
    if(emergCode)
    {
        if(_checkIn == nil)
        {
            _checkIn = [[WebClient alloc] initWithDelegate:self];
        }
        
        _checkIn._method = NEW_API_CHECKIN_BAR;
        _checkIn._httpMethod = @"POST";
        
        User *u = [UserDefaultsKV getUser];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        if(u && u._authtoken)
        {
            [param setObject:u._authtoken forKey:@"token"];
        }
        
        if(_eventId)
            [param setObject:_eventId forKey:@"eventid"];
        else
            [param setObject:EXPO_EVENT_ID forKey:@"eventid"];
        
        
        [param setObject:emergCode forKey:@"code"];
        
        
        _checkIn._requestParam = param;
        
        IMP_BLOCK_SELF(WSCode);
        [_checkIn requestWithSusessBlock:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            // NSLog(@"%@", response);
            
            SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                
                
                if([v isKindOfClass:[NSDictionary class]])
                {
                    int code = [[v objectForKey:@"code"] intValue];
                    
                    if(code == 0)
                    {
                        [block_self doneSuccess];
                        return ;
                    }
                }
                
                
                [block_self doComplete];
            };
            
            SBJson4ErrorBlock eh = ^(NSError* err) {
                
                NSLog(@"OOPS: %@", err);
                
                [block_self doComplete];
            };
            
            id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                   errorHandler:eh];
            
            id data = [response dataUsingEncoding:NSUTF8StringEncoding];
            [parser parse:data];
            
        } FailBlock:^(id lParam, id rParam) {
            
            [block_self doComplete];
        }];
    }
    
}

@end
