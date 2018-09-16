//
//  UserSensorObj.m
//  veenoon
//
//  Created by 安志良 on 2018/9/16.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserSensorObj.h"
#import "RegulusSDK.h"

@interface UserSensorObj ()
{
    int maxConnectCount;
    int connectBoundingReqCount;
}
@end

@implementation UserSensorObj {
    
}
@synthesize rgsDriverObj;
@synthesize connectionObjArray;

- (void) getMyConnects{
    
    RgsDriverObj *driverObj = self.rgsDriverObj;
    
    self.connectionObjArray = [NSMutableArray array];
    
    IMP_BLOCK_SELF(UserSensorObj);
    
    connectBoundingReqCount = 0;
    [[RegulusSDK sharedRegulusSDK] GetDriverConnects:driverObj.m_id completion:^(BOOL result,NSArray * connects,NSError * error){
        if(result)
        {
            maxConnectCount = (int)[connects count];
            for(RgsConnectionObj *conbj in connects)
            {
                [conbj GetBoundings:^(BOOL result, NSArray *connections, NSError *error) {
                   
                    connectBoundingReqCount++;
                    if(result && [connections count])
                    {
                        [block_self.connectionObjArray addObject:[connections objectAtIndex:0]];
                    }
                    
                    [block_self testEnd];
                }];
            }
                 
           
        }
        
    }];
    
}

- (void)testEnd{
    
    if(connectBoundingReqCount >= maxConnectCount)
    {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Connections_Loaded"
                                                        object:nil];
    }
}

@end
