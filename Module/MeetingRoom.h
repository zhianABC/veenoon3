//
//  MeetingRoom.h
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetingRoom : NSObject
@property (nonatomic, strong) NSString *_roomId;
@property (nonatomic, strong) NSString *_ip;
@property (nonatomic, strong) NSString *_name;
@property (nonatomic, strong) NSString *_coverPath;

@property (nonatomic, strong) NSArray *_scenarioArray;

- (void) setMeetingData:(NSDictionary*)meetingData;
- (NSDictionary *)meetingData;

@end
