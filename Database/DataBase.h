//
//  DataBase.h
//  
//
//  Created by jack on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class MeetingRoom;

@interface DataBase : NSObject {

	sqlite3  *database_;
	
}

+ (DataBase*)sharedDatabaseInstance;

-(int)open;
-(void)close;

- (NSString *)dbPath;

- (int) saveScenarioSchedule:(NSDictionary*)schedule;
- (NSMutableArray*) getScenarioSchedules;

- (int) saveMeetingRoom:(MeetingRoom*)room;
- (void) updateMeetingRoomPic:(MeetingRoom*)room;
- (void) updateMeetingRoomAreaId:(int)room_id areaId:(int)area_id;
- (NSMutableArray*) getMeetingRooms;


- (int) saveScenario:(NSDictionary*)scenario;
- (int) deleteScenario:(NSDictionary*)scenario;
- (void) deleteScenarioByRoom:(NSString*)regulus_id;
- (NSMutableArray*) getSavedScenario:(NSString*)regulus_id;

@end
