//
//  DataBase.m
//  
//
//  Created by jack on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
#import "SBJson4.h"
#import "MeetingRoom.h"

@interface DataBase ()
{
    
}
@property (nonatomic, strong) NSString *databasePath_;

@end

@implementation DataBase
@synthesize databasePath_;

static DataBase* sharedInstance = nil;

+ (DataBase*)sharedDatabaseInstance{
    
    if(sharedInstance == nil){
        sharedInstance = [[DataBase alloc] init];
    }
    
    return sharedInstance;
}

- (void) prepareDatabase{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"veenoon_db.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL find = [fileManager fileExistsAtPath:path];
    if(find)
    {
        return;
        
        //[fileManager removeItemAtPath:path error:nil];
    }
    
    NSError *error;
    NSString *pathToDefaultPlist = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"veenoon_db.sqlite"];
    [fileManager copyItemAtPath:pathToDefaultPlist toPath:path error:&error];
    
    
}

- (NSString *)dbPath{
    
    return databasePath_;
}

- (int) open
{
	if (database_) {
		return 1;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"veenoon_db.sqlite"];

	
	self.databasePath_ = dbPath;
	if(sqlite3_open([dbPath UTF8String], &database_)== SQLITE_OK)
	{
        [self checkMeetingRoomCachedTable];
        [self checkCachedTable];
        
		return 1;
	}
	else {
		sqlite3_close(database_);
		NSLog(@"Open DataBase Failed");
		return -1;
	}
		
}

- (id)init{
    self = [super init];
    if(self){
        
        [self prepareDatabase];
        
        [self open];
        
    }
    return self;
}


-(void) close
{
	if (database_) {
		sqlite3_close(database_);
	}
	
}

- (void)dealloc{
    
}


#pragma mark ----Cached Meeting-------
- (void) checkMeetingRoomCachedTable{
    
    NSString *s = @"SELECT * FROM sqlite_master WHERE type='table' AND name='tblMeetingRoomCachedTable'";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblMeetingRoomCachedTable");
        return;
    }
    
    BOOL have = NO;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        have = YES;
    }
    sqlite3_finalize(statement);
    
    if(!have)
    {
        s = @"CREATE TABLE tblMeetingRoomCachedTable(id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL  UNIQUE, regulus_id TEXT, regulus_password TEXT, regulus_user_id TEXT, room_name TEXT, room_image TEXT,  room_id INTEGER, user_id INTEGER, area_id INTEGER)";
        
        const char * sql = [s UTF8String];
        sqlite3_stmt *delete_statement = nil;
        
        if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSLog(@"Not Prepared DataBase! -- tblMeetingRoomCachedTable");
        }
        
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
    }
}

- (int) saveMeetingRoom:(MeetingRoom*)room{
    
    @synchronized (self) {
        
        NSString *regulus_id = room.regulus_id;
        if(regulus_id == nil)
            return -1;
        int b = [self isMeetingRoomExist:regulus_id];
        if(b)
        {
            [self updateMeetingRoom:room];
            return b;
        }
        
        const char *sqlStatement = "insert into tblMeetingRoomCachedTable (regulus_id, regulus_password,regulus_user_id, room_name, room_image, room_id, user_id, area_id) VALUES (?,?,?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblCachedScenario");
            return -1;
        }
        
        NSString *password = room.regulus_password;
        if(password == nil)
            password = @"";
        
        NSString *regulus_user_id = room.regulus_user_id;
        if(regulus_user_id == nil)
            regulus_user_id = @"";
        
        NSString *name = room.room_name;
        if(name == nil)
            name = @"";
        NSString *small_icon = room.room_image;
        if(small_icon == nil)
            small_icon = @"";
        
        int room_id = room.server_room_id;
        int user_id = room.user_id;
        
        int area_id = room.area_id;
        
        sqlite3_bind_text(statement, 1, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [regulus_user_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [small_icon UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 6, room_id);
        sqlite3_bind_int(statement, 7, user_id);
        sqlite3_bind_int(statement, 8, area_id);
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into tblCachedScenario with message.");
            return -1;
        }
        
        // NOTE: return the id which insert a record.
        // we must refresh the dial.id at once,because when we del curren tial by id
        int tid = (int)sqlite3_last_insert_rowid(database_);
        
        return tid;
    }
}

- (int) isMeetingRoomExist:(NSString*)regulus_id{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblMeetingRoomCachedTable where regulus_id = ?"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblMeetingRoomCachedTable");
        return NO;
    }
    
     sqlite3_bind_text(statement, 1, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
    
    int bRes = 0;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int chkin = sqlite3_column_int(statement, 0);
        bRes = chkin;
    }
    sqlite3_finalize(statement);
    
    return bRes;
}

