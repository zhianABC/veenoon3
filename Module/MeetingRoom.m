//
//  MeetingRoom.m
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "MeetingRoom.h"

@implementation MeetingRoom
@synthesize _roomId;
@synthesize _ip;
@synthesize _name;
@synthesize _coverPath;

@synthesize _scenarioArray;

- (id) init{
    
    if(self = [super init])
    {
        
    }
    return self;
}

- (void) setMeetingData:(NSDictionary*)meetingData{
    
    self._roomId = [meetingData objectForKey:@"roomId"];
    
    
}
- (NSDictionary *)meetingData{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if(_roomId)
        [dic setObject:_roomId forKey:@"roomId"];
    
    if(_ip)
        [dic setObject:_ip forKey:@"roomIP"];
    if(_name)
        [dic setObject:_name forKey:@"roomName"];
    if(_coverPath)
        [dic setObject:_coverPath forKey:@"coverPath"];
    
    if(_scenarioArray)
        [dic setObject:_scenarioArray forKey:@"scenarioArray"];
    
    return dic;
}

@end
