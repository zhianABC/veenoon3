//
//  DataBase.m
//  
//
//  Created by jack on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"
#import "SBJson4.h"

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
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"zhucebao_db.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL find = [fileManager fileExistsAtPath:path];
    if(find)
    {
        return;
        
        //[fileManager removeItemAtPath:path error:nil];
    }
    
    NSError *error;
    NSString *pathToDefaultPlist = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"zhucebao_db.sqlite"];
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
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"zhucebao_db.sqlite"];

	
	self.databasePath_ = dbPath;
	if(sqlite3_open([dbPath UTF8String], &database_)== SQLITE_OK)
	{
        [self checkCachedBarcodeTable];
        
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


#pragma mark ----Cached Barcode-------
- (void) checkCachedBarcodeTable{
    
    NSString *s = @"SELECT * FROM sqlite_master WHERE type='table' AND name='tblCachedBarcode'";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCachedBarcode");
        return;
    }
    
    BOOL have = NO;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        have = YES;
    }
    sqlite3_finalize(statement);
    
    if(!have)
    {
        s = @"CREATE TABLE tblCachedBarcode(id INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL  UNIQUE, qr TEXT, uploaded INTEGER, time INTEGER, data TEXT, eventid INTEGER, chkin INTEGER)";
        
        const char * sql = [s UTF8String];
        sqlite3_stmt *delete_statement = nil;
        
        if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSLog(@"Not Prepared DataBase! -- tblCachedBarcode");
        }
        
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
    }
}


- (int) isCodeExist:(NSString*)code{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblCachedBarcode where qr = ?"];
	const char *sqlStatement = [s UTF8String];
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblCachedBarcode");
        return NO;
    }
	
    sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
    
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

- (void) updateCode:(NSString*)code withData:(NSDictionary*)data status:(int)status{
    
    @synchronized (self) {
        
        if([self isCodeExist:code])
        {
            SBJson4Writer *writer = [SBJson4Writer new];
            NSString *jsonData  = [writer stringWithObject:data];
            
            const char *sqlStatement = "update tblCachedBarcode set uploaded=?,time=?,data=? where qr=?";
            sqlite3_stmt *statement;
            
            int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to insert: tblCachedBarcode");
                return;
            }
            int time = [[NSDate date] timeIntervalSince1970];
            sqlite3_bind_int(statement, 1, status);
            sqlite3_bind_int(statement, 2, time);
            sqlite3_bind_text(statement, 3, [jsonData UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [code UTF8String], -1, SQLITE_TRANSIENT);
            
            success = sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
    }
}
- (void) updateCodeStauts:(NSString*)code status:(int)status{
    
    @synchronized (self) {
        
        if([self isCodeExist:code])
        {
            const char *sqlStatement = "update tblCachedBarcode set uploaded=?,time=? where qr=?";
            sqlite3_stmt *statement;
            
            int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to insert: tblCachedBarcode");
                return;
            }
            
            int time = [[NSDate date] timeIntervalSince1970];
            sqlite3_bind_int(statement, 1, status);
            sqlite3_bind_int(statement, 2, time);
            sqlite3_bind_text(statement, 3, [code UTF8String], -1, SQLITE_TRANSIENT);
            
            success = sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
    }
    
    
}

- (void) encountQR:(NSString*)qr base:(int)base{
    
    const char *sqlStatement = "update tblCachedBarcode set chkin=? where qr=?";
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: tblCachedBarcode");
        return;
    }
    
    base+=1;
    sqlite3_bind_int(statement, 1, base);
    sqlite3_bind_text(statement, 2, [qr UTF8String], -1, SQLITE_TRANSIENT);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
}

- (NSDictionary *)chkAdmission:(NSString*)code{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblCachedBarcode where qr = ?"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:Code");
        return nil;
    }
    
    sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* code = (char*)sqlite3_column_text(statement, 1);
        int time = sqlite3_column_int(statement,3);
        int chkin = sqlite3_column_int(statement,6);
    
        
        if(code){
            [mDic setObject:[NSString stringWithUTF8String:code] forKey:@"qr"];
            //[objs addObject:[NSString stringWithUTF8String:jsonData]];
        }

        [mDic setObject:[NSNumber numberWithInt:chkin] forKey:@"chkin"];
        [mDic setObject:[NSNumber numberWithInt:time] forKey:@"time"];
        
    
    }
    sqlite3_finalize(statement);
    
    return mDic;
}

