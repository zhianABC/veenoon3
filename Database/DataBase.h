//
//  DataBase.h
//  
//
//  Created by jack on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DataBase : NSObject {

	sqlite3  *database_;
	
}

+ (DataBase*)sharedDatabaseInstance;

-(int)open;
-(void)close;

- (NSString *)dbPath;


- (int) saveScenario:(NSDictionary*)scenario;
- (int) deleteScenario:(NSDictionary*)scenario;
- (NSMutableArray*) getSavedScenario:(int)room_id;

@end
