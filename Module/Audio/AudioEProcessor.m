//
//  AudioEProcessor.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessor.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VAProcessorProxys.h"


@interface AudioEProcessor ()
{
    BOOL _isSetOK;
}
//以后实现
@property (nonatomic, strong) NSMutableArray *_inchannels;
@property (nonatomic, strong) NSMutableArray *_outchannels;
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;

@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@property (nonatomic, strong) NSMutableDictionary *config;

@end

@implementation AudioEProcessor
@synthesize _isHuiShengXiaoChu;
//中控上对应的数据
@synthesize _inAudioProxys;
@synthesize _outAudioProxys;
@synthesize delegate;
@synthesize _rgsCommands;
@synthesize _cmdMap;
@synthesize _autoMixProxy;
@synthesize _singalProxy;

//配置数据，保存从中控数据结构转换来的数据
//以后实现
@synthesize _inchannels;
@synthesize _outchannels;

@synthesize _RgsSceneDeviceOperationShadow;

@synthesize config;

- (id) init
{
    if(self = [super init])
    {
        _isHuiShengXiaoChu = NO;
        
        self._ipaddress = @"192.168.1.100";
        
        self._inchannels = [NSMutableArray array];
        self._outchannels = [NSMutableArray array];
        
        self._show_icon_name = @"a_icon_7.png";
        self._show_icon_sel_name = @"a_icon_7_sel.png";
        
        _isSetOK = NO;
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsCommands){
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
        return;
    }
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(AudioEProcessor);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetDriverCommands:((RgsDriverObj*)_driver).m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        
        [KVNProgress dismiss];
        
        if (result)
        {
            if ([commands count]) {
                
                block_self._rgsCommands = commands;
                for(RgsCommandInfo *cmd in commands)
                {
                    [block_self._cmdMap setObject:cmd forKey:cmd.name];
                }
                
                _isSetOK = YES;
                
                
                [block_self initDatasAfterPullData];
                [block_self callDelegateDidLoad];
            }
        }
        else
        {
            NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                                  [error description], (int)((RgsDriverObj*)_driver).m_id];
            
            [KVNProgress showErrorWithStatus:errorMsg];
            
            [block_self callDelegateDidLoad];
            
            [KVNProgress dismiss];
        }
        
    }];
}

- (void) callDelegateDidLoad{
    
    if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
    {
        [delegate didLoadedProxyCommand];
    }
}

- (void) initDatasAfterPullData{
    
}

- (void) controlHuiShengXiaoChu:(BOOL)isHuiShengXiaoChu {
    _isHuiShengXiaoChu = isHuiShengXiaoChu;
    
    [self sendEchoCancle];
}
- (BOOL) isHuiShengXiaoChuStarted {
    return _isHuiShengXiaoChu;
}

-(void) sendEchoCancle {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"ECHO_CANCLE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isHuiShengXiaoChu)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
            }
            
            if([param count])
            {
                [[RegulusSDK sharedRegulusSDK] ControlDevice:((RgsDriverObj*) _driver).m_id
                                                         cmd:cmd.name
                                                       param:param completion:nil];
            }
            
        }
    }
}

- (NSString*) deviceName{
    
    return audio_process_name;
}

- (void) initInputChannels:(int)num{
    
    
}
- (int) inputChannelsCount{
    
    return (int)[_inchannels count];
}
- (NSMutableDictionary *)inputChannelAtIndex:(int)index{

    if(index < [_inchannels count])
        return [_inchannels objectAtIndex:index];
    
    return nil;
}

- (void) initOutChannels:(int)num{
    
  
}
- (int) outChannelsCount{
    
    return (int)[_outchannels count];
}
- (NSMutableDictionary *)outChannelAtIndex:(int)index{
    
    if(index < [_outchannels count])
        return [_outchannels objectAtIndex:index];
    
    return nil;
}


- (void) saveProject{
    
    [KVNProgress showSuccess];
    
//    [KVNProgress show];
//
//    [[RegulusSDK sharedRegulusSDK] ReloadProject:^(BOOL result, NSError *error) {
//        if(result)
//        {
//            NSLog(@"reload project.");
//
//            [KVNProgress showSuccess];
//        }
//        else{
//            NSLog(@"%@",[error description]);
//
//            [KVNProgress showSuccess];
//        }
//    }];
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEProcessor);
        
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

