//
//  DriverCmdSync.h
//  Hint
//
//  Created by jack on 1/16/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DriverCmdSync : NSObject
{
    
}
+ (DriverCmdSync*)sharedCMDSync;


- (void) syncCmdMap:(NSArray*)cmds andKey:(id)key;
- (NSArray*) getCmdFromCache:(id)key;


@end
