//
//  DataSync.h
//  Hint
//
//  Created by jack on 1/16/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DataSync : NSObject
{
    
}
@property (nonatomic, strong) NSMutableArray *_namecards;
@property (nonatomic, strong) NSMutableDictionary *_exhibitorsMap;
@property (nonatomic, strong) NSMutableDictionary *_eventMap;

@property (nonatomic, strong) NSDictionary *_currentReglusLogged;
@property (nonatomic, strong) NSMutableArray *_drivers;
@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;

+ (DataSync*)sharedDataSync;


- (void) syncCurrentEvent;
- (id) currentEvent;

- (void) loadingLocalDrivers;

@end
