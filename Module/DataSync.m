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

#import "DriverSync.h"
#import "Scenario.h"


@interface DataSync () <DriverSyncDelegate>
{
    WebClient *_syncClient;
 
    WebClient *_client;
    WebClient *_client1;
    
    WebClient *_eventClient;
    
    WebClient *_http;
    
    int _nextIdx;
}
@property (nonatomic, strong) WSEvent *_event;
@property (nonatomic, strong) NSMutableArray *_exhibitors;

@property (nonatomic, strong) NSMutableArray *_uploadQueue;
@property (nonatomic, strong) NSMutableArray *_syncQueue;

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

@synthesize _uploadQueue;
@synthesize _syncQueue;

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
    
}



- (void) logoutCurrentRegulus{
    
    
    if(_currentReglusLogged)
    {
        
        NSString *regulus_gateway_id = [_currentReglusLogged objectForKey:@"gw_id"];
        NSString *regulus_user_id = [_currentReglusLogged objectForKey:@"user_id"];
        
        if(regulus_user_id && regulus_gateway_id)
        {
            [[RegulusSDK sharedRegulusSDK] Logout:nil];
            
            [DataSync sharedDataSync]._currentReglusLogged = nil;
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
        
        [self newVeenoonArea];
    }
    else
    {
        NSLog(@"Result: Area Exist: VEENOON_AREA_NAME");
    
        [self updateCurrentRoomData];
        
    }
#endif
}

- (void) newVeenoonArea{
    
    IMP_BLOCK_SELF(DataSync);
    
    [[RegulusSDK sharedRegulusSDK] CreateArea:VEENOON_AREA_NAME completion:^(BOOL result, RgsAreaObj *area, NSError *error) {
        if (result) {
            block_self._currentArea = area;
            
            [block_self updateCurrentRoomData];
        }
        else
            [KVNProgress showErrorWithStatus:[error description]];
    }];
}

- (void) updateCurrentRoomData{
    
    MeetingRoom *mroom = [DataCenter defaultDataCenter]._currentRoom;
    if(mroom)
    {
        mroom.area_id = (int)_currentArea.m_id;
        
#ifdef REALTIME_NETWORK_MODEL
        [mroom syncAreaToServer];
#endif
        [[DataBase sharedDatabaseInstance] updateMeetingRoomAreaId:mroom.server_room_id
                                                            areaId:mroom.area_id];
    }
}

- (NSArray*) getCurrentDrivers {
    return self._currentAreaDrivers;
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
    
    id dr = [_mapDrivers objectForKey:uuid];
    
    if(dr == nil)
    {
        dr = [[DataCenter defaultDataCenter] irDriverWithKey:uuid];
    }
    
    return dr;
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

- (void) syncDataFromServerToLocalDB{
    
    [[DataCenter defaultDataCenter] syncDriversWithServer];

    self._syncQueue = [NSMutableArray array];
    
    _nextIdx = 0;
    
    DriverSync *sync = [[DriverSync alloc] initWithDict:@{@"type":@"1"}];
    sync.delegate = self;
    [_syncQueue addObject:sync];
    
    
    [KVNProgress show];
    
    [sync syncData];
}

- (void) syncDoneAndNext{
    
    _nextIdx++;
    
    if(_nextIdx <= 1)
    {
        NSArray *roomList = [[DataBase sharedDatabaseInstance] getMeetingRooms];
        for(MeetingRoom *room in roomList)
        {
            if(room.regulus_id)
            {
                DriverSync *sync = [[DriverSync alloc] initWithDict:@{@"type":@"2",
                                                                      @"regulus_id":room.regulus_id
                                                                      }];
                sync.delegate = self;
                [_syncQueue addObject:sync];
            }
        }
    }

    if(_nextIdx < [_syncQueue count])
    {
        DriverSync *sync = [_syncQueue objectAtIndex:_nextIdx];
        [sync syncData];
    }
    else
    {
        [KVNProgress dismiss];
    }

   
}


@end
