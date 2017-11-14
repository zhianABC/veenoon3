//
//  BookCache.m
//  BMWProject
//
//  Created by Lu Chen on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BookCache.h"


@implementation BookCache
@synthesize databasePath_;

static BookCache* sharedBookCacheInstance = nil;

+ (BookCache*)sharedBookCacheDatabaseInstance{
    
    if(sharedBookCacheInstance == nil){
        sharedBookCacheInstance = [[BookCache alloc] init];
        [sharedBookCacheInstance open];
    }
    
    return sharedBookCacheInstance;
}

- (id) init{
    
    self = [super init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"BookCache.sqlite"];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbPath])
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"BookCache.sqlite" ofType:nil];
        
        [fm copyItemAtPath:sPath toPath:dbPath error:nil];
    }
    
    return self;
}


-(int) open
{
	if (database_) {
		return 1;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"BookCache.sqlite"];
    
	
	//NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"bmw_db" ofType:@"sqlite"];
	self.databasePath_ = dbPath;
	if(sqlite3_open([dbPath UTF8String], &database_)== SQLITE_OK)
	{
        [self checkAndCreatePrinter];
        
		return 1;
	}
	else {
		sqlite3_close(database_);
		NSLog(@"Open DataBase Failed");
		return -1;
	}
    
    
}

-(void) close
{
	if (database_) {
		sqlite3_close(database_);
	}
	
}

- (void)dealloc{
	
    [self close];
 
    
}


- (void) deleteBooks{
    
    NSString *s = @"delete from BookCacheT";
	
	const char * sql = [s UTF8String];
    sqlite3_stmt *delete_statement = nil;
    
	if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
		NSLog(@"Not Prepared DataBase!");
	}
	
	sqlite3_step(delete_statement);
	sqlite3_finalize(delete_statement);
}

- (void) batchInsertPersons:(NSArray*)persons fromIndex:(int)fromIndex{
    
    NSString *sql = @"insert into BookCacheT (PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker) SELECT";
    
    int i = 0;
    
    int max = fromIndex+100;
    if(max > (int)[persons count])
        max = (int)[persons count];
    
    for(int k = fromIndex; k < max; k++ )
    {
        NSDictionary *conf = [persons objectAtIndex:k];
        
        if(i > 0)
        {
            sql = [NSString stringWithFormat:@"%@ UNION SELECT", sql];
        }
        
        NSString *value = [conf objectForKey:@"PersonID"];
        
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"CName"];
        if(value == nil)
            value = @"";
        
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"FirstName"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"SecondName"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"Email"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"Mobile"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"CompanyName"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"CompanyEName"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"TicketTypeDisplayName"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"RegisterId"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        value = [conf objectForKey:@"TicketTypeId"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        sql = [NSString stringWithFormat:@"%@ \'%@\',",sql, value];
        
        
        value = [conf objectForKey:@"IsSpeaker"];
        if(value == nil || [value isKindOfClass:[NSNull class]])
            value = @"";
        
        sql = [NSString stringWithFormat:@"%@ \'%@\'",sql, value];
        
        i = 1;
    }
    
    const char *sqlStatement = [sql UTF8String];
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: Package");
        return;
    }
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return ;
    }
}

- (void) insertPerson:(NSDictionary*)p{
    
    NSString *sql = @"insert into BookCacheT (PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker) values (?,?,?,?,?,?,?,?,?,?,?,?)";
    
    const char *sqlStatement = [sql UTF8String];
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: BookCacheT");
        return;
    }
    
    
    NSString *value = [p objectForKey:@"PersonID"];
    sqlite3_bind_text(statement, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    value = [p objectForKey:@"CName"];
    if(value == nil)
        value = @"";
    sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    value = [p objectForKey:@"FirstName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 3, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"SecondName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 4, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"Email"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 5, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"Mobile"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 6, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"CompanyName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 7, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"CompanyEName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 8, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"filePhoto"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 9, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"RegisterId"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 10, [value UTF8String], -1, SQLITE_TRANSIENT);

    value = [p objectForKey:@"TicketTypeId"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 11, [value UTF8String], -1, SQLITE_TRANSIENT);

    
    value = [p objectForKey:@"IsSpeaker"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 12, [value UTF8String], -1, SQLITE_TRANSIENT);

    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into the database with message.");
        return ;
    }
    
}

