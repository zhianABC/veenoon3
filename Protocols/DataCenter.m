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