- (void) prepareAllAudioInCmds
{
    
    if([_inAudioProxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        VAProcessorProxys *vap = [_inAudioProxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:(int)vap._rgsProxyObj.m_id]];
    
        IMP_BLOCK_SELF(AudioEProcessor);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadAudioInCommands:commd_dict];
                                                    
                                                }];
    }
    
}

- (void) loadAudioInCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _inAudioProxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(VAProcessorProxys *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }

}

- (void) prepareAllAudioOutCmds{
    
    if([_outAudioProxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        VAProcessorProxys *vap = [_outAudioProxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(AudioEProcessor);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadAudioOutCommands:commd_dict];
                                                    
                                                }];
    }
}

- (void) loadAudioOutCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _outAudioProxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(VAProcessorProxys *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
}

//回声消除
- (id) generateEventOperation_echo{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"ECHO_CANCLE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isHuiShengXiaoChu)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"ENABLE"])
            {
                [param setObject:tureOrFalse
                          forKey:param_info.name];
            }
        }
        
        int proxyid = (int)((RgsDriverObj*) _driver).m_id;
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:proxyid] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"ECHO_CANCLE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"ECHO_CANCLE"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    
    return nil;
}



- (NSDictionary *)objectToJson{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    
    [allData setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    
    //基本信息
    if (self._name) {
        [allData setObject:self._name forKey:@"name"];
    }
    
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
    
    if(self._driverUUID)
        [allData setObject:self._driverUUID forKey:@"driverUUID"];
    
    if(self._comIdx)
        [allData setObject:[NSString stringWithFormat:@"%d",self._comIdx] forKey:@"com"];
    
    [allData setObject:[NSString stringWithFormat:@"%d",self._index] forKey:@"index"];
    
    
    if(_driverInfo)
    {
        RgsDriverInfo *info = _driverInfo;
        [allData setObject:info.serial forKey:@"driver_info_uuid"];
    }
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
        
        if(dr.name)
        {
            [allData setObject:dr.name forKey:@"driver_name"];
        }
    }
    
    if(_inAudioProxys)
    {
        NSMutableArray *proxys = [NSMutableArray array];
        
        for(VAProcessorProxys *vap in _inAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            
            NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
            [proxys addObject:proxyDic];
            
            if(vap._icon_name)
            {
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
            }
            if(vap._voiceInDevice)
            {
                [proxyDic setObject:vap._voiceInDevice
                             forKey:@"voiceInDevice"];
            }
            
            //增益
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id]
                         forKey:@"proxy_id"];
            
            [proxyDic setObject:proxy.name
                         forKey:@"proxy_name"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getAnalogyGain]]
                         forKey:@"analogy_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyMute]]
                         forKey:@"analogy_mute"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getDigitalGain]]
                         forKey:@"digital_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyDigitalMute]]
                         forKey:@"digital_mute"];
            
            [proxyDic setObject:vap._mode forKey:@"mode"];
            
            [proxyDic setObject:vap._micDb forKey:@"mic_db"];
            
            [proxyDic setObject:[NSNumber numberWithBool:vap._is48V]
                         forKey:@"48v"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap getInverted]]
                         forKey:@"inverted"];
            //噪声门
            [proxyDic setObject:vap._zaoshengFazhi forKey:@"noise_gate_threshold"];
            [proxyDic setObject:vap._zaoshengStartTime forKey:@"noise_gate_start_time"];
            [proxyDic setObject:vap._zaoshengHuifuTime forKey:@"noise_gate_recover_time"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._isZaoshengStarted] forKey:@"is_noise_gate_start"];
            
            //滤波均衡
            //高通
            [proxyDic setObject:vap._lvbojunhengGaotongType forKey:@"high_filter_type"];
            [proxyDic setObject:vap._lvbojunhengGaotongXielv forKey:@"high_filter_sl"];
            [proxyDic setObject:vap._lvboGaotongPinLv forKey:@"high_filter_rate"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._islvboGaotongStart] forKey:@"high_filter_start"];
            //低通
            [proxyDic setObject:vap._lvbojunhengDitongType forKey:@"low_filter_type"];
            [proxyDic setObject:vap._lvboDitongSL forKey:@"low_filter_sl"];
            [proxyDic setObject:vap._lvboDitongFreq forKey:@"low_filter_rate"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._islvboDitongStart] forKey:@"low_filter_start"];
            //PEQ
            [proxyDic setObject:vap.waves16_feq_gain_q forKey:@"peq_band"];
            
            //压限器
            [proxyDic setObject:vap._yaxianFazhi forKey:@"press_limit_th"];
            [proxyDic setObject:vap._yaxianXielv forKey:@"press_limit_sl"];
            [proxyDic setObject:vap._yaxianStartTime forKey:@"press_limit_start_time"];
            [proxyDic setObject:vap._yaxianRecoveryTime forKey:@"press_limit_recover_time"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._isyaxianStart] forKey:@"press_limit_start"];
            
            //延时器
            [proxyDic setObject:vap._yanshiqiSlide forKey:@"delay_time"];
            
            //Echo
            [proxyDic setObject:[NSNumber numberWithBool:_isHuiShengXiaoChu] forKey:@"audio_processor_echo_started"];
            
            //自动混音
            [proxyDic setObject:_autoMixProxy._zidonghunyinZengYi forKey:@"auto_mix_sl"];
            [proxyDic setObject:_autoMixProxy._inputMap forKey:@"auto_mix_input"];
            [proxyDic setObject:_autoMixProxy._outputMap forKey:@"auto_mix_output"];
            
            //反馈抑制
            [proxyDic setObject:[NSNumber numberWithBool:vap._isFanKuiYiZhiStarted] forKey:@"audio_processor_fb_started"];
            
            
            [proxyDic setObject:[vap getScenarioSliceLocatedShadow]
                         forKey:@"RgsSceneDeviceOperation"];
        }
        
        [allData setObject:proxys forKey:@"in_audio_proxys"];
        
    }
    
    if(_outAudioProxys)
    {
        NSMutableArray *proxys = [NSMutableArray array];
        
        for(VAProcessorProxys *vap in _outAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            
            NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
            [proxys addObject:proxyDic];
            
            if(vap._icon_name)
            {
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
            }
            
            //电平
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id]
                         forKey:@"proxy_id"];
            
            [proxyDic setObject:proxy.name
                         forKey:@"proxy_name"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getAnalogyGain]]
                         forKey:@"analogy_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyMute]]
                         forKey:@"analogy_mute"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getDigitalGain]]
                         forKey:@"digital_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyDigitalMute]]
                         forKey:@"digital_mute"];
            
            [proxyDic setObject:vap._mode forKey:@"mode"];
            
            [proxyDic setObject:vap._micDb forKey:@"mic_db"];
            
            [proxyDic setObject:[NSNumber numberWithBool:vap._is48V]
                         forKey:@"48v"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap getInverted]]
                         forKey:@"inverted"];
            
            [proxyDic setObject:[vap getScenarioSliceLocatedShadow]
                         forKey:@"RgsSceneDeviceOperation"];
            
            //信号发生器
            [proxyDic setObject:_singalProxy._xinhaofashengPinlv forKey:@"audio_out_signal_freq"];
            [proxyDic setObject:_singalProxy._xinhaofashengZhengxuan forKey:@"audio_out_signal_zhengxuan"];
            [proxyDic setObject:_singalProxy._xinhaofashengZengYi forKey:@"audio_out_signal_sl"];
            [proxyDic setObject:[NSNumber numberWithBool:_singalProxy._isXinhaofashengMute] forKey:@"audio_out_signal_started"];
            [proxyDic setObject:_singalProxy._xinhaofashengOutputChanels forKey:@"audio_out_signal_output"];
            
            //高通
            [proxyDic setObject:vap._lvbojunhengGaotongType forKey:@"high_filter_type"];
            [proxyDic setObject:vap._lvbojunhengGaotongXielv forKey:@"high_filter_sl"];
            [proxyDic setObject:vap._lvboGaotongPinLv forKey:@"high_filter_rate"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._islvboGaotongStart] forKey:@"high_filter_start"];
            //低通
            [proxyDic setObject:vap._lvbojunhengDitongType forKey:@"low_filter_type"];
            [proxyDic setObject:vap._lvboDitongSL forKey:@"low_filter_sl"];
            [proxyDic setObject:vap._lvboDitongFreq forKey:@"low_filter_rate"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._islvboDitongStart] forKey:@"low_filter_start"];
            //PEQ
            [proxyDic setObject:vap.waves16_feq_gain_q forKey:@"peq_band"];
            
            //压限器
            [proxyDic setObject:vap._yaxianFazhi forKey:@"press_limit_th"];
            [proxyDic setObject:vap._yaxianXielv forKey:@"press_limit_sl"];
            [proxyDic setObject:vap._yaxianStartTime forKey:@"press_limit_start_time"];
            [proxyDic setObject:vap._yaxianRecoveryTime forKey:@"press_limit_recover_time"];
            [proxyDic setObject:[NSNumber numberWithBool:vap._isyaxianStart] forKey:@"press_limit_start"];
            
            //延时器
            [proxyDic setObject:vap._yanshiqiSlide forKey:@"delay_time"];
            
        }
        
        [allData setObject:proxys forKey:@"out_audio_proxys"];
        
    }
    
    
    return allData;
}

