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

//Code, - code:text, uploaded:int, time:int, data:text (json data)

- (int) insertCode:(NSString*)code;

- (void) updateCode:(NSString*)code withData:(NSDictionary*)data status:(int)status;

- (void) updateCodeStauts:(NSString*)code status:(int)status;

- (NSMutableArray*) getSavedCode;
- (int) countTotal;
- (int) countOffline;

- (int) deleteCode:(NSString*)code;

- (NSDictionary *)chkAdmission:(NSString*)code;

- (NSMutableArray *)searchByKeywords:(NSString*)keywords;



@end
