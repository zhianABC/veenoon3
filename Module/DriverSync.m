//
//  DriverSync.m
//  veenoon
//
//  Created by chen jack on 2018/7/29.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DriverSync.h"
#import "WebClient.h"
#import "UserDefaultsKV.h"
#import "SBJson4.h"
#import "MeetingRoom.h"
#import "Utilities.h"
#import "Scenario.h"
#import "DataCenter.h"
#import "DataBase.h"

@interface DriverSync ()
{
    WebClient *_client;
    
    BOOL success;
}
@property (nonatomic, strong) id mdata;

@end

@implementation DriverSync
@synthesize mdata;
@synthesize delegate;


- (id) initWithDict:(id)data{
    
    if(self = [super init])
    {
        self.mdata = data;
        
        success = NO;
    }

    return self;
}

- (void) uploadData{
    
    if([mdata isKindOfClass:[NSDictionary class]])
    {
        if([mdata objectForKey:@"ptype"])
        {
            [self uploadCustomerRedDriver];
        }
        else
        {
            [self uploadSchedule];
        }
    }
    else if([mdata isKindOfClass:[MeetingRoom class]])
    {
        [self uploadMeetingRoom];
    }
    else if([mdata isKindOfClass:[Scenario class]])
    {
        [self uploadScenario];
    }
}

- (void) uploadCustomerRedDriver{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/adduserdevice";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:[mdata objectForKey:@"type"] forKey:@"type"];
    [param setObject:[mdata objectForKey:@"name"] forKey:@"name"];
    [param setObject:[mdata objectForKey:@"driver"] forKey:@"driver"];
    [param setObject:[mdata objectForKey:@"brand"] forKey:@"brand"];
    [param setObject:[mdata objectForKey:@"icon"] forKey:@"icon"];
    [param setObject:[mdata objectForKey:@"icon_s"] forKey:@"iconS"];
    [param setObject:[mdata objectForKey:@"driver_class"] forKey:@"driverClass"];
    [param setObject:[mdata objectForKey:@"ptype"] forKey:@"pType"];
    
    _client._requestParam = param;
    
    IMP_BLOCK_SELF(DriverSync);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    success = YES;
                }
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        [block_self nextDone];
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        [block_self nextDone];
    }];
    
}


- (void) uploadMeetingRoom{
    
    success = NO;
    
    MeetingRoom *room = mdata;
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/addroom";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:room.regulus_user_id forKey:@"regulusUserID"];
    [param setObject:room.regulus_id forKey:@"regulusID"];
    [param setObject:room.room_name forKey:@"roomName"];
    [param setObject:@"111111" forKey:@"regulusPassword"];
    
    IMP_BLOCK_SELF(DriverSync);
    
    UIImage *img = nil;
    NSRange range = [room.room_image rangeOfString:@"http"];
    if(range.location == NSNotFound)
    {
        NSString *path = [Utilities documentsPath:room.room_image];
        img = [UIImage imageWithContentsOfFile:path];
    }
    
    if(img)
    {
        [param setObject:@"file" forKey:@"filename"];
        [param setObject:img forKey:@"photo"];
        
        [_client requestWithSusessBlockWithImage:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            
            SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                
                
                if([v isKindOfClass:[NSDictionary class]])
                {
                    int code = [[v objectForKey:@"code"] intValue];
                    
                    if(code == 200)
                    {
                        success = YES;
                    }
                }
                
                
            };
            
            SBJson4ErrorBlock eh = ^(NSError* err) {
                
                
                
                NSLog(@"OOPS: %@", err);
            };
            
            id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                   errorHandler:eh];
            
            id data = [response dataUsingEncoding:NSUTF8StringEncoding];
            [parser parse:data];
            
            [block_self nextDone];
            
        } FailBlock:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            NSLog(@"%@", response);
            
            [block_self nextDone];
        }];
    }
    else
    {
        [_client requestWithSusessBlock:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            
            SBJson4ValueBlock block = ^(id v, BOOL *stop) {
                
                
                if([v isKindOfClass:[NSDictionary class]])
                {
                    int code = [[v objectForKey:@"code"] intValue];
                    
                    if(code == 200)
                    {
                        success = YES;
                    }
                }
                
                
            };
            
            SBJson4ErrorBlock eh = ^(NSError* err) {
                
                
                
                NSLog(@"OOPS: %@", err);
            };
            
            id parser = [SBJson4Parser multiRootParserWithBlock:block
                                                   errorHandler:eh];
            
            id data = [response dataUsingEncoding:NSUTF8StringEncoding];
            [parser parse:data];
            
            [block_self nextDone];
            
        } FailBlock:^(id lParam, id rParam) {
            
            NSString *response = lParam;
            NSLog(@"%@", response);
            
            [block_self nextDone];
            
        }];
    }
}

