//
//  DataSync.h
//  Hint
//
//  Created by jack on 1/16/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RgsAreaObj;
@class RgsDriverInfo;

@interface DataSync : NSObject
{
    
}
@property (nonatomic, strong) NSMutableArray *_namecards;
@property (nonatomic, strong) NSMutableDictionary *_exhibitorsMap;
@property (nonatomic, strong) NSMutableDictionary *_eventMap;

@property (nonatomic, strong) NSDictionary *_currentReglusLogged;
@property (nonatomic, strong) NSMutableArray *_plugTypes;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) RgsAreaObj* _currentArea;
@property (nonatomic, strong) NSMutableArray* _currentAreaDrivers;



+ (DataSync*)sharedDataSync;


- (void) syncCurrentArea;

- (void) loadingLocalDrivers;
- (void) syncAreaHasDrivers;
- (void) syncRegulusDrivers;
- (void) addDriver:(id)driverInfo key:(NSString*)key;

- (void) addCurrentSelectDriverToCurrentArea:(NSString*)mapkey;
- (RgsDriverInfo *) driverInfoByUUID:(NSString*)uuid;

- (void) reloginRegulus;
- (void) logoutCurrentRegulus;

@end
