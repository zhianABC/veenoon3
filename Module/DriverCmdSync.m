//
//  DriverCmdSync.m
//  Hint
//
//  Created by jack on 1/16/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "DriverCmdSync.h"

@interface DriverCmdSync ()
{
    
}
@property (nonatomic, strong) NSMutableDictionary *_proxyCmdGlobalMaps;

@end


@implementation DriverCmdSync
@synthesize _proxyCmdGlobalMaps;


static DriverCmdSync* cmdSyncInstance = nil;

+ (DriverCmdSync*)sharedCMDSync{
    
    if(cmdSyncInstance == nil){
        cmdSyncInstance = [[DriverCmdSync alloc] init];
    }
    
    return cmdSyncInstance;
}

- (id) init
{
    if(self = [super init])
    {
        self._proxyCmdGlobalMaps = [NSMutableDictionary dictionary];
    }
    return self;
    
}

- (void) syncCmdMap:(NSArray*)cmds andKey:(id)key;{
    
    [_proxyCmdGlobalMaps setObject:cmds forKey:key];
}
- (NSArray*) getCmdFromCache:(id)key{
    
    return [_proxyCmdGlobalMaps objectForKey:key];
}

@end
