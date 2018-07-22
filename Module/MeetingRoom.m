//
//  MeetingRoom.m
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "MeetingRoom.h"
#import "WebClient.h"

@interface MeetingRoom ()
{
    WebClient *_client;
}

@end;

@implementation MeetingRoom
@synthesize regulus_id;
@synthesize regulus_password;
@synthesize regulus_user_id;
@synthesize room_name;
@synthesize room_image;

@synthesize local_room_id;
@synthesize server_room_id;
@synthesize user_id;
@synthesize area_id;


- (id) init{
    
    if(self = [super init])
    {
        
    }
    return self;
}

- (void) syncAreaToServer{
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/updateroomarea";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    [param setObject:regulus_id forKey:@"regulusID"];
    [param setObject:[NSString stringWithFormat:@"%d", area_id] forKey:@"areaID"];
    
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
       
        
    } FailBlock:^(id lParam, id rParam) {
        
       
    }];
}

@end
