//
//  DataCenter.h
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataCenter : NSObject {
	   
   
}
@property (nonatomic, strong) NSArray *downloadedMagazines;
@property (nonatomic, strong) NSArray *magazineQueue;
@property (nonatomic, strong) NSDictionary *activityQueue;
@property (nonatomic, strong) NSMutableDictionary *downloadQueue;

@property (nonatomic, strong) NSMutableArray *allMagazines;

@property (nonatomic, strong) NSMutableDictionary *_allCarSpecialMap;

@property (nonatomic, strong) NSDictionary *_printer;


+ (DataCenter*)defaultDataCenter;

@end
