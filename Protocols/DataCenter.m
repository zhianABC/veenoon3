//
//  DataCenter.m
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCenter.h"
#import "Scenario.h"
#import "DataBase.h"
#import "MeetingRoom.h"
#import "WebClient.h"
#import "SBJson4.h"

static DataCenter *_globalDataInstanse;

@interface DataCenter ()
{
    WebClient *_client;
}

@end


@implementation DataCenter

@synthesize _selectedDevice;
@synthesize _currentRoom;
@synthesize _scenario;
@synthesize _mapDrivers;


+ (DataCenter*)defaultDataCenter{
	
	if(_globalDataInstanse == nil){
		_globalDataInstanse = [[DataCenter alloc] init];
	}
	return _globalDataInstanse;
}

- (void) syncDriversWithServer{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/getdevicelist";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;

    
    IMP_BLOCK_SELF(DataCenter);
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
    
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    if([v objectForKey:@"data"])
                    {
                        [block_self updateDeviceList:[v objectForKey:@"data"]];
                    }
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

- (void) updateDeviceList:(NSArray*)list{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    for(NSDictionary *dic in list)
    {
        if([dic objectForKey:@"driver"])
        [_mapDrivers setObject:dic forKey:[dic objectForKey:@"driver"]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_mapDrivers forKey:@"all_drivers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void) prepareDrivers{
    
    if(_mapDrivers == nil)
    {
        self._mapDrivers = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *all = [[NSUserDefaults standardUserDefaults] objectForKey:@"all_drivers"];
    if(all)
    {
        [self._mapDrivers setDictionary:all];
    }
    else
    {
        [self syncDriversWithServer];
    }

}

- (NSArray*) driversWithType:(NSString*)type{
    
    NSMutableArray *results = [NSMutableArray array];
    
    for(NSDictionary *dr in [_mapDrivers allValues])
    {
        NSString *tpe = [dr objectForKey:@"type"];
        if([tpe isEqualToString:type])
        {
            [results addObject:dr];
        }
    }
    
    return results;
    
}

- (void) saveDriver:(NSDictionary *)driver{
    
    NSString *key = [driver objectForKey:@"driver"];
    [_mapDrivers setObject:driver forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:_mapDrivers forKey:@"all_drivers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSDictionary *)driverWithKey:(NSString *)key{
    
    
    return [_mapDrivers objectForKey:key];
    
}


- (void) cacheScenarioOnLocalDB{
    
    if(_scenario)
    {
        NSDictionary *sdata = [_scenario senarioData];
        [[DataBase sharedDatabaseInstance] saveScenario:sdata];
    }
}

- (void)dealloc{
    
  
}
@end
