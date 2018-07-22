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

#import "KVNProgress.h"
#import "RegulusSDK.h"
#import "WaitDialog.h"

#import "DataCenter.h"
#import "DataBase.h"
#import "MeetingRoom.h"


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
@synthesize _plugTypes;

@synthesize _mapDrivers;
@synthesize _currentArea;
@synthesize _currentAreaDrivers;

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

    self._plugTypes = [NSMutableArray array];
    for(NSDictionary *dic in arr)
    {
        [_plugTypes addObject:[NSMutableDictionary dictionaryWithDictionary:dic]];
    }
    
}


- (void) reloginRegulus{
    
#ifdef OPEN_REG_LIB_DEF
    
    if(_currentReglusLogged)
    {
        NSString *regulus_gateway_id = [_currentReglusLogged objectForKey:@"gw_id"];
        NSString *regulus_user_id = [_currentReglusLogged objectForKey:@"user_id"];
        
        if(regulus_user_id && regulus_gateway_id)
        {
            [[RegulusSDK sharedRegulusSDK] Login:regulus_user_id
                                           gw_id:regulus_gateway_id
                                        password:@"111111"
                                           level:1
                                      completion:^(BOOL result, NSInteger level, NSError *error) {
                                          
                                      }];
        }
    }
     
    
#endif
    
}

- (void) logoutCurrentRegulus{
    
    
    if(_currentReglusLogged)
    {
        NSString *regulus_gateway_id = [_currentReglusLogged objectForKey:@"gw_id"];
        NSString *regulus_user_id = [_currentReglusLogged objectForKey:@"user_id"];
        
        if(regulus_user_id && regulus_gateway_id)
        {
            [[RegulusSDK sharedRegulusSDK] Logout:regulus_user_id
                                            gw_id:regulus_gateway_id completion:^(BOOL result, NSError *error) {
                                                
                                            }];
            
            //[DataSync sharedDataSync]._currentReglusLogged = nil;
        }
    }
     
    
}

- (void) syncCurrentArea{
    
    NSLog(@"=========Call: syncCurrentArea");
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(DataSync);
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
            [block_self checkNeedCreateArea:RgsAreaObjs];
        }
    }];
    
#endif
    
}

- (void) checkNeedCreateArea:(NSArray*)RgsAreaObjs{
    
    NSLog(@"=========Call: checkNeedCreateArea");
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(DataSync);
    
    self._currentArea = nil;
    for(RgsAreaObj *area in RgsAreaObjs)
    {
        if([area.name isEqualToString:VEENOON_AREA_NAME])
        {
            self._currentArea = area;
            break;
        }
    }
    
    if(_currentArea == nil)
    {
        NSLog(@"=========Call: CreateArea: VEENOON_AREA_NAME");
        
        [[RegulusSDK sharedRegulusSDK] CreateArea:VEENOON_AREA_NAME completion:^(BOOL result, RgsAreaObj *area, NSError *error) {
            if (result) {
                block_self._currentArea = area;
                
                [block_self updateCurrentRoomData];
            }
            else
                [KVNProgress showErrorWithStatus:@"创建Area出错!"];
        }];
    }
    else
    {
        NSLog(@"Result: Area Exist: VEENOON_AREA_NAME");
    
        [self updateCurrentRoomData];
        
    }
#endif
}

- (void) updateCurrentRoomData{
    
    MeetingRoom *mroom = [DataCenter defaultDataCenter]._currentRoom;
    if(mroom)
    {
        mroom.area_id = (int)_currentArea.m_id;
        [mroom syncAreaToServer];
        [[DataBase sharedDatabaseInstance] updateMeetingRoomAreaId:mroom.server_room_id
                                                            areaId:mroom.area_id];
    }
}

- (void) syncAreaHasDrivers{
    
    self._currentAreaDrivers = [NSMutableArray array];
    
#ifdef OPEN_REG_LIB_DEF
    
    //IMP_BLOCK_SELF(DataSync);
    
    RgsAreaObj *areaObj = [DataSync sharedDataSync]._currentArea;
    if(areaObj)
    {
        [[RegulusSDK sharedRegulusSDK] GetDrivers:areaObj.m_id
                                       completion:^(BOOL result, NSArray *drivers, NSError *error) {
            
            if (error) {
                [KVNProgress showErrorWithStatus:[error localizedDescription]];
            }
            else{
                [_currentAreaDrivers addObjectsFromArray:drivers];
            }
        }];
    }
    
    
#endif
}

- (void) syncRegulusDrivers{
    
    if(self._mapDrivers)
        return;
    
#ifdef OPEN_REG_LIB_DEF
        
        IMP_BLOCK_SELF(DataSync);
        
        [[RegulusSDK sharedRegulusSDK] RequestDriverInfos:^(BOOL result, NSArray *driver_infos, NSError *error) {
            
            if (result) {
                [block_self mappingDrivers:driver_infos];
            }
            else{
                [KVNProgress showErrorWithStatus:[error localizedDescription]];
            }
        }];
        
#endif
 
}

- (void) mappingDrivers:(NSArray*)driver_infos{
    
#ifdef OPEN_REG_LIB_DEF
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    for(RgsDriverInfo *dr in driver_infos)
    {
        [_mapDrivers setObject:dr forKey:dr.serial];
    }
    
#endif
}

- (void) addDriver:(id)driverInfo key:(NSString*)key{
    
    [_mapDrivers setObject:driverInfo forKey:key];
}

- (RgsDriverInfo *) driverInfoByUUID:(NSString*)uuid{
    
    return [_mapDrivers objectForKey:uuid];
}

- (id) queryCurrentAreaDriverWithMID:(NSInteger)mid{
    
    RgsDriverObj *result = nil;
    
    NSMutableArray *drivers = self._currentAreaDrivers;
    for(RgsDriverObj *odr in drivers)
    {
        if(odr.m_id == mid)
        {
            result = odr;
            break;
        }
    }
    
    return result;
}

- (void) addCurrentSelectDriverToCurrentArea:(NSString*)mapkey{
    
    RgsDriverInfo *info = [_mapDrivers objectForKey:mapkey];
    if(!info)
    {
        [[WaitDialog sharedAlertDialog] setTitle:@"未找到对应设备的驱动"];
        [[WaitDialog sharedAlertDialog] animateShow];
    }
    else
    {
        NSMutableArray *drivers = self._currentAreaDrivers;
        for(RgsDriverObj *odr in drivers)
        {
            if([odr.info.serial isEqualToString:info.serial])
            {
                [[WaitDialog sharedAlertDialog] setTitle:@"已添加"];
                [[WaitDialog sharedAlertDialog] animateShow];
                
                return;
            }
        }
        if(_currentArea)
        {
            [[RegulusSDK sharedRegulusSDK] CreateDriver:_currentArea.m_id serial:info.serial completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
                if (result) {
                    
                    [_currentAreaDrivers addObject:driver];
                    
                    [[WaitDialog sharedAlertDialog] setTitle:@"已添加"];
                    [[WaitDialog sharedAlertDialog] animateShow];
                }
                else{
                    [KVNProgress showErrorWithStatus:[error localizedDescription]];
                }
            }];
        }
    }
    

}

@end