- (void) jsonToObject:(NSDictionary*)json{
    
    //基本信息
    if([json objectForKey:@"name"])
        self._name = [json objectForKey:@"name"];
    
    if([json objectForKey:@"brand"])
        self._brand = [json objectForKey:@"brand"];
    
    if([json objectForKey:@"type"])
        self._type = [json objectForKey:@"type"];
    
    if([json objectForKey:@"deviceno"])
        self._deviceno = [json objectForKey:@"deviceno"];
    
    if([json objectForKey:@"ipaddress"])
        self._ipaddress = [json objectForKey:@"ipaddress"];
    
    if([json objectForKey:@"deviceid"])
        self._deviceid = [json objectForKey:@"deviceid"];
    
    if([json objectForKey:@"driverUUID"])
        self._driverUUID = [json objectForKey:@"driverUUID"];
    
    if([json objectForKey:@"com"])
        self._comIdx = [[json objectForKey:@"com"] intValue];
    
    self._index = [[json objectForKey:@"index"] intValue];
    
    RgsDriverInfo *drinfo = [[RgsDriverInfo alloc] init];
    drinfo.serial = [json objectForKey:@"driver_info_uuid"];
    self._driverInfo = drinfo;
    
    RgsDriverObj *dr = [[RgsDriverObj alloc] init];
    dr.m_id = [[json objectForKey:@"driver_id"] integerValue];
    dr.name = [json objectForKey:@"driver_name"];
    self._driver = dr;
    
    self._inchannels = [json objectForKey:@"in_audio_proxys"];
    self._outchannels = [json objectForKey:@"out_audio_proxys"];
    
    self._inAudioProxys = [NSMutableArray array];
    for(NSDictionary *dic in _inchannels)
    {
        
        RgsProxyObj *proxObj = [[RgsProxyObj alloc] init];
        proxObj.m_id = [[dic objectForKey:@"proxy_id"] integerValue];
        proxObj.name = [dic objectForKey:@"proxy_name"];
        
        VAProcessorProxys *proxys = [[VAProcessorProxys alloc] init];
        proxys._rgsProxyObj = proxObj;
        
        proxys._icon_name = [dic objectForKey:@"icon_name"];
        
        //增益
        proxys._voiceDb = [[dic objectForKey:@"analogy_gain"] floatValue];
        proxys._isMute = [[dic objectForKey:@"analogy_mute"] boolValue];
        proxys._digitalGain = [[dic objectForKey:@"digital_gain"] floatValue];
        proxys._isDigitalMute = [[dic objectForKey:@"digital_mute"] boolValue];
        proxys._mode = [dic objectForKey:@"mode"];
        proxys._micDb = [dic objectForKey:@"mic_db"];
        proxys._is48V = [[dic objectForKey:@"48v"] boolValue];
        proxys._inverted = [[dic objectForKey:@"inverted"] boolValue];
        
        //噪声门
        proxys._zaoshengFazhi = [dic objectForKey:@"noise_gate_threshold"];
        proxys._zaoshengStartTime = [dic objectForKey:@"noise_gate_start_time"];
        proxys._zaoshengHuifuTime = [dic objectForKey:@"noise_gate_recover_time"];
        proxys._isZaoshengStarted = [[dic objectForKey:@"is_noise_gate_start"] boolValue];
        
        //滤波均衡
        //高通
        proxys._lvbojunhengGaotongType = [dic objectForKey:@"high_filter_type"];
        proxys._lvbojunhengGaotongXielv = [dic objectForKey:@"high_filter_sl"];
        proxys._lvboGaotongPinLv = [dic objectForKey:@"high_filter_rate"];
        proxys._islvboGaotongStart = [[dic objectForKey:@"high_filter_start"] boolValue];
        //低通
        proxys._lvbojunhengDitongType = [dic objectForKey:@"low_filter_type"];
        proxys._lvboDitongSL = [dic objectForKey:@"low_filter_sl"];
        proxys._lvboDitongFreq = [dic objectForKey:@"low_filter_rate"];
        proxys._islvboDitongStart = [[dic objectForKey:@"low_filter_start"] boolValue];
        //PEQ
        proxys.waves16_feq_gain_q = [dic objectForKey:@"peq_band"];
        
        //压限器
        proxys._yaxianFazhi = [dic objectForKey:@"press_limit_th"];
        proxys._yaxianXielv = [dic objectForKey:@"press_limit_sl"];
        proxys._yaxianStartTime = [dic objectForKey:@"press_limit_start_time"];
        proxys._yaxianRecoveryTime = [dic objectForKey:@"press_limit_recover_time"];
        proxys._isyaxianStart = [[dic objectForKey:@"press_limit_start"] boolValue];
        
        //延时器
        proxys._yanshiqiSlide = [dic objectForKey:@"delay_time"];
        
        //Echo
        self._isHuiShengXiaoChu = [[dic objectForKey:@"audio_processor_echo_started"] boolValue];
        
        //自动混音
        AudioEProcessorAutoMixProxy *audioProxy = [[AudioEProcessorAutoMixProxy alloc] init];
        self._autoMixProxy = audioProxy;
        
        audioProxy._zidonghunyinZengYi = [dic objectForKey:@"auto_mix_sl"];
        audioProxy._inputMap = [dic objectForKey:@"auto_mix_input"];
        audioProxy._outputMap = [dic objectForKey:@"auto_mix_output"];
        
        //反馈抑制
        proxys._isFanKuiYiZhiStarted = [[dic objectForKey:@"audio_processor_fb_started"] boolValue];
        
        [proxys recoverWithDictionary:dic];
        [_inAudioProxys addObject:proxys];
    }
    self._outAudioProxys = [NSMutableArray array];
    for(NSDictionary *dic in _outchannels)
    {
        RgsProxyObj *proxyObj = [[RgsProxyObj alloc] init];
        proxyObj.m_id = [[dic objectForKey:@"proxy_id"] integerValue];
        proxyObj.name = [dic objectForKey:@"proxy_name"];
        
        VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
        vap._rgsProxyObj = proxyObj;
        
        
        vap._icon_name = [dic objectForKey:@"icon_name"];
        
        //增益
        vap._voiceDb = [[dic objectForKey:@"analogy_gain"] floatValue];
        vap._isMute = [[dic objectForKey:@"analogy_mute"] boolValue];
        vap._digitalGain = [[dic objectForKey:@"digital_gain"] floatValue];
        vap._isDigitalMute = [[dic objectForKey:@"digital_mute"] boolValue];
        vap._mode = [dic objectForKey:@"mode"];
        vap._micDb = [dic objectForKey:@"mic_db"];
        vap._is48V = [[dic objectForKey:@"48v"] boolValue];
        vap._inverted = [[dic objectForKey:@"inverted"] boolValue];
        
        //信号发生器
        AudioEProcessorSignalProxy *signalProxy = [[AudioEProcessorSignalProxy alloc] init];
        self._singalProxy = signalProxy;
        
        signalProxy._xinhaofashengPinlv = [dic objectForKey:@"audio_out_signal_freq"];
        signalProxy._xinhaofashengZhengxuan = [dic objectForKey:@"audio_out_signal_zhengxuan"];
        signalProxy._xinhaofashengZengYi = [dic objectForKey:@"audio_out_signal_sl"];
        signalProxy._isXinhaofashengMute = [[dic objectForKey:@"audio_out_signal_started"] boolValue];
        signalProxy._xinhaofashengOutputChanels = [dic objectForKey:@"audio_out_signal_output"];
        
        //高通
        vap._lvbojunhengGaotongType = [dic objectForKey:@"high_filter_type"];
        vap._lvbojunhengGaotongXielv = [dic objectForKey:@"high_filter_sl"];
        vap._lvboGaotongPinLv = [dic objectForKey:@"high_filter_rate"];
        vap._islvboGaotongStart = [[dic objectForKey:@"high_filter_start"] boolValue];
        //低通
        
        vap._lvbojunhengDitongType = [dic objectForKey:@"low_filter_type"];
        vap._lvboDitongSL = [dic objectForKey:@"low_filter_sl"];
        vap._lvboDitongFreq = [dic objectForKey:@"low_filter_rate"];
        vap._islvboDitongStart = [[dic objectForKey:@"low_filter_start"] boolValue];
        //PEQ
        vap.waves16_feq_gain_q = [dic objectForKey:@"peq_band"];
        
        //压限器
        vap._yaxianFazhi = [dic objectForKey:@"press_limit_th"];
        vap._yaxianXielv = [dic objectForKey:@"press_limit_sl"];
        vap._yaxianStartTime = [dic objectForKey:@"press_limit_start_time"];
        vap._yaxianRecoveryTime = [dic objectForKey:@"press_limit_recover_time"];
        vap._isyaxianStart = [[dic objectForKey:@"press_limit_start"] boolValue];
        
        //延时器
        vap._yanshiqiSlide = [dic objectForKey:@"delay_time"];
        
        [vap recoverWithDictionary:dic];
        [_outAudioProxys addObject:vap];
    }
    
    //Echo
    //反馈抑制
    
}

