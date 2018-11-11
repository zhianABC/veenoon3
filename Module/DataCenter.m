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
#import "UserDefaultsKV.h"
#import "RegulusSDK.h"

static DataCenter *_globalDataInstanse;

@interface DataCenter ()
{
    WebClient *_client;
}
@property (nonatomic, strong) NSMutableDictionary *_mapDriverInfos;
@property (nonatomic, strong) NSMutableDictionary *_mapIRDrInfos;
@property (nonatomic, strong) NSMutableDictionary *_sysIRDriversMap;

@end


@implementation DataCenter

@synthesize _selectedDevice;
@synthesize _currentRoom;
@synthesize _scenario;
@synthesize _mapDriverInfos;

@synthesize _cpZengYi;
@synthesize _cpNosieGate;
@synthesize _cpPEQ;
@synthesize _cpComLimter;
@synthesize _cpDelaySet;
@synthesize _cpFeedback;
@synthesize _cpElecLevel;

@synthesize _isLocalPrj;

@synthesize _isExpotingToCloudPrj;
@synthesize _mapIRDrInfos;

@synthesize _sysIRDriversMap;

+ (DataCenter*)defaultDataCenter{
	
	if(_globalDataInstanse == nil){
		_globalDataInstanse = [[DataCenter alloc] init];
	}
	return _globalDataInstanse;
}
- (NSMutableDictionary*) getAllDrivers {
    if (_mapDriverInfos) {
        return _mapDriverInfos;
    } else {
        [self syncDriversWithServer];
    }
    return _mapDriverInfos;
}

- (void) syncDriversWithServer{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/getdevicelist";
    _client._httpMethod = @"GET";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    User *u = [UserDefaultsKV getUser];
    if(u)
        [param setObject:u._userId forKey:@"userID"];
    
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
    
    self._mapDriverInfos = [NSMutableDictionary dictionary];
    self._mapIRDrInfos = [NSMutableDictionary dictionary];
    
    for(NSDictionary *device in list)
    {
        NSString *drkey = [device objectForKey:@"driver"];
        if([drkey isKindOfClass:[NSString class]] && [drkey length] > 10)
            [_mapDriverInfos setObject:device forKey:drkey];
        else
        {
            NSString *name = [device objectForKey:@"name"];
            NSString *brand = [device objectForKey:@"brand"];
            NSString *ptype = [device objectForKey:@"ptype"];
            NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];
            [_mapIRDrInfos setObject:device forKey:irname];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_mapDriverInfos forKey:@"all_drivers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:_mapIRDrInfos forKey:@"all_IR_drivers"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) prepareDrivers{
    
    if(_mapDriverInfos == nil)
    {
        self._mapDriverInfos = [NSMutableDictionary dictionary];
    }
    if(_mapIRDrInfos == nil)
    {
        self._mapIRDrInfos = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *all = [[NSUserDefaults standardUserDefaults] objectForKey:@"all_drivers"];
    if(all)
    {
        [self._mapDriverInfos setDictionary:all];
    }
    
    NSDictionary *allIR = [[NSUserDefaults standardUserDefaults] objectForKey:@"all_IR_drivers"];
    if(allIR)
    {
        [self._mapIRDrInfos setDictionary:allIR];
    }
}

- (NSArray*) driversWithType:(NSString*)type{
    
    NSMutableArray *results = [NSMutableArray array];
    
    for(NSDictionary *dr in [_mapDriverInfos allValues])
    {
        if([dr objectForKey:@"IR"])
        {
            continue;
        }
        NSString *tpe = [dr objectForKey:@"type"];
        if([tpe isEqualToString:type])
        {
            [results addObject:dr];
        }
    }
    
    for(NSDictionary *dr in [_mapIRDrInfos allValues])
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
    
    if([driver objectForKey:@"IR"])
    {
        NSString *name = [driver objectForKey:@"name"];
        NSString *brand = [driver objectForKey:@"brand"];
        NSString *ptype = [driver objectForKey:@"ptype"];
        NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];
        [_mapIRDrInfos setObject:driver forKey:irname];
        
        [[NSUserDefaults standardUserDefaults] setObject:_mapIRDrInfos forKey:@"all_IR_drivers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [_mapDriverInfos setObject:driver forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:_mapDriverInfos forKey:@"all_drivers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (NSDictionary *)driverWithKey:(NSString *)key{
    
    return [_mapDriverInfos objectForKey:key];
    
}

- (NSDictionary *)testIRDriverInfoWithName:(NSString *)nameKey{
    
    return [_mapIRDrInfos objectForKey:nameKey];
}

- (RgsDriverInfo *)irDriverWithKey:(NSString *)key{
    
    RgsDriverInfo* dr = nil;
    for (RgsDriverInfo * info in [_sysIRDriversMap allValues]) {
        
        NSString *uuids = info.serial;
        if([uuids isEqualToString:key])
        {
            dr = info;
            break;
        }
        
    }
    
    return dr;
}


- (void) cacheScenarioOnLocalDB{
    
    if(_scenario)
    {
        NSDictionary *sdata = [_scenario senarioData];
        [[DataBase sharedDatabaseInstance] saveScenario:sdata];
    }
}

- (void) syncRegulusIRDrivers
{
    
    self._sysIRDriversMap = [NSMutableDictionary dictionary];
    
    [[RegulusSDK sharedRegulusSDK] RequestProxyDriverInfos:^(BOOL result, NSArray *driver_infos, NSError *error)
     {
         if (result)
         {
             for (RgsDriverInfo * info in driver_infos) {
                 
                 if ([info.system isEqualToString:@"IR Controller"])
                 {
                     [_sysIRDriversMap setObject:info forKey:info.name];
                 }
             }
             
         }
         
     }];
    
}

- (void) saveIrDriverToCache:(RgsDriverInfo*)dInfo{
    
    [_sysIRDriversMap setObject:dInfo
                         forKey:dInfo.name];
}

- (RgsDriverInfo *) testIrDriverInfoByName:(NSString*)name{
    
    return [_sysIRDriversMap objectForKey:name];
}


- (void)dealloc{
    
  
}
@end
