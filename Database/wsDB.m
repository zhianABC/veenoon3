//
//  GoGoDB.m
//  Gemini
//
//  Created by jack on 1/9/15.
//  Copyright (c) 2015 jack. All rights reserved.
//

#import "wsDB.h"
#import "SBJson4.h"
#import "UserDefaultsKV.h"


@implementation wsDB
@synthesize databasePath_;
@synthesize _currentUserFolder;

static wsDB* wsDBInstance = nil;

+ (wsDB*)sharedDBInstance{
    
    
    if(wsDBInstance == nil){
        
        wsDBInstance = [[wsDB alloc] init];
        [wsDBInstance open];
        
    }
    return wsDBInstance;
}

- (id) init{
    
    self = [super init];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
 
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* dbPath = [documentsDirectory stringByAppendingPathComponent:@"wsDB.sqlite"];
    
    if(![fm fileExistsAtPath:dbPath])
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"wsDB.sqlite" ofType:nil];
        
        [fm copyItemAtPath:sPath toPath:dbPath error:nil];
    }
    
    NSLog(@"%@",dbPath);
    
    return self;
}


-(int) open
{
    if (database_) {
        return 1;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath =  [documentsDirectory stringByAppendingPathComponent:@"wsDB.sqlite"];
    
    self.databasePath_ = dbPath;
    if(sqlite3_open([dbPath UTF8String], &database_)== SQLITE_OK)
    {

        [self checkAndCreateCompanyCache];
        
        return 1;
    }
    else
    {
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
    
}


- (NSArray *) queryAllCountryCodes{
    
    const char *sqlStatement = "select * from tblCountryCode";
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCountryCode");
        return nil;
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* code           = (char*)sqlite3_column_text(statement, 0);
        char* telcode        = (char*)sqlite3_column_text(statement, 1);
        char* name           = (char*)sqlite3_column_text(statement, 2);
        char* ename          = (char*)sqlite3_column_text(statement, 3);
        
        
        NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
        
        if(code)
        {
            [req setObject:[NSString stringWithUTF8String:code] forKey:@"code"];
        }
        if(telcode)
        {
            [req setObject:[NSString stringWithUTF8String:telcode] forKey:@"telcode"];
        }
        if(name)
        {
            [req setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        if(ename)
        {
            [req setObject:[NSString stringWithUTF8String:ename] forKey:@"ename"];
        }
        [results addObject:req];
    }
    sqlite3_finalize(statement);
    
    return results;
}

- (NSString *)telcodeByCode:(NSString*)code{
    
    const char *sqlStatement = "select * from tblCountryCode";
    
    if([code length])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from tblCountryCode where code = '%@'", code];
        sqlStatement = [sql UTF8String];
    }
    else
        return @"86";
    
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCountryCode");
        return nil;
    }
    
    
    NSString *results = @"";
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* telcode        = (char*)sqlite3_column_text(statement, 1);
     
        if(telcode)
        {
           results = [NSString stringWithUTF8String:telcode];
        }

        break;
    }
    sqlite3_finalize(statement);
    
    return results;
}

- (NSArray *)countrycodeByCode:(NSString*)code{
    
    const char *sqlStatement = "select * from tblCountryCode";
    
    if([code length])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from tblCountryCode where code like '%@'", code];
        sqlStatement = [sql UTF8String];
    }
    
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCountryCode");
        return nil;
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* code           = (char*)sqlite3_column_text(statement, 0);
        char* telcode        = (char*)sqlite3_column_text(statement, 1);
        char* name           = (char*)sqlite3_column_text(statement, 2);
        char* ename          = (char*)sqlite3_column_text(statement, 3);
        
        
        NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
        
        if(code)
        {
            [req setObject:[NSString stringWithUTF8String:code] forKey:@"code"];
        }
        if(telcode)
        {
            [req setObject:[NSString stringWithUTF8String:telcode] forKey:@"telcode"];
        }
        if(name)
        {
            [req setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        if(ename)
        {
            [req setObject:[NSString stringWithUTF8String:ename] forKey:@"ename"];
        }
        [results addObject:req];
        
        break;
    }
    sqlite3_finalize(statement);
    
    return results;
}

