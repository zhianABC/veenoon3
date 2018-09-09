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

@interface UserDeviceStateViewController () {
    UIButton *btnDevice;
    UIButton *btnEnv;
    UIButton *btnMonitor;
    
    UserDeviceStateView *_deviceStateView;
    UserEnvStateView *_envStateView;
    UserMonitorStateView *_monitorStateView;
}

@end

@implementation UserDeviceStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    btnDevice = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDevice.frame = CGRectMake(60, SCREEN_HEIGHT - 50, 60, 50);
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_s.png"]
                 forState:UIControlStateNormal];
    [btnDevice setImage:[UIImage imageNamed:@"user_state_device_s.png"]
                 forState:UIControlStateHighlighted];
    [self.view addSubview:btnDevice];
    btnDevice.center = CGPointMake(150, btnDevice.center.y);
    [btnDevice addTarget:self
                    action:@selector(btnDeviceAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    btnEnv = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnv.frame = CGRectMake(60, SCREEN_HEIGHT - 50, 60, 50);
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
    btnMonitor.frame = CGRectMake(SCREEN_WIDTH-150, SCREEN_HEIGHT - 50, 60, 50);
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_n.png"]
             forState:UIControlStateNormal];
    [btnMonitor setImage:[UIImage imageNamed:@"user_state_monitor_s.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnMonitor];
    btnMonitor.center = CGPointMake(SCREEN_WIDTH-150, btnMonitor.center.y);
    [btnMonitor addTarget:self
                action:@selector(btnMonitorAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *deviceDataArray = [self getDeviceDataArray];
    
}
- (NSMutableArray*) getDeviceDataArray{
    NSMutableArray *deviceDataArray = [NSMutableArray array];
    
    [deviceDataArray addObject:[NSMutableArray array]];
    [deviceDataArray addObject:[NSMutableArray array]];
    [deviceDataArray addObject:[NSMutableArray array]];
    [deviceDataArray addObject:[NSMutableArray array]];
    [deviceDataArray addObject:[NSMutableArray array]];
    
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
             
             NSMutableArray *currentDrivers = [[DataSync sharedDataSync] getCurrentDrivers];
             
             [[RegulusSDK sharedRegulusSDK] GetProxysCurState:proxy_ids completion:^(BOOL result, NSArray *state_list, NSError *error) {
                 if (result)
                 {
                     for (int i = 0 ;i < [state_list count]; i++) {
                         RgsProxyObj *proxy_obj = [proxys objectAtIndex:i];
                         RgsDriverInfo *driverInforObj = nil;
                         for (RgsDriverObj *driverIn in currentDrivers) {
                             RgsDriverInfo *driverInfo = driverIn.info;
                             if (driverIn.m_id == proxy_obj.m_id) {
                                 driverInforObj = driverInfo;
                                 break;
                             }
                         }
                         
                         if (driverInforObj) {
                             NSString *system_in = driverInforObj.system;
                             NSMutableArray *cellDataArray;
                             if ([@"Audio System" isEqualToString:system_in]) {
                                 cellDataArray = [deviceDataArray objectAtIndex:0];
                             } else if ([@"Video System" isEqualToString:system_in]) {
                                 cellDataArray = [deviceDataArray objectAtIndex:1];
                             } else if ([@"Environment System" isEqualToString:system_in]) {
                                 cellDataArray = [deviceDataArray objectAtIndex:2];
                             } else if ([@"Sensor" isEqualToString:system_in]) {
                                 cellDataArray = [deviceDataArray objectAtIndex:3];
                             } else if ([@"Other" isEqualToString:system_in]) {
                                 cellDataArray = [deviceDataArray objectAtIndex:4];
                             }
                             NSDictionary *stateDic = [state_list objectAtIndex:i];
                             
                             NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                             if (cellDataArray) {
                                 [dataDic setObject:driverInforObj forKey:@"driverinfo"];
                                 [dataDic setObject:[stateDic objectForKey:@"ONLINE"] forKey:@"state"];
                             }
                         }
                     }
                 }
             }];
         }
     }];
    
    return deviceDataArray;
}

- (void) btnDeviceAction:(id)sender {
    
}

- (void) btnEnvAction:(id)sender {
    
}

- (void) btnMonitorAction:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
