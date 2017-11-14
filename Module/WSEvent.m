//
//  WSEvent.m
//  ws
//
//  Created by jack on 1/17/16.
//  Copyright (c) 2016 jack. All rights reserved.
//

#import "WSEvent.h"
#import "NSDate-Helper.h"

@implementation WSEvent
@synthesize wsId;
@synthesize title;
@synthesize summary;
@synthesize content;
@synthesize coverurl;
@synthesize address;

@synthesize opentime;
@synthesize closetime;
@synthesize province;
@synthesize city;
@synthesize needpay;

@synthesize gpsLat;
@synthesize gpsLng;

@synthesize wsUser;

@synthesize eventtime;
@synthesize openWeek;
@synthesize closeWeek;
@synthesize openHour;
@synthesize closeHour;
@synthesize openMonthDay;
@synthesize closeMonthDay;

@synthesize provinceName;
@synthesize cityName;

@synthesize hasparticipate;
@synthesize numparticipant;

@synthesize sliderurls;

@synthesize type;

- (id) initWithDictionary:(NSDictionary*)data{
    
    if(self = [super init])
    {
        self.wsId = [[data objectForKey:@"id"] intValue];
        
        self.type = [[data objectForKey:@"type"] intValue];
        
        self.title      = [data objectForKey:@"fullname"];
        self.summary    = [data objectForKey:@"summary"];
        self.content    = [data objectForKey:@"content"];
        self.coverurl   = [data objectForKey:@"logourl"];
        
        self.sliderurls = [data objectForKey:@"sliderurls"];
        
        self.address    = [data objectForKey:@"address"];
        
        self.opentime   = [[data objectForKey:@"opentime"] intValue];
        self.closetime  = [[data objectForKey:@"closetime"] intValue];
        self.province   = [[data objectForKey:@"province"] intValue];
        self.city       = [[data objectForKey:@"city"] intValue];
        self.needpay    = [[data objectForKey:@"needpay"] intValue];
        
        
        self.hasparticipate = [[data objectForKey:@"hasparticipate"] intValue];
        self.numparticipant = [[data objectForKey:@"numparticipant"] intValue];
        
        NSDictionary *gps = [data objectForKey:@"gps"];
        if(gps)
        {
            self.gpsLat = [[gps objectForKey:@"lat"] floatValue];
            self.gpsLng = [[gps objectForKey:@"lng"] floatValue];
        }
        
        NSDictionary *creator = [data objectForKey:@"creator"];
        if(creator)
        {
            self.wsUser = [[WSUser alloc] initWithDictionary:creator];
        }
        
        NSDate *openDate = [NSDate dateWithTimeIntervalSince1970:opentime];
        NSDate *closeDate = [NSDate dateWithTimeIntervalSince1970:closetime];
        
        int year_open = (int)[openDate getYear];
        int month_open = (int)[openDate getMonth];
        int day_open = (int)[openDate getDay];
    
        int year_close = (int)[closeDate getYear];
        int month_close = (int)[closeDate getMonth];
        int day_close = (int)[closeDate getDay];
    
        NSDateFormatter *fm = [[NSDateFormatter alloc] init];
        
        if(year_close == year_open)
        {
            if(month_close == month_open)
            {
                if(day_close == day_open)
                {
                    [fm setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                    NSString *sOpen = [fm stringFromDate:openDate];
                    [fm setDateFormat:@"HH:mm"];
                    NSString *sEnd = [fm stringFromDate:closeDate];
                    
                    self.eventtime = [NSString stringWithFormat:@"%@ - %@", sOpen, sEnd];
                }
                else
                {
                    [fm setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                    NSString *sOpen = [fm stringFromDate:openDate];
                    [fm setDateFormat:@"dd日 HH:mm"];
                    NSString *sEnd = [fm stringFromDate:closeDate];
                    
                    self.eventtime = [NSString stringWithFormat:@"%@ - %@", sOpen, sEnd];

                }
            }
            else
            {
                [fm setDateFormat:@"yyyy年MM月dd日 HH:mm"];
                NSString *sOpen = [fm stringFromDate:openDate];
                [fm setDateFormat:@"MM月dd HH:mm"];
                NSString *sEnd = [fm stringFromDate:closeDate];
                
                self.eventtime = [NSString stringWithFormat:@"%@ - %@", sOpen, sEnd];

            }
        }
        else
        {
            [fm setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSString *sOpen = [fm stringFromDate:openDate];
            [fm setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            NSString *sEnd = [fm stringFromDate:closeDate];
            
            self.eventtime = [NSString stringWithFormat:@"%@ - %@", sOpen, sEnd];
        }
        
        
        NSArray *weekStrs = @[@"周日", @"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        int weekIndex = (int)[openDate weekday] - 1;
        self.openWeek = [weekStrs objectAtIndex:weekIndex];
        
        weekIndex = (int)[closeDate weekday] - 1;
        self.closeWeek = [weekStrs objectAtIndex:weekIndex];
        
        [fm setDateFormat:@"h:mm aa"];
        
        self.openHour = [fm stringFromDate:openDate];
        self.closeHour = [fm stringFromDate:closeDate];
        
        [fm setDateFormat:@"MM月dd日"];
        
        self.openMonthDay = [fm stringFromDate:openDate];
        self.closeMonthDay = [fm stringFromDate:closeDate];
    }
    
    
    return self;
}

@end
