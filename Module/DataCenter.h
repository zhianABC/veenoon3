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
@class RgsDriverInfo;

@interface DataCenter : NSObject {
	   
   
}
@property (nonatomic, strong) NSMutableDictionary *_selectedDevice;
@property (nonatomic, strong) MeetingRoom *_currentRoom;


@property (nonatomic, strong) Scenario *_scenario;

@property (nonatomic, strong) NSDictionary *_cpZengYi;
@property (nonatomic, strong) NSDictionary *_cpNosieGate;
@property (nonatomic, strong) NSDictionary *_cpPEQ;
@property (nonatomic, strong) NSDictionary *_cpComLimter;
@property (nonatomic, strong) NSDictionary *_cpDelaySet;
@property (nonatomic, strong) NSDictionary *_cpFeedback;
@property (nonatomic, strong) NSDictionary *_cpElecLevel;

@property (nonatomic, assign) BOOL _isLocalPrj;

@property (nonatomic, assign) BOOL _isExpotingToCloudPrj;

+ (DataCenter*)defaultDataCenter;

- (void) syncDriversWithServer;
- (void) syncRegulusIRDrivers;

- (void) prepareDrivers;
- (NSArray*) driversWithType:(NSString*)type;

//uuid
- (NSDictionary *)driverWithKey:(NSString *)key;
- (NSDictionary *)testIRDriverInfoWithName:(NSString *)nameKey;
//uuid
- (RgsDriverInfo *)irDriverWithKey:(NSString *)key;
- (void) saveDriver:(NSDictionary *)driver;
- (void) cacheScenarioOnLocalDB;

- (NSMutableDictionary*) getAllDrivers;

- (RgsDriverInfo *) testIrDriverInfoByName:(NSString*)name;
- (void) saveIrDriverToCache:(RgsDriverInfo*)dInfo;


@end