- (int) insertCode:(NSString*)code{
    
    @synchronized (self) {
        
        int c = [self isCodeExist:code];
        if(c)
        {
            [self encountQR:code base:c];
            return 0;
        }
        
        const char *sqlStatement = "insert into tblCachedBarcode (qr, uploaded, time, chkin) VALUES (?,?,?,?)";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert: tblCachedBarcode");
            return -1;
        }
        
        int time = [[NSDate date] timeIntervalSince1970];
        
        sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 2, 0);
        sqlite3_bind_int(statement, 3, time);
        sqlite3_bind_int(statement, 4, 1);
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into tblCachedBarcode with message.");
            return -1;
        }
        
        // NOTE: return the id which insert a record.
        // we must refresh the dial.id at once,because when we del curren tial by id
        int tid = (int)sqlite3_last_insert_rowid(database_);
        
        return tid;
    }
}

- (int) countTotal{
    
    NSString *s = [NSString stringWithFormat:@"select count(*) from tblCachedBarcode"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:tblCachedBarcode");
        return 0;
    }
    
    //SBJson4Parser *parser = [SBJson4Parser new];
    
    int iRes  =0;
   
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
       
        iRes = sqlite3_column_int(statement,0);
        
        break;
    }
    sqlite3_finalize(statement);
    
    return iRes;
}
- (int) countOffline{
    
    NSString *s = [NSString stringWithFormat:@"select count(*) from tblCachedBarcode where uploaded = 0"];
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:Code");
        return 0;
    }
    
    //SBJson4Parser *parser = [SBJson4Parser new];
    
    int iRes  =0;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        
        iRes = sqlite3_column_int(statement,0);
        
        break;
    }
    sqlite3_finalize(statement);
    
    return iRes;
}
- (NSMutableArray*) getSavedCode{
    
    NSString *s = [NSString stringWithFormat:@"select * from tblCachedBarcode where uploaded = 0"];
	const char *sqlStatement = [s UTF8String];
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to access:Code");
        return nil;
    }
	
    //SBJson4Parser *parser = [SBJson4Parser new];
    
	NSMutableArray *objs = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {		
        
		char* code = (char*)sqlite3_column_text(statement, 1);
        int uploaded = sqlite3_column_int(statement,2);
        int time = sqlite3_column_int(statement,3);
        char* jsonData = (char*)sqlite3_column_text(statement, 4);
        
        
        if(uploaded){
            continue;
        }
        
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
		if(code){
            [mDic setObject:[NSString stringWithUTF8String:code] forKey:@"qr"];
			//[objs addObject:[NSString stringWithUTF8String:jsonData]];
		}
        if(jsonData){
            NSString *s = [NSString stringWithUTF8String:jsonData];
            
            //id dic = [parser objectWithString:s];
            [mDic setObject:s forKey:@"data"];
            
		}
        [mDic setObject:[NSNumber numberWithInt:uploaded] forKey:@"uploaded"];
        [mDic setObject:[NSNumber numberWithInt:time] forKey:@"time"];
		
		
        [objs addObject:mDic];
	}
	sqlite3_finalize(statement);
	
	return objs;
    
}

- (int) deleteCode:(NSString*)code{
    const char *sqlStatement = "delete from tblCachedBarcode where qr = ?";
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to delete: tblCachedBarcode");
        return -1;
    }
    
    sqlite3_bind_text(statement, 1, [code UTF8String], -1, SQLITE_TRANSIENT);

    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into tblCachedBarcode with message.");
        return -1;
    }
    return 0;
}


- (NSMutableArray *)searchByKeywords:(NSString*)keywords{

    const char *sqlStatement = "select code from CCode";
    
    if([keywords length])
    {
        NSString *sql = [NSString stringWithFormat:@"select code from CCode where code like '%%%@%%'", keywords];
        sqlStatement = [sql UTF8String];
    }
    
    sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: Code");
        return nil;
    }

 
    NSMutableArray *objs = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
        
		char* code = (char*)sqlite3_column_text(statement, 0);
              
		if(code)
            [objs addObject:[NSString stringWithUTF8String:code]];
	}
	sqlite3_finalize(statement);
    
    return objs;
}





@end

