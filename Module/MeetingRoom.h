//
//  MeetingRoom.h
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

//regulus_id TEXT, regulus_password TEXT, regulus_user_id TEXT, room_name TEXT, room_image TEXT,  room_id INTEGER, user_id INTEGER, area_id INTEGER

@interface MeetingRoom : NSObject
@property (nonatomic, strong) NSString *regulus_id;
@property (nonatomic, strong) NSString *regulus_password;
@property (nonatomic, strong) NSString *regulus_user_id;
@property (nonatomic, strong) NSString *room_name;
@property (nonatomic, strong) NSString *room_image;

@property (nonatomic, assign) int local_room_id;
@property (nonatomic, assign) int server_room_id;
@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int area_id;


@property (nonatomic, strong) NSArray *_scenarioArray;

- (id) initWithDictionary:(NSDictionary*)info;

- (void) syncAreaToServer;

@end