- (NSMutableArray *)searchSpeakerFromCachePerson{
    
    const char *sqlStatement = "select * from BookCacheT where IsSpeaker = '1'";
    
    sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: Code");
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* col1 = (char*)sqlite3_column_text(statement, 0);
        char* col2 = (char*)sqlite3_column_text(statement, 1);
        char* col3 = (char*)sqlite3_column_text(statement, 2);
        char* col4 = (char*)sqlite3_column_text(statement, 3);
        char* col5 = (char*)sqlite3_column_text(statement, 4);
        char* col6 = (char*)sqlite3_column_text(statement, 5);
        char* col7 = (char*)sqlite3_column_text(statement, 6);
        char* col8 = (char*)sqlite3_column_text(statement, 7);
        char* col9 = (char*)sqlite3_column_text(statement, 8);
        char* col10 = (char*)sqlite3_column_text(statement, 9);
		char* col11 = (char*)sqlite3_column_text(statement, 10);
        char* col12 = (char*)sqlite3_column_text(statement, 11);
        
        //PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
		if(col1){
            [p setObject:[NSString stringWithUTF8String:col1] forKey:@"PersonID"];
		}
        if(col2){
            [p setObject:[NSString stringWithUTF8String:col2] forKey:@"CName"];
		}
        if(col3){
            [p setObject:[NSString stringWithUTF8String:col3] forKey:@"FirstName"];
		}
        if(col4){
            [p setObject:[NSString stringWithUTF8String:col4] forKey:@"SecondName"];
		}
        if(col5){
            [p setObject:[NSString stringWithUTF8String:col5] forKey:@"Email"];
		}
        if(col6){
            [p setObject:[NSString stringWithUTF8String:col6] forKey:@"Mobile"];
		}
        if(col7){
            [p setObject:[NSString stringWithUTF8String:col7] forKey:@"CompanyName"];
		}
        if(col8){
            [p setObject:[NSString stringWithUTF8String:col8] forKey:@"CompanyEName"];
		}
        if(col9){
            [p setObject:[NSString stringWithUTF8String:col9] forKey:@"filePhoto"];
		}
        if(col10){
            [p setObject:[NSString stringWithUTF8String:col10] forKey:@"RegisterId"];
		}
        if(col11){
            [p setObject:[NSString stringWithUTF8String:col11] forKey:@"TicketTypeId"];
		}
        if(col12){
            [p setObject:[NSString stringWithUTF8String:col12] forKey:@"IsSpeaker"];
		}
        
        
        [arr addObject:p];
		
    }
	sqlite3_finalize(statement);
	
	return arr;
}

