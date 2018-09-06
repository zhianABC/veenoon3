//
//  APowerESet.m
//  veenoon
//
//  Created by chen jack on 2018/3/30.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "APowerESet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "APowerESetProxy.h"

@interface APowerESet ()
{
    
}
@property (nonatomic, strong) NSMutableDictionary *_driverCmdsMap;

@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;
@property (nonatomic, strong) NSMutableDictionary *config;


@end

@implementation APowerESet
@synthesize _lines;
@synthesize _proxyObj;
@synthesize _localSavedCommands;
@synthesize _proxys;

@synthesize _driverCmdsMap;

@synthesize _isSetAllOnOff;

@synthesize _RgsSceneDeviceOperationShadow;
@synthesize config;
@synthesize _linkVal;

- (id) init
{
    if(self = [super init])
    {
        
        //不需要ip
        self._ipaddress = @"192.168.3.7";
        self._show_icon_name = @"dy_08.png";
        self._show_icon_sel_name = @"dy_08_sel.png";
        
        self._isSetAllOnOff = NO;
        
        self._linkVal = nil;
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return audio_power_sequencer;
}

- (void) syncDriverComs{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_connections count])
    {
        IMP_BLOCK_SELF(APowerESet);
        
        RgsDriverObj *comd = _driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverConnects:comd.m_id
                                              completion:^(BOOL result, NSArray *connects, NSError *error) {
                                                  if (result) {
                                                      if ([connects count]) {
                                                          
                                                          block_self._connections = connects;
                                                      }
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"sync Driver Connection Error");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      
                                                      //[KVNProgress showErrorWithStatus:[error description]];
                                                  }
                                              }];
        
    }
}


- (void) saveProject{
    
    [KVNProgress showSuccess];
    
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(APowerESet);
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
                                             serial:info.serial
                                         completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
                                             if (result) {
                                                 
                                                 block_self._driver = driver;
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
                                             }
                                             [KVNProgress dismiss];
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

- (void) initLabs:(int)num{
    
    if(_lines == nil)
    {
        self._lines = [NSMutableArray array];
    }
    
    if([_lines count])
        return;

    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"OFF" forKey:@"status"];
        [dic setObject:@"1" forKey:@"seconds"];
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i+1] forKey:@"name"];
        [_lines addObject:dic];
    }
    
    //self._ipaddress = @"192.168.1.100";
    
}

- (void) setLabValue:(BOOL)offon withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    
    if(offon)
    {
         [value setObject:@"ON" forKey:@"status"];
    }
    else
    {
        [value setObject:@"OFF" forKey:@"status"];
    }
}

- (void) setLabDelaySecs:(int)secs withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    [value setObject:[NSString stringWithFormat:@"%d",secs]
              forKey:@"seconds"];
}

- (NSDictionary *)getLabValueWithIndex:(int)index{
    
    if(index < [_lines count])
        return [_lines objectAtIndex:index];
    
    return nil;
}

- (int) checkIsSameSeconds{
    
    int res = 0;
    
    BOOL same = YES;
    int cur = 1;
    
    for(int i = 0; i < [_lines count]; i++)
    {
        NSMutableDictionary *value = [_lines objectAtIndex:i];
        int s = [[value objectForKey:@"seconds"] intValue];
        if(i == 0)
            cur = s;
        else
        {
            if(cur != s){
                same = NO;
                break;
            }
        }
    }
    
    if(same)
    {
        res = cur;
    }
    
    return res;
}

