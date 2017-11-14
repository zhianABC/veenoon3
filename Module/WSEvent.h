//
//  WSEvent.h
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSUser.h"

/*
 address = address;
 city = 110000;
 closetime = 14812341234;
 content = content;
 country = CN;
 county = 110000;
 cover = 5666714fc46988c5398b4567;
 coverurl = "http://devf.zwcdn.cn/image/5666714fc46988c5398b4567";
 creator =     {
     address = "";
     avatar = 5676a95cc46988d9118b456d;
     avatarurl = "http://devf.zwcdn.cn/avatar/5676a95cc46988d9118b456d/100x100.jpg";
     birthdate = 0;
     cellphone = 18600406008;
     city = 0;
     company = "";
     country = CN;
     county = 0;
     ctime = 1450511987;
     email = "";
     fullname = "\U6731\U4f1f\U4f1f";
     gender = 0;
     id = 1425275185;
     memo = "";
     mtime = 1450687576;
     province = 0;
     realname = "";
     skill = "";
     status = 0;
     telephone = "";
     title = "";
 };
 ctime = 1451282946;
 cuid = 1425275185;
 gps =     {
    lat = 0;
    lng = 0;
 };
 id = 1434470017;
 mtime = 1451283803;
 needpay = 0;
 opentime = 14512341234;
 province = 110000;
 status = 1;
 summary = summary;
 title = title;
 type = 0;
 
 */

@interface WSEvent : NSObject
{
    int wsId;
    int opentime;
    int closetime;
    int province;
    int city;
    int needpay;

    float gpsLat;
    float gpsLng;
    
    int hasparticipate;
    int numparticipant;
}

@property (nonatomic, assign) int wsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *coverurl;
@property (nonatomic, strong) NSString *address;

@property (nonatomic, assign) int opentime;
@property (nonatomic, assign) int closetime;
@property (nonatomic, assign) int province;
@property (nonatomic, assign) int city;
@property (nonatomic, assign) int needpay;

@property (nonatomic, assign) float gpsLat;
@property (nonatomic, assign) float gpsLng;

@property (nonatomic, strong) WSUser *wsUser;

@property (nonatomic, strong) NSString *eventtime;
@property (nonatomic, strong) NSString *openWeek;
@property (nonatomic, strong) NSString *closeWeek;
@property (nonatomic, strong) NSString *openHour;
@property (nonatomic, strong) NSString *closeHour;
@property (nonatomic, strong) NSString *openMonthDay;
@property (nonatomic, strong) NSString *closeMonthDay;

@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, assign) int hasparticipate;
@property (nonatomic, assign) int numparticipant;

@property (nonatomic, strong) NSArray *sliderurls;

@property (nonatomic, assign) int type;


- (id) initWithDictionary:(NSDictionary*)data;


@end
