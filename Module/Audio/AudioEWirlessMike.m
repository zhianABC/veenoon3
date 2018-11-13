//
//  AudioEWirlessMike.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEWirlessMike.h"
#import "AudioEWirlessMikeProxy.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"

@interface AudioEWirlessMike ()
{
    
}


@end


@implementation AudioEWirlessMike
@synthesize _proxys;
@synthesize _proxyObj;
@synthesize _localSavedCommands;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._show_icon_name = @"a_wx_2.png";
        self._show_icon_sel_name = @"a_wx_2_sel.png";
        
    }
    
    return self;
}

- (void) initChannels:(int)num{
    
//    if([_channels count])
//        [_channels removeAllObjects];
//
    
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
        
       // [_channels addObject:dic];
    }
    
}

- (void) fillDataFromCtrlCenter
{
    /*
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
     */
}



- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return @"无线话筒";
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEWirlessMike);
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
                                             serial:info.serial
                                         completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
                                             if (result) {
                                                 
                                                 block_self._driver = driver;
                                                 block_self._name = driver.name;
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
                                             }
                                             [KVNProgress showSuccess];
                                         }];
    }
}

- (void) removeDriver{
    
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [[RegulusSDK sharedRegulusSDK] DeleteDriver:dr.m_id
                                         completion:^(BOOL result, NSError *error) {
                                             
                                         }];
    }
}

- (void) prepareAllCmds
{
    
    if([_proxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        AudioEWirlessMikeProxy *vap = [_proxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:(int)vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(AudioEWirlessMike);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadCommands:commd_dict];
                                                    
                                                }];
    }
    
}

- (void) loadCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _proxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(AudioEWirlessMikeProxy *vap in audio_channels)
        {
            [vap checkRgsProxyCommandLoad:cmds];
        }
    }
    
}



- (NSDictionary *)objectToJson{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    [allData setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    
    return allData;
}


- (void) jsonToObject:(NSDictionary*)json{
    
    
}


- (NSDictionary *)userData{
    
    self.config = [NSMutableDictionary dictionary];
    [self.config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [self.config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
        [self.config setObject:[NSNumber numberWithBool:self._isSelected] forKey:@"s"];
    }
    return self.config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [self.config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[self.config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[self.config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(AudioEWirlessMike);
    [[RegulusSDK sharedRegulusSDK] GetRgsObjectByID:driver_id
                                         completion:^(BOOL result, id RgsObject, NSError *error) {
                                             
                                             if(result)
                                             {
                                                 [block_self successGotDriver:RgsObject];
                                             }
                                         }];
}


- (void) successGotDriver:(RgsDriverObj*)rgsd{
    
    self._driver = rgsd;
    self._driverInfo = rgsd.info;
    
    self._name = rgsd.name;
    
    IMP_BLOCK_SELF(AudioEWirlessMike);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
                                            if (result) {
                                                if ([proxys count]) {
                                                    
                                                    NSMutableArray *proxysArray = [NSMutableArray array];
                                                    for (RgsProxyObj *proxyObj in proxys) {
                                                        if ([proxyObj.type isEqualToString:@"Wireless Mic"]) {
                                                            [proxysArray addObject:proxyObj];
                                                        }
                                                    }
                                                    [block_self prepareChannels:proxysArray];
                                                }
                                            }
                                        }];
}


- (void) prepareChannels:(NSArray*)proxys{
    
    self._proxys = [NSMutableArray array];
    
    NSDictionary *map = [self.config objectForKey:@"opt_value_map"];
    
    for(int i = 0; i < [proxys count]; i++)
    {
        RgsProxyObj *proxy = [proxys objectAtIndex:i];
        
        id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
        
        AudioEWirlessMikeProxy *apxy = [[AudioEWirlessMikeProxy alloc] init];
        apxy._rgsProxyObj = proxy;
        
        NSArray *vals = [map objectForKey:key];
        [apxy recoverWithDictionary:vals];
        
        [_proxys addObject:apxy];
    }
    
}




@end