- (void) prepareAllCmds
{
    
    if([_proxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        APowerESetProxy *vap = [_proxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:(int)vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(APowerESet);
        
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
        
        for(APowerESetProxy *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
}


- (void) checkRgsDriverCommandLoad{
    
    
    if(_driverCmdsMap && [_driverCmdsMap count])
    {
        return;
    }
    else
    {
        self._driverCmdsMap = [NSMutableDictionary dictionary];
        
        IMP_BLOCK_SELF(APowerESet);
        
        if(_driver)
        {
            RgsDriverObj *obj = _driver;
            [[RegulusSDK sharedRegulusSDK] GetDriverCommands:obj.m_id
                                                  completion:^(BOOL result, NSArray *commands, NSError *error) {
                
                if (result)
                {
                    if ([commands count]) {
                        //block_self._rgsCommands = commands;
                        for(RgsCommandInfo *cmd in commands)
                        {
                            [block_self._driverCmdsMap setObject:cmd forKey:cmd.name];
                        }
                        
                        //_isSetOK = YES;
                    }
                }
                else
                {
                    NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                                          [error description], (int)obj.m_id];
                    
                    [KVNProgress showErrorWithStatus:errorMsg];
                }
            }];
        
        }
    }
    
}


- (void) controlPower:(BOOL)isPowerOn{
    
    self._linkVal = @"ORDER_LINK";
    if (!isPowerOn) {
        self._linkVal = @"INVERSE_BREAK";
    }
    
    RgsCommandInfo *cmd = [_driverCmdsMap objectForKey:self._linkVal];
    self._isSetAllOnOff = YES;
    
    if(cmd)
    {
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        RgsDriverObj *obj = _driver;
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:obj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

- (id) generateEventOperation_power{
    
    //判断是否相同状态
    NSString *val = nil;
    for(int i = 0; i < [_lines count]; i++)
    {
        NSDictionary *dic = [_lines objectAtIndex:i];
        NSString *status = [dic objectForKey:@"status"];
        if(val == nil)
            val = status;
        
        if(![val isEqualToString:status])
        {
            val = nil;
            break;
        }
    }
    
    if(val)
    {
        NSString *cmdName = @"ORDER_LINK";
        if ([val isEqualToString:@"OFF"])
        {
            cmdName = @"INVERSE_BREAK";
        }
        
        RgsCommandInfo *cmd = nil;
        cmd = [_driverCmdsMap objectForKey:cmdName];
        
        if(cmd)
        {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            RgsDriverObj *obj = _driver;
            
            int proxyid = (int)obj.m_id;
            
            RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
            scene_opt.dev_id = proxyid;
            scene_opt.cmd = cmd.name;
            scene_opt.param = param;
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                              cmd:scene_opt.cmd
                                                                            param:scene_opt.param];
            
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmdName];
            
            return opt;
        }
        else
        {
            return [_RgsSceneDeviceOperationShadow objectForKey:cmdName];
        }
    }
    
    return nil;
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
    [config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
    }
    return config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[config objectForKey:@"driver_id"] intValue];
    
    IMP_BLOCK_SELF(APowerESet);
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
    
    IMP_BLOCK_SELF(APowerESet);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
        if (result) {
            if ([proxys count]) {
                
                NSMutableArray *proxysArray = [NSMutableArray array];
                for (RgsProxyObj *proxyObj in proxys) {
                    if ([proxyObj.type isEqualToString:@"Relay"]) {
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

    NSDictionary *map = [config objectForKey:@"opt_value_map"];

    int count = (int) [proxys count];
    if (count) {
        [self initLabs:count];
    }
    
    int br = 0;
    id key = [NSString stringWithFormat:@"%d", (int)((RgsDriverObj*)_driver).m_id];
    NSArray *datas = [map objectForKey:key];
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        NSString *cmd = dopt.cmd;

        if([cmd isEqualToString:@"ORDER_LINK"])
        {
            br = 1;
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
        else if([cmd isEqualToString:@"INVERSE_BREAK"])
        {
            br = 2;
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
    }
    
    if(br)//如果全开/全关
    {
        _isSetAllOnOff = YES;
        
        self._linkVal = @"ORDER_LINK";
        if (br == 2) {
            self._linkVal = @"INVERSE_BREAK";
        }
        
        for(int i = 0; i < [_lines count]; i++)
        {
            NSMutableDictionary *value = [_lines objectAtIndex:i];
            
            if(br == 1)
            {
                [value setObject:@"ON" forKey:@"status"];
            }
            else if(br == 2)
            {
                [value setObject:@"OFF" forKey:@"status"];
            }
        }
    }
    else//部分开关
    {
        self._linkVal = nil;
        
        _isSetAllOnOff = NO;
        
        for(int i = 0; i < [_lines count]; i++)
        {
            RgsProxyObj *proxy = [proxys objectAtIndex:i];
            
            id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
            
            APowerESetProxy *apxy = [[APowerESetProxy alloc] init];
            apxy._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [apxy recoverWithDictionary:vals];
            
            [_proxys addObject:apxy];
            
            NSMutableDictionary *value = [_lines objectAtIndex:i];
            
            
            
            if([apxy._relayStatus isEqualToString:@"Link"])
            {
                [value setObject:@"ON" forKey:@"status"];
                [value setObject:[NSString stringWithFormat:@"%d", apxy._linkDuration]
                          forKey:@"seconds"];
            }
            else if([apxy._relayStatus isEqualToString:@"Break"])
            {
                [value setObject:@"OFF" forKey:@"status"];
                [value setObject:[NSString stringWithFormat:@"%d", apxy._breakDuration]
                          forKey:@"seconds"];
            }
        }
    }
    
}


@end
