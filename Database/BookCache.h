//
//  DataBase.h
//  BMWProject
//
//  Created by Lu Chen on 10-8-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface BookCache : NSObject {

	sqlite3  *database_;
	
}
@property (strong, nonatomic) NSString *databasePath_;

+ (BookCache*)sharedBookCacheDatabaseInstance;


-(int)open;
-(void)close;


- (void) deleteBooks;
- (void) batchInsertPersons:(NSArray*)persons fromIndex:(int)fromIndex;
- (void) insertPerson:(NSDictionary*)p;
- (NSMutableArray*) getAllCachePerson;
- (NSMutableArray*) getAllCachePersonByTicketType:(int)type;
- (NSMutableArray*) searchFromCachePerson:(NSString*)keyword;
- (NSMutableArray *)searchSpeakerFromCachePerson;

- (void) deletePrinters;
- (void) insertPrinter:(NSDictionary*)printer;
- (NSMutableArray *)queryPrinterWithKeywords:(NSString*)keyword;
@end