- (NSArray *)searchByKeywords:(NSString*)keywords{
    
    const char *sqlStatement = "select * from tblCountryCode";
    
    if([keywords length])
    {
        NSString *sql = [NSString stringWithFormat:@"select * from tblCountryCode where code like '%%%@%%' or ename like '%%%@%%' or telcode like '%%%@%%'", keywords, keywords, keywords];
        sqlStatement = [sql UTF8String];
    }
    
    
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCountryCode");
        return nil;
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* code           = (char*)sqlite3_column_text(statement, 0);
        char* telcode        = (char*)sqlite3_column_text(statement, 1);
        char* name           = (char*)sqlite3_column_text(statement, 2);
        char* ename          = (char*)sqlite3_column_text(statement, 3);
        
        
        NSMutableDictionary *req = [[NSMutableDictionary alloc] init];
        
        if(code)
        {
            [req setObject:[NSString stringWithUTF8String:code] forKey:@"code"];
        }
        if(telcode)
        {
            [req setObject:[NSString stringWithUTF8String:telcode] forKey:@"telcode"];
        }
        if(name)
        {
            [req setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        if(ename)
        {
            [req setObject:[NSString stringWithUTF8String:ename] forKey:@"ename"];
        }
        [results addObject:req];
    }
    sqlite3_finalize(statement);
    
    return results;
    
}



- (NSArray *)queryAllProvince{
    
    NSString* s = @"select * from tblProvince";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblProvince");
        return nil;
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int pid        = sqlite3_column_int(statement, 0);
        char* name     = (char*)sqlite3_column_text(statement, 1);
        
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        if(name)
        {
            [mdic setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        
        [mdic setObject:[NSString stringWithFormat:@"%d",pid] forKey:@"id"];
        
        if(pid)
        {
            NSArray *cities = [self queryCityByProvince:pid];
            if(cities)
            {
                [mdic setObject:cities forKey:@"cities"];
            }
        }
        
        [results addObject:mdic];
    }
    
    sqlite3_finalize(statement);
    
    return results;
    
}

- (NSDictionary *)searchProvince:(NSString*)provinceKey{
    
    NSString* s = [NSString stringWithFormat:@"select * from tblProvince where name like '%%%@%%'", provinceKey];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblProvince");
        return nil;
    }
    
    NSMutableDictionary *mdic = nil;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int pid        = sqlite3_column_int(statement, 0);
        char* name     = (char*)sqlite3_column_text(statement, 1);
        
        
        mdic = [[NSMutableDictionary alloc] init];
        if(name)
        {
            [mdic setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        
        [mdic setObject:[NSString stringWithFormat:@"%d",pid] forKey:@"id"];
        
        
        break;
    }
    
    sqlite3_finalize(statement);
    
    return mdic;
    
}

- (NSDictionary *)searchCity:(NSString*)cityKey andProvince:(int)pid{
    
    NSString* s = [NSString stringWithFormat:@"select * from tblCity where name like '%%%@%%' and pid = %d", cityKey, pid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCity");
        return nil;
    }
    
    NSMutableDictionary *mdic = nil;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int cid        = sqlite3_column_int(statement, 0);
        char* name     = (char*)sqlite3_column_text(statement, 1);
        int pid        = sqlite3_column_int(statement, 2);
        
        mdic = [[NSMutableDictionary alloc] init];
        if(name)
        {
            [mdic setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        
        [mdic setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"id"];
        [mdic setObject:[NSNumber numberWithInt:pid] forKey:@"pid"];
        
        break;
    }
    
    sqlite3_finalize(statement);
    
    return mdic;
    
}


- (NSArray *)queryCityByProvince:(int)pid{
    
    NSString* s = [NSString stringWithFormat:@"select * from tblCity where pid = %d", pid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCity");
        return nil;
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int cid        = sqlite3_column_int(statement, 0);
        char* name     = (char*)sqlite3_column_text(statement, 1);
        int pid        = sqlite3_column_int(statement, 2);
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        if(name)
        {
            [mdic setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        
        [mdic setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"id"];
        [mdic setObject:[NSNumber numberWithInt:pid] forKey:@"pid"];
        
        if(cid)
        {
            NSArray *areas = [self queryAreaByCity:cid];
            if(areas)
            {
                [mdic setObject:areas forKey:@"areas"];
            }
        }
        
        
        
        [results addObject:mdic];
    }
    
    sqlite3_finalize(statement);
    
    return results;
    
}
- (NSArray *)queryAreaByCity:(int)pid{
    
    NSString* s = [NSString stringWithFormat:@"select * from tblArea where pid = %d", pid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblArea");
        return nil;
    }
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        int cid        = sqlite3_column_int(statement, 0);
        char* name     = (char*)sqlite3_column_text(statement, 1);
        int pid        = sqlite3_column_int(statement, 2);
        
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        if(name)
        {
            [mdic setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
        }
        
        [mdic setObject:[NSString stringWithFormat:@"%d",cid] forKey:@"id"];
        [mdic setObject:[NSNumber numberWithInt:pid] forKey:@"pid"];
        
        
        [results addObject:mdic];
    }
    
    sqlite3_finalize(statement);
    
    return results;
    
}


- (NSString *)provinceById:(int)oid{
    
    NSString* s = [NSString stringWithFormat:@"select name from tblProvince where id = %d", oid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblProvince");
        return nil;
    }
    
    
    NSString *result = @"";
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* name     = (char*)sqlite3_column_text(statement, 0);
        
        
        result = [NSString stringWithUTF8String:name];
        break;
    }
    
    sqlite3_finalize(statement);
    
    return result;
    
}
- (NSString *)cityById:(int)oid{
    
    NSString* s = [NSString stringWithFormat:@"select name from tblCity where id = %d", oid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCity");
        return nil;
    }
    
    
    NSString *result = @"";
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* name     = (char*)sqlite3_column_text(statement, 0);
        
        
        result = [NSString stringWithUTF8String:name];
        break;
    }
    
    sqlite3_finalize(statement);
    
    return result;
}
- (NSString *)areaById:(int)oid{
    
    NSString* s = [NSString stringWithFormat:@"select name from tblArea where id = %d", oid];
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblArea");
        return nil;
    }
    
    
    NSString *result = @"未知";
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        char* name     = (char*)sqlite3_column_text(statement, 0);
        
        
        result = [NSString stringWithUTF8String:name];
        break;
    }
    
    sqlite3_finalize(statement);
    
    return result;
}




#pragma -- mark Company Records
- (void) checkAndCreateCompanyCache{
    
    NSString *s = @"SELECT * FROM sqlite_master WHERE type='table' AND name='tblCacheCompany'";
    
    const char *sqlStatement = [s UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCacheCompany");
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
        
        s = @"CREATE TABLE tblCacheCompany(id INTEGER, zh_name TEXT, en_name TEXT, boothids TEXT, data BLOB)";
        
        //
        
        
        const char * sql = [s UTF8String];
        sqlite3_stmt *delete_statement = nil;
        
        if (sqlite3_prepare_v2(database_, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSLog(@"Not Prepared tblCacheCompany!");
        }
        
        sqlite3_step(delete_statement);
        sqlite3_finalize(delete_statement);
    }
    
}

- (int) insertOrg:(NSDictionary*)org{
    
    NSDictionary *company = [org objectForKey:@"company"];
    if(company)
    {
        NSDictionary *zh = [company objectForKey:@"zh-cn"];
        NSDictionary *en = [company objectForKey:@"en"];
        NSString *logourl = nil;
        NSString *fullname_zh = nil;
        NSString *fullname_en = nil;
        if(zh)
        {
            logourl = [zh objectForKey:@"logourl"];
            fullname_zh = [zh objectForKey:@"fullname"];
        }
        if(en)
        {
            logourl = [en objectForKey:@"logourl"];
            fullname_en = [en objectForKey:@"fullname"];
        }
        
        const char *sqlStatement = "insert into tblCacheCompany (id, zh_name, en_name, boothids, data) VALUES (?, ?, ?, ?, ?)";
        sqlite3_stmt *statement;
        
        int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to tblCacheCompany");
            return -1;
        }
        
        
        
        int uid = [[org objectForKey:@"companyid"] intValue];
        sqlite3_bind_int(statement, 1, uid);
        
        if(fullname_zh == nil)
            fullname_zh = @"";
        sqlite3_bind_text(statement, 2, [fullname_zh UTF8String], -1, SQLITE_TRANSIENT);
        
        if(fullname_en == nil)
            fullname_en = @"";
        sqlite3_bind_text(statement, 3, [fullname_en UTF8String], -1, SQLITE_TRANSIENT);
        
        NSString* value = [org objectForKey:@"boothid"];
        if(value == nil)
            value = @"";
        sqlite3_bind_text(statement, 4, [value UTF8String], -1, SQLITE_TRANSIENT);
        
        
        NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:org];
        sqlite3_bind_blob(statement, 5, [archiveData bytes], (int)[archiveData length], NULL);
        
        
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into tblCacheCompany with message.");
            return -1;
        }
        
        int lastRow = (int)sqlite3_last_insert_rowid(database_);
        
        return lastRow;
    }
    
    return -1;
}

