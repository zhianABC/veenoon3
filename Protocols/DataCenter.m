//
//  DataCenter.m
//  cntvForiPhone
//
//  Created by Jack on 12/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCenter.h"
#import "Scenario.h"
#import "DataBase.h"

static DataCenter *_globalDataInstanse;


@implementation DataCenter

@synthesize _selectedDevice;
@synthesize _roomData;
@synthesize _scenario;
@synthesize _mapDrivers;


+ (DataCenter*)defaultDataCenter{
	
	if(_globalDataInstanse == nil){
		_globalDataInstanse = [[DataCenter alloc] init];
	}
	return _globalDataInstanse;
}

- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    NSDictionary *all = [[NSUserDefaults standardUserDefaults] objectForKey:@"all_drivers"];
    if(all)
    {
        [self._mapDrivers setDictionary:all];
    }
    else
    {
    
        NSDictionary *audioDic = @{@"type":@"audio",
                                   @"name":@"音频处理器",
                                   @"driver":UUID_Audio_Processor,
                                   @"brand":@"Teslaria",
                                   @"icon":@"engineer_yinpinchuli_n.png",
                                   @"icon_s":@"engineer_yinpinchuli_s.png",
                                   @"driver_class":@"AudioEProcessor",
                                   @"ptype":@"Audio Processor"
                                   };
        
        [_mapDrivers setObject:audioDic forKey:UUID_Audio_Processor];
        
        NSDictionary *camera = @{@"type":@"video",
                                 @"name":@"摄像机",
                                 @"driver":UUID_NetCamera,
                                 @"brand":@"Teslaria",
                                 @"icon":@"engineer_video_shexiangji_n.png",
                                 @"icon_s":@"engineer_video_shexiangji_s.png",
                                 @"driver_class":@"VCameraSettingSet",
                                 @"ptype":@"Camera"
                                 };
        [_mapDrivers setObject:camera forKey:UUID_NetCamera];
        
        NSDictionary *pdvd = @{@"type":@"video",
                               @"name":@"Philips DVD",
                               @"driver":UUID_Philips_DVD,
                               @"brand":@"Philips",
                               @"icon":@"engineer_video_dvd_n.png",
                               @"icon_s":@"engineer_video_dvd_s.png",
                               @"driver_class":@"VDVDPlayerSet",
                               @"ptype":@"DVD"
                               };
        [_mapDrivers setObject:pdvd forKey:UUID_Philips_DVD];
        
        NSDictionary *ty = @{@"type":@"video",
                             @"name":@"投影机",
                             @"driver":UUID_CANON_WUX450,
                             @"brand":@"Canon",
                             @"icon":@"engineer_video_touyingji_n.png",
                             @"icon_s":@"engineer_video_touyingji_s.png",
                             @"driver_class":@"VTouyingjiSet",
                             @"ptype":@"WUX450"
                             };
        [_mapDrivers setObject:ty forKey:UUID_CANON_WUX450];
        
        NSDictionary *light = @{@"type":@"env",
                                @"name":@"照明",
                                @"driver":UUID_6CH_Dimmer_Light,
                                @"brand":@"Teslaria",
                                @"icon":@"engineer_env_zhaoming_n.png",
                                @"icon_s":@"engineer_env_zhaoming_s.png",
                                @"driver_class":@"EDimmerLight",
                                @"ptype":@"6 CH Dimmer Light"
                                };
        
        [_mapDrivers setObject:light forKey:UUID_6CH_Dimmer_Light];
        
        NSDictionary *com = @{@"type":@"other",
                              @"name":@"串口服务器",
                              @"driver":UUID_Serial_Com,
                              @"brand":@"Teslaria",
                              @"icon":@"engineer_video_xinxihe_n.png",
                              @"icon_s":@"engineer_video_xinxihe_s.png",
                              @"driver_class":@"ComDriver",
                              @"ptype":@"Com"
                              };
        
        [_mapDrivers setObject:com forKey:UUID_Serial_Com];
        
        
        NSDictionary *audiMixer = @{@"type":@"audio",
                                    @"name":@"会议",
                                    @"driver":UUID_Audio_Mixer,
                                    @"brand":@"Teslaria",
                                    @"icon":@"engineer_huiyi_n.png",
                                    @"icon_s":@"engineer_huiyi_s.png",
                                    @"driver_class":@"AudioEMix",
                                    @"ptype":@"Audio Mixer"
                                    };
        [_mapDrivers setObject:audiMixer forKey:UUID_Audio_Mixer];
        
        NSDictionary *ir = @{@"type":@"other",
                             @"name":@"Regulus IR Sender",
                             @"driver":UUID_IR_Sender,
                             @"brand":@"Teslaria",
                             @"icon":@"hongwaishebei_n.png",
                             @"icon_s":@"hongwaishebei_s.png",
                             @"driver_class":@"IRDirver",
                             @"ptype":@"IR"
                             };
        
        [_mapDrivers setObject:ir forKey:UUID_IR_Sender];
        
        NSDictionary *videoSwitch = @{@"type":@"video",
                                      @"name":@"Teslaria Video Switch",
                                      @"driver":UUID_Video_Switch,
                                      @"brand":@"Teslaria",
                                      @"icon":@"engineer_video_shipinchuli_n.png",
                                      @"icon_s":@"engineer_video_shipinchuli_s.png",
                                      @"driver_class":@"VVideoProcessSet",
                                      @"ptype":@"Video Switch"
                                      };
        
        [_mapDrivers setObject:videoSwitch forKey:UUID_Video_Switch];
        
        NSDictionary *greeac = @{@"type":@"env",
                                 @"name":@"空调",
                                 @"driver":UUID_Gree_AC,
                                 @"brand":@"Gree",
                                 @"icon":@"engineer_env_kongtiao_n.png",
                                 @"icon_s":@"engineer_env_kongtiao_s.png",
                                 @"driver_class":@"AirConditionPlug",
                                 @"ptype":@"Gree AC"
                                 };
        
        [_mapDrivers setObject:greeac forKey:UUID_Gree_AC];
        
        
        NSDictionary *light8sch = @{@"type":@"env",
                                 @"name":@"开关照明",
                                 @"driver":UUID_8CH_Dimmer_Light,
                                 @"brand":@"Teslaria",
                                 @"icon":@"engineer_env_zhaoming_n.png",
                                 @"icon_s":@"engineer_env_zhaoming_s.png",
                                 @"driver_class":@"EDimmerSwitchLight",
                                 @"ptype":@"Dimmer Switch"
                                 };
        
        [_mapDrivers setObject:light8sch forKey:UUID_8CH_Dimmer_Light];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:_mapDrivers forKey:@"all_drivers"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }

}

- (NSArray*) driversWithType:(NSString*)type{
    
    NSMutableArray *results = [NSMutableArray array];
    
    for(NSDictionary *dr in [_mapDrivers allValues])
    {
        NSString *tpe = [dr objectForKey:@"type"];
        if([tpe isEqualToString:type])
        {
            [results addObject:dr];
        }
    }
    
    return results;
    
}

- (void) saveDriver:(NSDictionary *)driver{
    
    NSString *key = [driver objectForKey:@"driver"];
    [_mapDrivers setObject:driver forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:_mapDrivers forKey:@"all_drivers"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSDictionary *)driverWithKey:(NSString *)key{
    
    
    return [_mapDrivers objectForKey:key];
    
}


- (void) cacheScenarioOnLocalDB{
    
    if(_scenario)
    {
        NSDictionary *sdata = [_scenario senarioData];
        [[DataBase sharedDatabaseInstance] saveScenario:sdata];
    }
}

- (void)dealloc{
    
  
}
@end
