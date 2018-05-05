//
//  Scenario.m
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "Scenario.h"
#import "APowerESet.h"
#import "RegulusSDK.h"

@implementation Scenario

@synthesize _A8PowerPlugs;
@synthesize _A16PowerPlugs;
@synthesize _VDVDPlayers;
@synthesize _AWirelessMikePlugs;
@synthesize _AHand2HandPlugs;
@synthesize _AProcessorPlugs;


@synthesize _VCameraSettings;
@synthesize _VRemoteSettings;
@synthesize _VVideoProcess;
@synthesize _VPinJie;
@synthesize _VTV;
@synthesize _VLuBoJi;
@synthesize _VTouyingji;

@synthesize _APlayerPlugs;

@synthesize _areas;

@synthesize _eventOperations;
@synthesize _eventOperations_map;

- (id)init
{
    if(self = [super init])
    {
        self._eventOperations = [NSMutableArray array];
        self._eventOperations_map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) addEventOperation:(RgsSceneOperation*)rgsSceneOp{
    
    id opt = [rgsSceneOp getOperation];
    
    if([opt isKindOfClass:[RgsSceneDeviceOperation class]])
    {
        RgsSceneDeviceOperation *dev_opt = (RgsSceneDeviceOperation*)opt;
        [_eventOperations_map setObject:dev_opt
                                 forKey:[NSNumber numberWithInteger:dev_opt.dev_id]];
    }
    
    
}

@end