- (void) updateMeetingRoomAreaId:(int)room_id areaId:(int)area_id{
    
    @synchronized (self) {
        
        const char *sqlStatement = "update tblMeetingRoomCachedTable set area_id=? where room_id=?";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblMeetingRoomCachedTable");
            return;
        }
    
        sqlite3_bind_int(statement, 1, area_id);
        sqlite3_bind_int(statement, 2, room_id);
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

- (void) updateMeetingRoomPic:(MeetingRoom*)room{
    
    @synchronized (self) {
        
        const char *sqlStatement = "update tblMeetingRoomCachedTable set room_image=? where regulus_id=?";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblMeetingRoomCachedTable");
            return;
        }
        
        NSString *small_icon = room.room_image;
        if(small_icon == nil)
            small_icon = @"";
        
        
        NSString *regulus_id = room.regulus_id;
        if(regulus_id == nil)
            regulus_id = @"";
        
        sqlite3_bind_text(statement, 1, [small_icon UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

- (void) updateMeetingRoom:(MeetingRoom*)room{
    
    @synchronized (self) {
        
        const char *sqlStatement = "update tblMeetingRoomCachedTable set regulus_password=?,regulus_user_id=?, room_name=?,room_image=?,room_id = ?,area_id=? where regulus_id=?";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblMeetingRoomCachedTable");
            return;
        }
        
        NSString *password = room.regulus_password;
        if(password == nil)
            password = @"";
        
        NSString *name = room.room_name;
        if(name == nil)
            name = @"";
        NSString *small_icon = room.room_image;
        if(small_icon == nil)
            small_icon = @"";
        
        
        NSString *regulus_id = room.regulus_id;
        if(regulus_id == nil)
            regulus_id = @"";
        
        NSString *regulus_user_id = room.regulus_user_id;
        if(regulus_user_id == nil)
            regulus_user_id = @"";
        
        int room_id = room.server_room_id;
        int area_id = room.area_id;
        
        sqlite3_bind_text(statement, 1, [password UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [regulus_user_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [small_icon UTF8String], -1, SQLITE_TRANSIENT);
        
        
        sqlite3_bind_int(statement, 5, room_id);
        sqlite3_bind_int(statement, 6, area_id);
        
        sqlite3_bind_text(statement, 7, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);

        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}



- (NSMutableArray*) getMeetingRooms{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblMeetingRoomCachedTable order by id DESC"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblMeetingRoomCachedTable");
        return nil;
    }
    
    NSMutableArray *objs = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int col0   =        sqlite3_column_int(statement, 0);
        char* col1 = (char*)sqlite3_column_text(statement, 1);
        char* col2 = (char*)sqlite3_column_text(statement, 2);
        char* col3 = (char*)sqlite3_column_text(statement, 3);
        char* col4 = (char*)sqlite3_column_text(statement, 4);
        char* col5 = (char*)sqlite3_column_text(statement, 5);
        int col6   =        sqlite3_column_int(statement, 6);
        int col7   =        sqlite3_column_int(statement, 7);
        int col8   =        sqlite3_column_int(statement, 8);
       
        MeetingRoom *mr = [[MeetingRoom alloc] init];
        
        mr.local_room_id = col0;
        mr.server_room_id = col6;
        mr.user_id = col7;
        mr.area_id = col8;
        
        if(col1){
            mr.regulus_id = [NSString stringWithUTF8String:col1];
        }
        if(col2){
            mr.regulus_password = [NSString stringWithUTF8String:col2];
        }
        if(col3){
            mr.regulus_user_id = [NSString stringWithUTF8String:col3];
        }
        if(col4){
            mr.room_name = [NSString stringWithUTF8String:col4];
        }
        if(col5){
            mr.room_image = [NSString stringWithUTF8String:col5];
        }

        
        
        [objs addObject:mr];
    }
    sqlite3_finalize(statement);
    
  
    return objs;
    
}


#pragma mark ----Cached Scenario-------
- (void) checkCachedTable{
    
    NSString *s = @"SELECT * FROM sqlite_master WHERE type='table' AND name='tblCachedScenario'";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCachedScenario");
        return;
    }
    
    BOOL have = NO;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        have = YES;
    }
    sqlite3_finalize(statement);
    
    if(!have)
    {
        s = @"CREATE TABLE tblCachedScenario(id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL  UNIQUE, s_driver_id INTEGER, cover TEXT, name TEXT, small_icon TEXT, data BLOB, regulus_id TEXT)";
        
        const char * sql = [s UTF8String];
        sqlite3_stmt *delete_statement = nil;
        
        if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSLog(@"Not Prepared DataBase! -- tblCachedScenario");
        }
        
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
    }
}


- (int) isScenarioExist:(int)s_driver_id regulus_id:(NSString*)regulus_id{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblCachedScenario where s_driver_id = ? and regulus_id = ?"];
	const char *sqlStatement = [s UTF8String];
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblCachedScenario");
        return NO;
    }
	
    sqlite3_bind_int(statement, 1, s_driver_id);
    sqlite3_bind_text(statement, 2, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
    
    int bRes = 0;
	while (sqlite3_step(statement) == SQLITE_ROW) {		
        
        int chkin = sqlite3_column_int(statement, 6);
		
        if(chkin > 0)
            bRes = chkin;
        else
            bRes = 1;
        break;
	}
	sqlite3_finalize(statement);
	
	return bRes;
}

