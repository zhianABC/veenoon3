//
//  EngineerPresetScenarioViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/12.
//  Copyright © 2017年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@class Scenario;

@interface EngineerPresetScenarioViewCtrl : BaseViewController {
    NSMutableDictionary *_meetingRoomDic;
    NSString *_scenarioName;
    
    NSMutableDictionary *_curScenario;
}
@property (nonatomic,strong) NSMutableDictionary *_meetingRoomDic;
@property (nonatomic, strong) NSDictionary *_selectedDevices;

@property (nonatomic,strong) NSString *_scenarioName;

@property (nonatomic, strong) Scenario *_scenario;

@end