- (NSDictionary *)userData{
    
    self.config = [NSMutableDictionary dictionary];
    [config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
    }
    
    if(_inAudioProxys)
    {
        NSMutableDictionary *proxysMapRef = [NSMutableDictionary dictionary];
        
        for(VAProcessorProxys *vap in _inAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            if(vap._icon_name && vap._voiceInDevice)
            {
                NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
                
                [proxyDic setObject:vap._voiceInDevice
                             forKey:@"voiceInDevice"];
                //增益
                [proxysMapRef setObject:proxyDic
                             forKey:[NSString stringWithFormat:@"%d",proxy.m_id]];
            }
        }
        
        if([proxysMapRef count])
            [config setObject:proxysMapRef forKey:@"in_audio_proxys"];
    }
    
    return config;
}



- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[config objectForKey:@"driver_id"] intValue];
    
    IMP_BLOCK_SELF(AudioEProcessor);
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
 
    IMP_BLOCK_SELF(AudioEProcessor);
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
        if (result) {
            if ([proxys count]) {
                [block_self prepareInOutChannels:proxys];
            }
        }
        
    }];
}

- (void) prepareInOutChannels:(NSArray*)proxys{
    
    self._inAudioProxys = [NSMutableArray array];
    self._outAudioProxys = [NSMutableArray array];
    
    NSDictionary *mapRef = [config objectForKey:@"in_audio_proxys"];
    
    NSDictionary *map = [config objectForKey:@"opt_value_map"];

    for(RgsProxyObj *proxy in proxys)
    {
        
        id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
        
        if([proxy.type isEqualToString:@"Audio In"])
        {
            VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSDictionary *ref = [mapRef objectForKey:key];
            if(ref)
            {
                vap._icon_name = [ref objectForKey:@"icon_name"];
                vap._voiceInDevice = [ref objectForKey:@"voiceInDevice"];
            }
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            [_inAudioProxys addObject:vap];
    
        }
        else if([proxy.type isEqualToString:@"Audio Out"])
        {
            VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            [_outAudioProxys addObject:vap];
        }
        else if ([proxy.type isEqualToString:@"Audio Signal"])
        {
            AudioEProcessorSignalProxy *vap = [[AudioEProcessorSignalProxy alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];

            self._singalProxy = vap;
        }
        else if ([proxy.type isEqualToString:@"Audio AutoMix"]) {
            
            AudioEProcessorAutoMixProxy *vap = [[AudioEProcessorAutoMixProxy alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            self._autoMixProxy = vap;
        }
    }
    
    _isSetOK = YES;
}

@end
