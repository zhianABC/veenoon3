//
//  AudioEWirlessMike.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEWirlessMike.h"

@interface AudioEWirlessMike ()
{
    
}
@property (nonatomic, strong) NSMutableArray *_channels;

@end


@implementation AudioEWirlessMike
@synthesize _channels;
@synthesize _freqVal;//频率
@synthesize _freqops;

@synthesize _groups;//组-通道
@synthesize _groupVal;

@synthesize _dbs;//增益
@synthesize _dbVal;

@synthesize _sq;
@synthesize _sqVal;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        self._channels = [NSMutableArray array];
    }
    
    return self;
}

- (void) initChannels:(int)num{
    
    if([_channels count])
        [_channels removeAllObjects];
    
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        //Channel配置数据
        
        //编号
        [dic setObject:[NSString stringWithFormat:@"%02d", i] forKey:@"name"];
        
        //别称
        [dic setObject:@"Channel" forKey:@"nickname"];
        [dic setObject:@0 forKey:@"db"];
        [dic setObject:@4 forKey:@"signal"];
        [dic setObject:@80 forKey:@"battery"];
        [dic setObject:@"huatong" forKey:@"type"];
        
        //序号
        [dic setObject:[NSNumber numberWithInt:i] forKey:@"index"];
        
        //设备号
        if(self._deviceno)
            [dic setObject:self._deviceno forKey:@"device"];
        
        [_channels addObject:dic];
    }
    
}

- (void) fillDataFromCtrlCenter
{
    NSMutableArray *groupValues = [NSMutableArray array];
    [groupValues addObject:@{@"name":@"A", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"}]}];
    [groupValues addObject:@{@"name":@"B", @"subs":@[@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"}]}];
    [groupValues addObject:@{@"name":@"C", @"subs":@[@{@"name":@"10"},@{@"name":@"20"},@{@"name":@"30"}]}];
    
    self._groups = groupValues;
    self._freqops = @[@"720MHz",@"600MHz"];
    
    NSMutableArray *dbs = [NSMutableArray array];
    for(int i = -20; i <= 20; i++)
    {
        if(i > 0)
        {
            [dbs addObject:[NSString stringWithFormat:@"+%d", abs(i)]];
        }
        else if(i < 0)
        {
            [dbs addObject:[NSString stringWithFormat:@"-%d", abs(i)]];
        }
        else
            [dbs addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self._dbs = dbs;
    
    self._sq = @[@"SQ1",@"SQ2",@"SQ3"];

    
    //初始化/保存的数据
    self._freqVal = @"720MHz";
    self._sqVal = @"SQ1";
    self._dbVal = @"0";
    
    NSDictionary *g0 = [groupValues objectAtIndex:0];
    NSDictionary *g1 = [[g0 objectForKey:@"subs"] objectAtIndex:0];
    self._groupVal = @{@0:@{@"index":@0, @"value":g0}
                       ,@1:@{@"index":@0,@"value":g1}};
}

- (NSArray*)channles{
    
    return _channels;
}

- (int) channelsCount{
    
    return (int)[_channels count];
}

- (NSMutableDictionary *)channelAtIndex:(int)index{
    
    if(index < [_channels count])
        return [_channels objectAtIndex:index];
    
    return nil;
}

- (NSString *)objectToJsonString{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    
    if(self._brand)
        [allData setObject:self._brand forKey:@"brand"];
    
    if(self._type)
        [allData setObject:self._type forKey:@"type"];
    
    if(self._deviceno)
        [allData setObject:self._deviceno forKey:@"deviceno"];
    
    if(self._ipaddress)
        [allData setObject:self._ipaddress forKey:@"ipaddress"];
    
    if(self._deviceid)
        [allData setObject:self._deviceid forKey:@"deviceid"];
    
    if(self._com)
        [allData setObject:self._com forKey:@"com"];
    [allData setObject:[NSString stringWithFormat:@"%d",self._index] forKey:@"index"];
    
    
    if(self._channels)
        [allData setObject:self._channels forKey:@"channels"];
    
    if(self._freqVal)
        [allData setObject:self._freqVal forKey:@"freqVal"];
    
    if(self._freqops)
        [allData setObject:self._freqops forKey:@"freqops"];
    
    if(self._groups)
        [allData setObject:self._groups forKey:@"groups"];
    
    if(self._groupVal)
        [allData setObject:self._groupVal forKey:@"groupVal"];
    
    if(self._sq)
        [allData setObject:self._sq forKey:@"sq"];
    if(self._sqVal)
        [allData setObject:self._sqVal forKey:@"sqVal"];
    
    if(self._dbs)
        [allData setObject:self._dbs forKey:@"dbs"];
    if(self._dbVal)
        [allData setObject:self._dbVal forKey:@"dbVal"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error: &error];
    
    NSString *jsonresult = [[NSString alloc] initWithData:jsonData
                                            encoding:NSUTF8StringEncoding];
    
    
    return jsonresult;
}

- (void) jsonStringToObject:(NSString*)json{
    
    NSData *data = [NSData dataWithBytes:[json UTF8String] length:[json length]];
    
    NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if([allData objectForKey:@"brand"])
        self._brand = [allData objectForKey:@"brand"];
    if([allData objectForKey:@"type"])
        self._type = [allData objectForKey:@"type"];
    
    if([allData objectForKey:@"deviceno"])
        self._deviceno = [allData objectForKey:@"deviceno"];
    
    if([allData objectForKey:@"ipaddress"])
        self._ipaddress = [allData objectForKey:@"ipaddress"];
  
    if([allData objectForKey:@"deviceid"])
        self._deviceid = [allData objectForKey:@"deviceid"];

    if([allData objectForKey:@"com"])
        self._com = [allData objectForKey:@"com"];
    
    self._index = [[allData objectForKey:@"index"] intValue];
    
    if([allData objectForKey:@"channels"])
        self._channels = [allData objectForKey:@"channels"];
    
    if([allData objectForKey:@"freqVal"])
        self._freqVal = [allData objectForKey:@"freqVal"];
    
    if([allData objectForKey:@"freqops"])
        self._freqops = [allData objectForKey:@"freqops"];
    
    if([allData objectForKey:@"groups"])
        self._groups = [allData objectForKey:@"groups"];
    
    if([allData objectForKey:@"groupVal"])
        self._groupVal = [allData objectForKey:@"groupVal"];
    

    if([allData objectForKey:@"sq"])
        self._sq = [allData objectForKey:@"sq"];
    
    if([allData objectForKey:@"sqVal"])
        self._sqVal = [allData objectForKey:@"sqVal"];
    
    if([allData objectForKey:@"dbs"])
        self._dbs = [allData objectForKey:@"dbs"];
    
    if([allData objectForKey:@"dbVal"])
        self._dbVal = [allData objectForKey:@"dbVal"];
    
}



@end
