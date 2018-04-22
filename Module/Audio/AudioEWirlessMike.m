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
    for(int i = -20; i < 20; i++)
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


@end
