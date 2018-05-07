//
//  DataCenter.m
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCenter.h"
#import "Scenario.h"
#import "DataBase.h"

static DataCenter *_globalDataInstanse;


@implementation DataCenter


@synthesize _selectedDevice;
@synthesize _roomData;
@synthesize _scenario;

+ (DataCenter*)defaultDataCenter{
	
	if(_globalDataInstanse == nil){
		_globalDataInstanse = [[DataCenter alloc] init];
	}
	return _globalDataInstanse;
}

- (void) cacheScenarioOnLocalDB{
    
    if(_scenario)
    {
    NSDictionary *sdata = [_scenario senarioData];
    [[DataBase sharedDatabaseInstance] saveScenario:sdata];
    }
}

- (void)dealloc{
    
  
}
@end
