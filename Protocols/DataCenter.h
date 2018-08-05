//
//  DataCenter.h
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Scenario;
@class MeetingRoom;

@interface DataCenter : NSObject {
	   
   
}
@property (nonatomic, strong) NSMutableDictionary *_selectedDevice;
@property (nonatomic, strong) MeetingRoom *_currentRoom;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;

@property (nonatomic, strong) Scenario *_scenario;

@property (nonatomic, strong) NSDictionary *_cpZengYi;
@property (nonatomic, strong) NSDictionary *_cpNosieGate;

+ (DataCenter*)defaultDataCenter;

- (void) syncDriversWithServer;
- (void) prepareDrivers;
- (NSArray*) driversWithType:(NSString*)type;
- (NSDictionary *)driverWithKey:(NSString *)key;
- (void) saveDriver:(NSDictionary *)driver;
- (void) cacheScenarioOnLocalDB;

- (NSArray *)userDrivers;

@end