- (NSMutableArray*) searchFromCachePerson:(NSString*)keyword
{
    const char *sqlStatement = "select * from BookCacheT";
    
    if([keyword length])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from BookCacheT where CName like '%%%@%%' or Email like '%%%@%%' or Mobile like '%%%@%%' or RegisterId like '%%%@%%'", keyword,keyword,keyword,keyword];
        sqlStatement = [sql UTF8String];
    }
    else
    {
        return nil;
    }
    
    sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: Code");
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* col1 = (char*)sqlite3_column_text(statement, 0);
        char* col2 = (char*)sqlite3_column_text(statement, 1);
        char* col3 = (char*)sqlite3_column_text(statement, 2);
        char* col4 = (char*)sqlite3_column_text(statement, 3);
        char* col5 = (char*)sqlite3_column_text(statement, 4);
        char* col6 = (char*)sqlite3_column_text(statement, 5);
        char* col7 = (char*)sqlite3_column_text(statement, 6);
        char* col8 = (char*)sqlite3_column_text(statement, 7);
        char* col9 = (char*)sqlite3_column_text(statement, 8);
        char* col10 = (char*)sqlite3_column_text(statement, 9);
		char* col11 = (char*)sqlite3_column_text(statement, 10);
        char* col12 = (char*)sqlite3_column_text(statement, 11);
        
        //PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
		if(col1){
            [p setObject:[NSString stringWithUTF8String:col1] forKey:@"PersonID"];
		}
        if(col2){
            [p setObject:[NSString stringWithUTF8String:col2] forKey:@"CName"];
		}
        if(col3){
            [p setObject:[NSString stringWithUTF8String:col3] forKey:@"FirstName"];
		}
        if(col4){
            [p setObject:[NSString stringWithUTF8String:col4] forKey:@"SecondName"];
		}
        if(col5){
            [p setObject:[NSString stringWithUTF8String:col5] forKey:@"Email"];
		}
        if(col6){
            [p setObject:[NSString stringWithUTF8String:col6] forKey:@"Mobile"];
		}
        if(col7){
            [p setObject:[NSString stringWithUTF8String:col7] forKey:@"CompanyName"];
		}
        if(col8){
            [p setObject:[NSString stringWithUTF8String:col8] forKey:@"CompanyEName"];
		}
        if(col9){
            [p setObject:[NSString stringWithUTF8String:col9] forKey:@"filePhoto"];
		}
        if(col10){
            [p setObject:[NSString stringWithUTF8String:col10] forKey:@"RegisterId"];
		}
        if(col11){
            [p setObject:[NSString stringWithUTF8String:col11] forKey:@"TicketTypeId"];
		}
        if(col12){
            [p setObject:[NSString stringWithUTF8String:col12] forKey:@"IsSpeaker"];
		}
        
        
        [arr addObject:p];
		
    }
	sqlite3_finalize(statement);
	
	return arr;
    
}