- (BOOL) isOrgLocalCahced:(id)orgid{
    
    const char *sqlStatement = "select * from tblCacheCompany where id = ?";
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCacheCompany");
        return NO;
    }
    
    sqlite3_bind_int(statement, 1, [orgid intValue]);
    
    
    BOOL result = NO;
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        result = YES;
        
        break;
    }
    sqlite3_finalize(statement);
    
    return result;
}

- (void) updateOrg:(NSDictionary*)org{
    
    NSDictionary *company = [org objectForKey:@"company"];
    if(company)
    {
        int orgid = [[org objectForKey:@"companyid"] intValue];
        if(orgid)
        {
            const char *sqlStatement = "UPDATE tblCacheCompany set zh_name = ?, en_name=?, boothids=?, data = ? where id = ?";
            sqlite3_stmt *statement;
            
            int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
            if (success != SQLITE_OK) {
                NSLog(@"Error: failed to tblCacheCompany");
                return;
            }
            
            NSDictionary *zh = [company objectForKey:@"zh-cn"];
            NSDictionary *en = [company objectForKey:@"en"];
            NSString *fullname_zh = nil;
            NSString *fullname_en = nil;
            if(zh)
            {
                fullname_zh = [zh objectForKey:@"fullname"];
            }
            if(en)
            {
                fullname_en = [en objectForKey:@"fullname"];
            }
            
            
            if(fullname_zh == nil)
                fullname_zh = @"";
            sqlite3_bind_text(statement, 1, [fullname_zh UTF8String], -1, SQLITE_TRANSIENT);
            
            if(fullname_en == nil)
                fullname_en = @"";
            sqlite3_bind_text(statement, 2, [fullname_en UTF8String], -1, SQLITE_TRANSIENT);
            
            NSString* value = [org objectForKey:@"boothid"];
            if(value == nil)
                value = @"";
            sqlite3_bind_text(statement, 3, [value UTF8String], -1, SQLITE_TRANSIENT);
            
            
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:org];
            sqlite3_bind_blob(statement, 4, [archiveData bytes], (int)[archiveData length], NULL);
            
            
            sqlite3_bind_int(statement, 5, orgid);
            
            
            success = sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            if (success == SQLITE_ERROR) {
                NSLog(@"Error: failed to insert into tblCacheCompany with message.");
                return;
            }
        }
    }
    
}

- (NSArray *)searchCompanyByKeyword:(NSString*)keyword{
    
    NSString *sql = [NSString stringWithFormat:@"select data from tblCacheCompany where zh_name like '%%%@%%' or en_name like '%%%@%%' or boothids like '%@%%'", keyword, keyword, keyword];
    
    const char *sqlStatement = [sql UTF8String];
    sqlite3_stmt *statement;
    
    int success = sqlite3_prepare_v2(database_, sqlStatement, -1, &statement, NULL);
    if (success != SQLITE_OK) {
        NSLog(@"Error: failed to tblCacheCompany");
        return nil;
    }
    
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        const void* achievement_id       = sqlite3_column_blob(statement, 0);
        int achievement_idSize           = sqlite3_column_bytes(statement, 0);
        
        if(achievement_id)
        {
            NSData *data = [[NSData alloc]initWithBytes:achievement_id length:achievement_idSize];
            NSDictionary * dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            [results addObject:dic];
        }
    }
    sqlite3_finalize(statement);
    
    return results;
}


@end

