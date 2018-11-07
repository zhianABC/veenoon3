//
//  UserDeviceStateViewController.m
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserDeviceStateViewController.h"
#import "UserDeviceStateView.h"
#import "UserEnvStateView.h"
#import "UserMonitorStateView.h"
#import "RegulusSDK.h"
#import "DataCenter.h"
#import "DataSync.h"
#import "UserSensorObj.h"

@interface UserDeviceStateViewController () {
    UIButton *btnDevice;
    UIButton *btnEnv;
    UIButton *btnMonitor;
    
    UserDeviceStateView *_deviceStateView;
    UserEnvStateView *_envStateView;
    UserMonitorStateView *_monitorStateView;
    
    BOOL deviceLoad;
    BOOL envLoad;
    BOOL monitorLoad;
    
    NSMutableArray *_deviceDataArray;
    NSMutableArray *_envDataArray;
    NSMutableArray *_monitorDataArray;
}

@end

@implementation UserDeviceStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    deviceLoad = NO;
    envLoad = NO;
    monitorLoad = NO;
    
    _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topBar.backgroundColor = USER_GRAY_COLOR;
    [self.view addSubview:_topBar];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设备监测";
    [_topBar addSubview:titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, 40, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    btnDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDevice.frame = CGRectMake(110, SCREEN_HEIGHT - 50, 120, 50);
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_s.png"]
                 forState:UIControlStateNormal];
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_s.png"]
                 forState:UIControlStateHighlighted];
    [self.view addSubview:btnDevice];
    
    btnDevice.center = CGPointMake(110, btnDevice.center.y);
    [btnDevice addTarget:self
                    action:@selector(btnDeviceAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    btnEnv = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnv.frame = CGRectMake(80, SCREEN_HEIGHT - 50, 120, 50);
    [btnEnv setImage:[UIImage imageNamed:@"user_state_env_n.png"]
            forState:UIControlStateNormal];
    [btnEnv setImage:[UIImage imageNamed:@"user_state_env_s.png"]
            forState:UIControlStateHighlighted];
    [self.view addSubview:btnEnv];
    btnEnv.center = CGPointMake(SCREEN_WIDTH/2, btnEnv.center.y);
    [btnEnv addTarget:self
               action:@selector(btnEnvAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    btnMonitor = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMonitor.frame = CGRectMake(SCREEN_WIDTH-110, SCREEN_HEIGHT - 50, 120, 50);
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_n.png"]
             forState:UIControlStateNormal];
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_s.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnMonitor];
    btnMonitor.center = CGPointMake(SCREEN_WIDTH-110, btnMonitor.center.y);
    [btnMonitor addTarget:self
                action:@selector(btnMonitorAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [self getDeviceDataArray];
    
    [self getEnvDataArray];
    
    [self getMonitorDataArray];
}

- (void) createViews {
    CGRect vrc = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50);
    if (deviceLoad && _deviceStateView == nil) {
        _deviceStateView = [[UserDeviceStateView alloc] initWithFrame:vrc withData:_deviceDataArray];
        [self.view addSubview:_deviceStateView];
        _deviceStateView.hidden = NO;
    }
    
    if (_envStateView == nil && [_envDataArray count]) {
        _envStateView = [[UserEnvStateView alloc] initWithFrame:vrc withData:_envDataArray];
        [self.view addSubview:_envStateView];
        _envStateView.hidden = YES;
    }
    
    if (monitorLoad && _monitorStateView == nil) {
        _monitorStateView = [[UserMonitorStateView alloc] initWithFrame:vrc withData:_monitorDataArray];
        [self.view addSubview:_monitorStateView];
        _monitorStateView.hidden = YES;
    }
}

- (void) getMonitorDataArray {
    if (_monitorDataArray) {
        [_monitorDataArray removeAllObjects];
    } else {
        _monitorDataArray = [NSMutableArray array];
    }
    [_monitorDataArray addObject:[NSMutableArray array]];
    
    monitorLoad = YES;
    
    [self createViews];
}

- (void) getEnvDataArray {
    if (_envDataArray) {
        [_envDataArray removeAllObjects];
    } else {
        _envDataArray = [NSMutableArray array];
    }
    
    RgsAreaObj *areaObj = [DataSync sharedDataSync]._currentArea;
    NSInteger area_id = areaObj.m_id;
    
    NSMutableArray *sensorArray = [NSMutableArray array];
    
    IMP_BLOCK_SELF(UserDeviceStateViewController);
    
    [[RegulusSDK sharedRegulusSDK] GetDrivers:area_id
                                   completion:^(BOOL result,NSArray * drivers,NSError * error) {
                                       if (result) {
                                           for (RgsDriverObj *driverObj in drivers) {
                                               if ([@"Sensor" isEqualToString:driverObj.info.system]) {
                                                   [sensorArray addObject:driverObj];
                                               }
                                           }
                                           
                                           
                                           [block_self getDriverConnection:sensorArray];
                                       }
                                   }];
}
- (void) getDriverConnection:(NSMutableArray*)driverArray {
    
    for (RgsDriverObj *driverObj in driverArray) {
    
        UserSensorObj *userSensor = [[UserSensorObj alloc] init];
        userSensor.rgsDriverObj = driverObj;
        [_envDataArray addObject:userSensor];
    }

    [self createViews];
    
    
}

- (void) getDeviceDataArray{
    if (_deviceDataArray) {
        [_deviceDataArray removeAllObjects];
    } else {
        _deviceDataArray = [NSMutableArray array];
    }
    [_deviceDataArray addObject:[NSMutableArray array]];
    [_deviceDataArray addObject:[NSMutableArray array]];
    [_deviceDataArray addObject:[NSMutableArray array]];
    [_deviceDataArray addObject:[NSMutableArray array]];
    [_deviceDataArray addObject:[NSMutableArray array]];
    
    [[RegulusSDK sharedRegulusSDK]GetProxysByType:@"Online" completion:^(BOOL result, NSArray *proxys, NSError *error)
     {
         if (result)
         {
             NSMutableArray *proxy_ids = [NSMutableArray array];
             NSMutableArray *proxy = [NSMutableArray array];
             NSMutableArray *driverIDs = [NSMutableArray array];
             
             for (RgsProxyObj * proxy_obj in proxys)
             {
                 [proxy_ids addObject:[NSNumber numberWithInteger:proxy_obj.m_id]];
                 [proxy addObject:proxy_obj];
                 [driverIDs addObject:[NSNumber numberWithInteger:proxy_obj.driver_id]];
             }
             
             NSArray *currentDrivers = [[DataSync sharedDataSync] getCurrentDrivers];
             NSMutableDictionary *mapDrivers = [[DataCenter defaultDataCenter] getAllDrivers];
             
             [[RegulusSDK sharedRegulusSDK] GetProxysCurState:proxy_ids completion:^(BOOL result, NSArray *state_list, NSError *error) {
                 if (result)
                 {
                     for (int i = 0 ;i < [state_list count]; i++) {
                         RgsProxyObj *proxy_obj = [proxys objectAtIndex:i];
                         RgsDriverInfo *driverInforObj = nil;
                         for (RgsDriverObj *driverIn in currentDrivers) {
                             RgsDriverInfo *driverInfo = driverIn.info;
                             if (driverIn.m_id == proxy_obj.driver_id) {
                                 driverInforObj = driverInfo;
                                 break;
                             }
                         }
                         
                         if (driverInforObj) {
                             NSString *system_in = driverInforObj.system;
                             NSMutableArray *cellDataArray;
                             NSString *uuID = driverInforObj.serial;
                             
                             if ([@"Audio System" isEqualToString:system_in]) {
                                 cellDataArray = [_deviceDataArray objectAtIndex:0];
                             } else if ([@"Video System" isEqualToString:system_in]) {
                                 cellDataArray = [_deviceDataArray objectAtIndex:1];
                             } else if ([@"Environment System" isEqualToString:system_in]) {
                                 cellDataArray = [_deviceDataArray objectAtIndex:2];
                             } else if ([@"Sensor" isEqualToString:system_in]) {
                                 cellDataArray = [_deviceDataArray objectAtIndex:3];
                             } else if ([@"Other" isEqualToString:system_in]) {
                                 cellDataArray = [_deviceDataArray objectAtIndex:4];
                             }
                             NSDictionary *stateDic = [state_list objectAtIndex:i];
                             
                             NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                             if (cellDataArray) {
                                 NSDictionary *driverDic = [mapDrivers objectForKey:uuID];
                                 [dataDic setObject:[driverDic objectForKey:@"icon"] forKey:@"icon"];
                                 [dataDic setObject:driverInforObj forKey:@"driverinfo"];
                                 [dataDic setObject:[stateDic objectForKey:@"ONLINE"] forKey:@"state"];
                                 
                                 [cellDataArray addObject:dataDic];
                             }
                         }
                     }
                 }
                 deviceLoad = YES;
                [self createViews];
             }];
         }
     }];
    
   
}

- (void) btnDeviceAction:(id)sender {
    
    titleLabel.text = @"设备监测";
    
    _deviceStateView.hidden = NO;
    _envStateView.hidden = YES;
    _monitorStateView.hidden = YES;
    
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_s.png"]
               forState:UIControlStateNormal];
    [btnEnv setImage:[UIImage imageNamed:@"user_state_env_n.png"]
            forState:UIControlStateNormal];
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_n.png"]
                forState:UIControlStateNormal];
}

- (void) btnEnvAction:(id)sender {
    
    titleLabel.text = @"环境监测";
    
    _deviceStateView.hidden = YES;
    _envStateView.hidden = NO;
    _monitorStateView.hidden = YES;
    
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_n.png"]
               forState:UIControlStateNormal];
    [btnEnv setImage:[UIImage imageNamed:@"user_state_env_s.png"]
            forState:UIControlStateNormal];
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_n.png"]
                forState:UIControlStateNormal];
}

- (void) btnMonitorAction:(id)sender {
    
    titleLabel.text = @"视频监测";
    
    _deviceStateView.hidden = YES;
    _envStateView.hidden = YES;
    _monitorStateView.hidden = NO;
    
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_n.png"]
               forState:UIControlStateNormal];
    [btnEnv setImage:[UIImage imageNamed:@"user_state_env_n.png"]
            forState:UIControlStateNormal];
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_s.png"]
                forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