- (void) updateScenario:(NSDictionary*)scenario{
    
    @synchronized (self) {
    
        const char *sqlStatement = "update tblCachedScenario set cover=?,name=?,small_icon=?,data=? where s_driver_id=? and regulus_id=?";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblCachedScenario");
            return;
        }
        
        NSString *cover = [scenario objectForKey:@"cover"];
        if(cover == nil)
            cover = @"";
        
        NSString *name = [scenario objectForKey:@"name"];
        if(name == nil)
            name = @"";
        NSString *small_icon = [scenario objectForKey:@"small_icon"];
        if(small_icon == nil)
            small_icon = @"";
        
        NSDictionary *data = scenario;
        
        int s_driver_id = [[scenario objectForKey:@"s_driver_id"] intValue];
        NSString* regulus_id = [scenario objectForKey:@"regulus_id"];
        if(regulus_id)
        {
            sqlite3_bind_text(statement, 1, [cover UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [small_icon UTF8String], -1, SQLITE_TRANSIENT);
            
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data];
            sqlite3_bind_blob(statement, 4, [archiveData bytes], (int)[archiveData length], NULL);
            
            sqlite3_bind_int(statement, 5, s_driver_id);
            sqlite3_bind_text(statement, 6, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
            
            success = sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
}

- (int) saveScenario:(NSDictionary*)scenario{
    
    @synchronized (self) {
        
        int s_driver_id = [[scenario objectForKey:@"s_driver_id"] intValue];
        NSString* regulus_id = [scenario objectForKey:@"regulus_id"];
        
        if(regulus_id == nil)
            return -1;
        
        int c = [self isScenarioExist:s_driver_id regulus_id:regulus_id];
        if(c)
        {
            [self updateScenario:scenario];
            return 0;
        }
        
        const char *sqlStatement = "insert into tblCachedScenario (s_driver_id, cover, name, small_icon, data, regulus_id) VALUES (?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblCachedScenario");
            return -1;
        }
        
        NSString *cover = [scenario objectForKey:@"cover"];
        if(cover == nil)
            cover = @"";
        
        NSString *name = [scenario objectForKey:@"name"];
        if(name == nil)
            name = @"";
        NSString *small_icon = [scenario objectForKey:@"small_icon"];
        if(small_icon == nil)
            small_icon = @"";
        
        NSDictionary *data = scenario;
        
        sqlite3_bind_int(statement, 1, s_driver_id);
        
        sqlite3_bind_text(statement, 2, [cover UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [small_icon UTF8String], -1, SQLITE_TRANSIENT);
        
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:data];
        sqlite3_bind_blob(statement, 5, [archiveData bytes], (int)[archiveData length], NULL);
        
        sqlite3_bind_text(statement, 6, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into tblCachedScenario with message.");
            return -1;
        }
        
        // NOTE: return the id which insert a record.
        // we must refresh the dial.id at once,because when we del curren tial by id
        int tid = (int)sqlite3_last_insert_rowid(database_);
        
        return tid;
    }
}

- (NSMutableArray*) getSavedScenario:(NSString*)regulus_id{
    
    NSString *s = [NSString stringWithFormat:@"select data from tblCachedScenario where regulus_id = ?"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;

    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblCachedScenario");
        return nil;
    }

    sqlite3_bind_text(statement, 1, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);

    NSMutableArray *objs = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW) {

        const void* achievement_id       = sqlite3_column_blob(statement, 0);
        int achievement_idSize           = sqlite3_column_bytes(statement, 0);

        if(achievement_id)
        {
            NSData *data = [[NSData alloc] initWithBytes:achievement_id length:achievement_idSize];
            NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [objs addObject:mdic];
        }

    }
    sqlite3_finalize(statement);
    
    /*
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"999" ofType:@"txt"]];
    
    NSMutableArray *dataArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    return dataArray;
     */
	
    return objs;
    
}

- (int) deleteScenario:(NSDictionary*)scenario{
    
    const char *sqlStatement = "delete from tblCachedScenario where s_driver_id = ? and regulus_id=?";
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete: tblCachedScenario");
        return -1;
    }
    
    int s_driver_id = [[scenario objectForKey:@"s_driver_id"] intValue];
    NSString* regulus_id = [scenario objectForKey:@"regulus_id"];
    sqlite3_bind_int(statement, 1, s_driver_id);
    sqlite3_bind_text(statement, 2, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into tblCachedScenario with message.");
        return -1;
    }
    return 0;
}

- (void) deleteScenarioByRoom:(NSString*)regulus_id{
 
    const char *sqlStatement = "delete from tblCachedScenario where regulus_id=?";
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete: tblCachedScenario");
        return;
    }

    sqlite3_bind_text(statement, 1, [regulus_id UTF8String], -1, SQLITE_TRANSIENT);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into tblCachedScenario with message.");
        return;
    }
    return;
}




@end