- (NSMutableArray*) getAllCachePersonByTicketType:(int)type{
    
    NSString *s = [NSString stringWithFormat:@"select * from BookCacheT where TicketTypeId = '%d'", type];
    
	const char *sqlStatement = [s UTF8String];
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to BookCacheT");
        return nil;
    }
	
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* col1 = (char*)sqlite3_column_text(statement, 0);
        char* col2 = (char*)sqlite3_column_text(statement, 1);
        char* col3 = (char*)sqlite3_column_text(statement, 2);
        char* col4 = (char*)sqlite3_column_text(statement, 3);
        char* col5 = (char*)sqlite3_column_text(statement, 4);
        char* col6 = (char*)sqlite3_column_text(statement, 5);
        char* col7 = (char*)sqlite3_column_text(statement, 6);
        char* col8 = (char*)sqlite3_column_text(statement, 7);
        char* col9 = (char*)sqlite3_column_text(statement, 8);
        char* col10 = (char*)sqlite3_column_text(statement, 9);
		char* col11 = (char*)sqlite3_column_text(statement, 10);
        char* col12 = (char*)sqlite3_column_text(statement, 11);
        
        //PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
		if(col1){
            [p setObject:[NSString stringWithUTF8String:col1] forKey:@"PersonID"];
		}
        if(col2){
            [p setObject:[NSString stringWithUTF8String:col2] forKey:@"CName"];
		}
        if(col3){
            [p setObject:[NSString stringWithUTF8String:col3] forKey:@"FirstName"];
		}
        if(col4){
            [p setObject:[NSString stringWithUTF8String:col4] forKey:@"SecondName"];
		}
        if(col5){
            [p setObject:[NSString stringWithUTF8String:col5] forKey:@"Email"];
		}
        if(col6){
            [p setObject:[NSString stringWithUTF8String:col6] forKey:@"Mobile"];
		}
        if(col7){
            [p setObject:[NSString stringWithUTF8String:col7] forKey:@"CompanyName"];
		}
        if(col8){
            [p setObject:[NSString stringWithUTF8String:col8] forKey:@"CompanyEName"];
		}
        if(col9){
            [p setObject:[NSString stringWithUTF8String:col9] forKey:@"filePhoto"];
		}
        if(col10){
            [p setObject:[NSString stringWithUTF8String:col10] forKey:@"RegisterId"];
		}
        if(col11){
            [p setObject:[NSString stringWithUTF8String:col11] forKey:@"TicketTypeId"];
		}
        if(col12){
            [p setObject:[NSString stringWithUTF8String:col12] forKey:@"IsSpeaker"];
		}
        
        
        [arr addObject:p];
		
    }
	sqlite3_finalize(statement);
	
	return arr;
    
}
- (NSMutableArray*) getAllCachePerson{
    
    NSString *s = @"select * from BookCacheT";
    
	const char *sqlStatement = [s UTF8String];
	sqlite3_stmt *statement;
	
	int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to BookCacheT");
        return nil;
    }
	
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* col1 = (char*)sqlite3_column_text(statement, 0);
        char* col2 = (char*)sqlite3_column_text(statement, 1);
        char* col3 = (char*)sqlite3_column_text(statement, 2);
        char* col4 = (char*)sqlite3_column_text(statement, 3);
        char* col5 = (char*)sqlite3_column_text(statement, 4);
        char* col6 = (char*)sqlite3_column_text(statement, 5);
        char* col7 = (char*)sqlite3_column_text(statement, 6);
        char* col8 = (char*)sqlite3_column_text(statement, 7);
        char* col9 = (char*)sqlite3_column_text(statement, 8);
        char* col10 = (char*)sqlite3_column_text(statement, 9);
		char* col11 = (char*)sqlite3_column_text(statement, 10);
        char* col12 = (char*)sqlite3_column_text(statement, 11);
        
        //PersonID,CName,FirstName,SecondName,Email,Mobile,CompanyName,CompanyEName,TicketTypeDisplayName,RegisterId,TicketTypeId,IsSpeaker
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
		if(col1){
            [p setObject:[NSString stringWithUTF8String:col1] forKey:@"PersonID"];
		}
        if(col2){
            [p setObject:[NSString stringWithUTF8String:col2] forKey:@"CName"];
		}
        if(col3){
            [p setObject:[NSString stringWithUTF8String:col3] forKey:@"FirstName"];
		}
        if(col4){
            [p setObject:[NSString stringWithUTF8String:col4] forKey:@"SecondName"];
		}
        if(col5){
            [p setObject:[NSString stringWithUTF8String:col5] forKey:@"Email"];
		}
        if(col6){
            [p setObject:[NSString stringWithUTF8String:col6] forKey:@"Mobile"];
		}
        if(col7){
            [p setObject:[NSString stringWithUTF8String:col7] forKey:@"CompanyName"];
		}
        if(col8){
            [p setObject:[NSString stringWithUTF8String:col8] forKey:@"CompanyEName"];
		}
        if(col9){
            [p setObject:[NSString stringWithUTF8String:col9] forKey:@"filePhoto"];
		}
        if(col10){
            [p setObject:[NSString stringWithUTF8String:col10] forKey:@"RegisterId"];
		}
        if(col11){
            [p setObject:[NSString stringWithUTF8String:col11] forKey:@"TicketTypeId"];
		}
        if(col12){
            [p setObject:[NSString stringWithUTF8String:col12] forKey:@"IsSpeaker"];
		}
        
        
        [arr addObject:p];
		
    }
	sqlite3_finalize(statement);
	
	return arr;
}


