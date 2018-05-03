//
//  DataSync.m
//  Hint
//
//  Created by jack on 1/16/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "DataSync.h"
#import "WebClient.h"
#import "SBJson4.h"
#import "UserDefaultsKV.h"
#import "NSDate-Helper.h"
#import "WSEvent.h"

@interface DataSync ()
{
    WebClient *_syncClient;
 
    WebClient *_client;
    WebClient *_client1;
    
    WebClient *_eventClient;
    
    WebClient *_http;
}
@property (nonatomic, strong) WSEvent *_event;
@property (nonatomic, strong) NSMutableArray *_exhibitors;

@end


@implementation DataSync
@synthesize _namecards;
@synthesize _event;
@synthesize _exhibitors;
@synthesize _exhibitorsMap;

@synthesize _eventMap;

@synthesize _currentReglusLogged;
@synthesize _drivers;
@synthesize _mapDrivers;

static DataSync* dSyncInstance = nil;

+ (DataSync*)sharedDataSync{
    
    if(dSyncInstance == nil){
        dSyncInstance = [[DataSync alloc] init];
    }
    
    return dSyncInstance;
}

- (id) init
{
    
    if(self = [super init])
    {
        _namecards = [[NSMutableArray alloc] init];
        
        NSDictionary *eventJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_event_json"];
        if(eventJson)
        {
            self._event = [[WSEvent alloc] initWithDictionary:eventJson];
        }
        
    }
    
    return self;
    
}

- (void) loadingLocalDrivers{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"ecplus" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:plistPath];

    self._drivers = [NSMutableArray array];
    for(NSDictionary *dic in arr)
    {
        [_drivers addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
    }
    
}

- (id) currentEvent{
    
    return _event;
}

- (void) syncCurrentEvent{
    
    User *u = [UserDefaultsKV getUser];
    
    NSString *token = nil;
    if(u)
    {
        token = u._authtoken;
    }
    
    
    if(_eventClient == nil)
        _eventClient = [[WebClient alloc] initWithDelegate:self];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%d", 0], @"start",
                                  @"1", @"num",
                                  nil];
    
    if(token)
    {
        [param setObject:token forKey:@"token"];
    }
    
    //[param setObject:@"1" forKey:@"NEW_SYS"];
    
    _eventClient._method = NEW_API_EVENT_LIST;
    _eventClient._httpMethod = @"GET";
    _eventClient._requestParam = param;
    
    IMP_BLOCK_SELF(DataSync);
    
    [_eventClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        // NSLog(@"%@", response);
        

        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                
                NSString *result = [v objectForKey:@"code"];
                
                if([result intValue] == 0)
                {
                    NSArray *list = [v objectForKey:@"list"];
                    [block_self refreshData:list];
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

-(void) refreshData:(NSArray*)data{
    
    for(NSDictionary *dic in data)
    {
        WSEvent *event = [[WSEvent alloc] initWithDictionary:dic];
        self._event = event;
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"current_event_json"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Refresh_Event_Info"
                                                            object:nil];
        
        break;
        
    }
   
}

@end