- (void) uploadScenario{
    
    success = NO;
    
    Scenario *scen = mdata;
    NSMutableDictionary *sdata = [scen senarioData];
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/addscenario";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:[sdata objectForKey:@"regulus_id"]
              forKey:@"regulusID"];
    [param setObject:[sdata objectForKey:@"s_driver_id"]
              forKey:@"driverID"];
    
    NSString *name = [sdata objectForKey:@"name"];
    NSString *en_name = [sdata objectForKey:@"en_name"];
    
    if(name)
        [param setObject:name forKey:@"scenarioCName"];
    if(en_name)
        [param setObject:en_name forKey:@"scenarioEName"];
    
    NSString *smallIcon = [sdata objectForKey:@"small_icon"];
    NSString *userIcon = [sdata objectForKey:@"icon_user"];
    
    if(smallIcon)
        [param setObject:smallIcon forKey:@"scenarioPic"];
    if(userIcon)
        [param setObject:userIcon forKey:@"userPic"];
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sdata
                                                       options:NSJSONWritingPrettyPrinted
                                                         error: &error];
    
    NSString *jsonresult = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if(jsonresult == nil)
        jsonresult  = @"";
    
    [param setObject:jsonresult forKey:@"scenarioContent"];
    
    IMP_BLOCK_SELF(DriverSync);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    success = YES;
                }
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        [block_self nextDone];
        
    } FailBlock:^(id lParam, id rParam) {
        
        [block_self nextDone];
    }];
}

- (void) uploadSchedule{
    
    success = NO;
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/addautoset";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:[mdata objectForKey:@"m_id"] forKey:@"scenarioID"];
    [param setObject:[mdata objectForKey:@"name"] forKey:@"scenarioName"];
    [param setObject:[mdata objectForKey:@"date"] forKey:@"exceTime"];
    [param setObject:[mdata objectForKey:@"weeks"] forKey:@"workItems"];
    
    IMP_BLOCK_SELF(DriverSync);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    success = YES;
                }
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        [block_self nextDone];
        
    } FailBlock:^(id lParam, id rParam) {
        
        [block_self nextDone];
    }];
}

- (void) nextDone{
    
    if(delegate && [delegate respondsToSelector:@selector(uploadDoneAndNext)])
    {
        [delegate uploadDoneAndNext];
    }
}

- (void) syncDone{
    
    if(delegate && [delegate respondsToSelector:@selector(syncDoneAndNext)])
    {
        [delegate syncDoneAndNext];
    }
}

- (void) syncData{
    
    int type = [[mdata objectForKey:@"type"] intValue];
    
    if(type == 1)
    {
        [self syncRooms];
    }
    else if(type == 2)
    {
        [self syncScenarios];
    }
}

- (void) syncRooms{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/getroomlist";
    _client._httpMethod = @"GET";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    IMP_BLOCK_SELF(DriverSync);
    
  
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    if([v objectForKey:@"data"])
                    {
                        [block_self saveRoomList:[v objectForKey:@"data"]];
                    }
                    else
                    {
                        [block_self syncDone];
                    }
                }
                else
                {
                    [block_self syncDone];
                }
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
        
        [block_self syncDone];
    }];
}

- (void) saveRoomList:(NSArray*)list{
    
    for(NSDictionary *rd in list)
    {
        MeetingRoom *room = [[MeetingRoom alloc] initWithDictionary:rd];
        [[DataBase sharedDatabaseInstance] saveMeetingRoom:room];
    }
    
    [self syncDone];
}


- (void) syncScenarios{
    
    NSString *regulus_id = [mdata objectForKey:@"regulus_id"];

    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/getscenariolist";
    _client._httpMethod = @"GET";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    
    [param setObject:regulus_id forKey:@"regulusID"];
    
    IMP_BLOCK_SELF(DriverSync);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    if([v objectForKey:@"data"])
                    {
                        [block_self saveScenarioList:[v objectForKey:@"data"]];
                    }
                }
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
        [block_self syncDone];
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        [block_self syncDone];
        
    }];
}


- (void) saveScenarioList:(NSArray*)list{
    
    for(NSDictionary *rd in list)
    {
        NSString *scenario_content = [rd objectForKey:@"scenario_content"];
        NSData *data = [scenario_content dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *s = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableDictionary *scenario = [NSMutableDictionary dictionaryWithDictionary:s];
        
        NSString *regulus_id = [rd objectForKey:@"regulus_id"];
        if(regulus_id)
        {
            [scenario setObject:regulus_id forKey:@"regulus_id"];
        }
        
        NSString *scenario_c_name = [rd objectForKey:@"scenario_c_name"];
        if(scenario_c_name)
        {
            [scenario setObject:scenario_c_name forKey:@"name"];
        }
        
        NSString *scenario_e_name = [rd objectForKey:@"scenario_e_name"];
        if(scenario_e_name)
        {
            [scenario setObject:scenario_e_name forKey:@"en_name"];
        }
        
        NSString *scenario_picture = [rd objectForKey:@"scenario_picture"];
        if(scenario_picture)
        {
            [scenario setObject:scenario_picture forKey:@"small_icon"];
        }
        
        NSString *scenario_user_icon_name = [rd objectForKey:@"scenario_user_icon_name"];
        if(scenario_user_icon_name)
        {
            [scenario setObject:scenario_user_icon_name forKey:@"icon_user"];
        }
        
        [[DataBase sharedDatabaseInstance] saveScenario:scenario];
        
    }
    
}

@end