- (void) checkAndCreatePrinter{
    /*
     "@ClientNo" = "fe80ccbee0dca548de9818-0811965DEE1C";
     "@ClientType" = "\U73b0\U573a\U5236\U8bc1";
     "@ExpoID" = 239;
     "@PrinterID" = 1512;
     "@PrinterName" = "Adobe PDF";
     "@ShowName" = "\U53c2\U5c55\U5546\U8bc1\U6253\U5370\U673a[Adobe PDF][\U8d75\U5947\U5149]";
     "@TicketType" = "\U53c2\U5c55\U5546\U8bc1";
     "@ValidTime" = "2015-04-25 10:10:42";
     */
    
    NSString *s = @"SELECT * FROM sqlite_master WHERE type='table' AND name='tblPrinter'";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblPrinter");
        return;
    }
    
    BOOL have = NO;
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        have = YES;
    }
    sqlite3_finalize(statement);
    
    if(!have)
    {
        //create table
        s = @"CREATE TABLE tblPrinter(ClientNo text, PrinterID INTEGER, ShowName text, PrinterName text)";
        
        const char * sql = [s UTF8String];
        sqlite3_stmt *delete_statement = nil;
        
        if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSLog(@"Not Prepared tblPrinter!");
        }
        
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
    }
}

- (void) insertPrinter:(NSDictionary*)printer{
    
    NSString *sql = @"insert into tblPrinter (ClientNo, PrinterID, ShowName, PrinterName) values (?,?,?,?)";
    
    const char *sqlStatement = [sql UTF8String];
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: tblPrinter");
        return;
    }
    
    
    NSString *value = [printer objectForKey:@"@ClientNo"];
    if(value == nil)
        value = @"";
    sqlite3_bind_text(statement, 1, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    value = [printer objectForKey:@"@PrinterID"];
    if(value == nil)
        value = @"";
    sqlite3_bind_text(statement, 2, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    value = [printer objectForKey:@"@ShowName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 3, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    value = [printer objectForKey:@"@PrinterName"];
    if(value == nil || [value isKindOfClass:[NSNull class]])
        value = @"";
    sqlite3_bind_text(statement, 4, [value UTF8String], -1, SQLITE_TRANSIENT);
    
    success = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (success == SQLITE_ERROR) {
        NSLog(@"Error: failed to insert into tblPrinter with message.");
        return ;
    }
    
}

- (NSMutableArray *)queryPrinterWithKeywords:(NSString*)keyword{
    
    const char *sqlStatement = "select * from tblPrinter";
    
    if([keyword length])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from tblPrinter where ShowName like '%%%@%%'",
                         keyword];
        sqlStatement = [sql UTF8String];
    }
    
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to insert: tblPrinter");
        return nil;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* col1 = (char*)sqlite3_column_text(statement, 0);
        char* col2 = (char*)sqlite3_column_text(statement, 1);
        char* col3 = (char*)sqlite3_column_text(statement, 2);
        char* col4 = (char*)sqlite3_column_text(statement, 3);
        
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        if(col1){
            [p setObject:[NSString stringWithUTF8String:col1] forKey:@"@ClientNo"];
        }
        if(col2){
            [p setObject:[NSString stringWithUTF8String:col2] forKey:@"@PrinterID"];
        }
        if(col3){
            [p setObject:[NSString stringWithUTF8String:col3] forKey:@"@ShowName"];
        }
        if(col4){
            [p setObject:[NSString stringWithUTF8String:col4] forKey:@"@PrinterName"];
        }
        
        [arr addObject:p];
        
    }
    sqlite3_finalize(statement);
    
    return arr;
}

- (void) deletePrinters{
    
    NSString *s = @"delete from tblPrinter";
    
    const char * sql = [s UTF8String];
    sqlite3_stmt *delete_statement = nil;
    
    if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
        NSLog(@"Not Prepared tblPrinter!");
    }
    
    sqlite3_step(delete_statement);
    sqlite3_finalize(delete_statement);
}


@end

