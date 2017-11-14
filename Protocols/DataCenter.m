//
//  DataCenter.m
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCenter.h"


static DataCenter *_globalDataInstanse;


@implementation DataCenter


@synthesize magazineQueue;
@synthesize activityQueue;
@synthesize downloadQueue;
@synthesize downloadedMagazines;
@synthesize allMagazines;
@synthesize _allCarSpecialMap;

@synthesize _printer;

+ (DataCenter*)defaultDataCenter{
	
	if(_globalDataInstanse == nil){
		_globalDataInstanse = [[DataCenter alloc] init];
        _globalDataInstanse.allMagazines = [NSMutableArray array];
	}
	return _globalDataInstanse;
}

- (void)dealloc{
    
  
}
@end
