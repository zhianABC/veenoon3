//
//  DeviceCmdSlice.m
//  veenoon
//
//  Created by chen jack on 2018/5/13.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DeviceCmdSlice.h"

@implementation DeviceCmdSlice
@synthesize _deviceName;
@synthesize _cmdNickName;
@synthesize _plug;
@synthesize dev_id;
@synthesize cmd;
@synthesize param;
@synthesize _opt;
@synthesize _proxyName;
@synthesize _value;

- (id) init
{
    if(self = [super init])
    {
        self._deviceName  = @"";
        self._cmdNickName  = @"";
    }
    
    return self;
}


@end
