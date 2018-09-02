//
//  WellcomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerSysSelectViewCtrl.h"
#import "UIButton+Color.h"
#import "EngineerPortSettingView.h"
#import "EngineerDNSSettingView.h"
#import "EngineerNewTeslariViewCtrl.h"
#import "KVNProgress.h"
#import "DataSync.h"
#import "WaitDialog.h"
#import "EngineerScenarioSettingsViewCtrl.h"
#import "DataBase.h"
#import "Scenario.h"
#import "DataCenter.h"
#import "SBJson4.h"
#import "MeetingRoom.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"

#endif

@interface EngineerSysSelectViewCtrl ()<UIScrollViewDelegate>{
    
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
    
    UIView       *_container;
    UIScrollView *_switchContent;
    
    UIButton *_portSettingsBtn;
    UIButton *_dnsSettingsBtn;
    
    UIImageView *_aniWaitDialog;
    
    WebClient *_client;
}
@property (nonatomic, strong) NSMutableArray *_sceneDrivers;
@property (nonatomic, strong) NSArray *_scenes;

@end

@implementation EngineerSysSelectViewCtrl
@synthesize _sceneDrivers;
@synthesize _scenes;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *login = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
    login.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 - 80, 360, 44);
    login.layer.cornerRadius = 8;
    //login.layer.borderWidth = 1;
    //login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.clipsToBounds = YES;
    [self.view addSubview:login];
    [login setTitle:@"设置新的系统" forState:UIControlStateNormal];
    //[login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setTitleColor:ADMIN_BLACK_COLOR forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(renewSysAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 +20, 360, 44);
    signup.layer.cornerRadius = 8;
    signup.layer.borderWidth = 1;
    signup.layer.borderColor = [UIColor whiteColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"链接已有系统" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:ADMIN_BLACK_COLOR forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [signup addTarget:self
               action:@selector(linktoSysAction:)
     forControlEvents:UIControlEventTouchUpInside];

  
    UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 500)];
    [self.view addSubview:touchView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [touchView addGestureRecognizer:longPress];
    
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH,
                                                          0,
                                                          SCREEN_WIDTH,
                                                          SCREEN_HEIGHT)];
    
    [self.view addSubview:_container];
    _container.backgroundColor = self.view.backgroundColor;
    
    _switchContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT)];
    _switchContent.delegate=self;
    [_container addSubview:_switchContent];
    _switchContent.pagingEnabled = YES;
    [_switchContent setContentSize:CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT)];
    
    
    _portView = [[EngineerPortSettingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_switchContent addSubview:_portView];
    
    
    _dnsView = [[EngineerDNSSettingView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_switchContent addSubview:_dnsView];
    
    
    [self containerView];
    
    //准备插件
    [[DataCenter defaultDataCenter] prepareDrivers];
    
    self._sceneDrivers = [NSMutableArray array];
    
#ifdef   REALTIME_NETWORK_MODEL
    [self getScenarioList];
#endif
    
    [self checkArea];
    
}


- (void) getScenarioList{
  
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    if(room == nil)
    {
        return;
    }
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/getscenariolist";
    _client._httpMethod = @"GET";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    
    [param setObject:room.regulus_id forKey:@"regulusID"];
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [KVNProgress show];
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        [KVNProgress dismiss];
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                
                if(code == 200)
                {
                    if([v objectForKey:@"data"])
                    {
                        [block_self saveScenarioList:[v objectForKey:@"data"]];
                    }
                }
                return;
            }
            
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            
            
            
            NSLog(@"OOPS: %@", err);
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        [KVNProgress dismiss];
    }];
}

- (void) saveScenarioList:(NSArray*)list{
    
    for(NSDictionary *rd in list)
    {
        NSString *scenario_content = [rd objectForKey:@"scenario_content"];
        NSData *data = [scenario_content dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *s = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableDictionary *scenario = [NSMutableDictionary dictionaryWithDictionary:s];
        
        NSString *regulus_id = [rd objectForKey:@"regulus_id"];
        if(regulus_id)
        {
            [scenario setObject:regulus_id forKey:@"regulus_id"];
        }
        
        NSString *scenario_c_name = [rd objectForKey:@"scenario_c_name"];
        if(scenario_c_name)
        {
            [scenario setObject:scenario_c_name forKey:@"name"];
        }
        
        NSString *scenario_e_name = [rd objectForKey:@"scenario_e_name"];
        if(scenario_e_name)
        {
            [scenario setObject:scenario_e_name forKey:@"en_name"];
        }
        
        NSString *scenario_picture = [rd objectForKey:@"scenario_picture"];
        if(scenario_picture)
        {
            [scenario setObject:scenario_picture forKey:@"small_icon"];
        }
        
        NSString *scenario_user_icon_name = [rd objectForKey:@"scenario_user_icon_name"];
        if(scenario_user_icon_name)
        {
            [scenario setObject:scenario_user_icon_name forKey:@"icon_user"];
        }
        
        [[DataBase sharedDatabaseInstance] saveScenario:scenario];
    
    }
    
    if([_scenes count])
    {
        [self updateScenarioDrivers];
    }
}

- (void) checkArea{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
            [block_self checkSceneData:RgsAreaObjs];
        }
    }];
    
#endif
    
}
- (void) checkSceneData:(NSArray*)RgsAreaObjs{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    RgsAreaObj *areaObj = nil;
    for(RgsAreaObj *obj in RgsAreaObjs)
    {
        if([obj.name isEqualToString:VEENOON_AREA_NAME])
        {
            areaObj = obj;
            break;
        }
    }
    if(areaObj)
    {
        [DataSync sharedDataSync]._currentArea = areaObj;
        
        MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
        if(room)
        {
            int room_id = room.server_room_id;
            room.area_id = (int)areaObj.m_id;
            
#ifdef   REALTIME_NETWORK_MODEL
            [room syncAreaToServer];
#endif
            
            [[DataBase sharedDatabaseInstance] updateMeetingRoomAreaId:room_id
                                                                areaId:(int)areaObj.m_id];
        }
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] GetAreaScenes:areaObj.m_id
                                          completion:^(BOOL result, NSArray *scenes, NSError *error) {
            if (result) {
                
                [block_self checkSceneDriver:scenes];
            }else
            {
                [KVNProgress dismiss];
            }
        }];
    }
    else
    {
        //[[DataSync sharedDataSync] syncCurrentArea];
    }
    
    
#endif
}

- (void) checkSceneDriver:(NSArray*)scenes{
    
    self._scenes = scenes;
    [self updateScenarioDrivers];

}

- (void) updateScenarioDrivers{
    
    [KVNProgress dismiss];
    
    [_sceneDrivers removeAllObjects];
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    if(room)
    {
        for(RgsSceneObj *dr in _scenes)
        {
            Scenario *s = [[Scenario alloc] init];
            s._rgsSceneObj = dr;
            [s syncDataFromRegulus];
            [_sceneDrivers addObject:s];
        }
        
        /*
        NSArray* savedScenarios = [[DataBase sharedDatabaseInstance]
                                   getSavedScenario:room.regulus_id];
        
        
        NSMutableDictionary *map = [NSMutableDictionary dictionary];
        for(NSMutableDictionary *senario in savedScenarios)
        {
            int s_driver_id = [[senario objectForKey:@"s_driver_id"] intValue];
            [map setObject:senario forKey:[NSNumber numberWithInt:s_driver_id]];
        }
        
        for(RgsSceneObj *dr in _scenes)
        {
            id key = [NSNumber numberWithInt:(int)dr.m_id];
            
            if([map objectForKey:key])
            {
                Scenario *s = [[Scenario alloc] init];
                s._rgsSceneObj = dr;
                [s syncDataFromRegulus];
                [_sceneDrivers addObject:s];
            }
            else
            {
                Scenario *s = [[Scenario alloc] init];
                s._rgsSceneObj = dr;
                [s syncDataFromRegulus];
                [_sceneDrivers addObject:s];
            }
        }
         */
    }
    else
    {
        [KVNProgress showErrorWithStatus:@"出错 Error Code: 404!"];
    }
}


- (void) containerView{
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [_container addSubview:bottomBar];
    _container.alpha = 0.0;
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(c_cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(c_okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _portSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _portSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT - 130, 50, 50);
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateHighlighted];
    [_portSettingsBtn addTarget:self action:@selector(portAction:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_portSettingsBtn];
    
    _dnsSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dnsSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 130, 50, 50);
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateHighlighted];
    [_dnsSettingsBtn addTarget:self action:@selector(dnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_dnsSettingsBtn];

}

- (void) c_cancelAction:(id)sender{
    
    CGRect rc = _container.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         _container.alpha = 0;
                     }];
}
- (void) c_okAction:(id)sender{
    CGRect rc = _container.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         _container.alpha = 0;
                     }];
}

- (void) portAction:(id)sender{
    
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    
    [_switchContent setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void) dnsAction:(id)sender{
    
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateNormal];

    [_switchContent setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}
- (void) longPress:(id)sender{
    
    [self showContainer:nil];
}

- (void) showContainer:(id)sender{
    CGRect rc = _container.frame;
    rc.origin.x = 0;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         _container.alpha = 1.0;
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) renewSysAction:(UIButton*)sender{
    
    if([_sceneDrivers count])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"您确定要清空已保存的场景，设置新系统吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
        UIAlertAction *takeAction = [UIAlertAction
                                     actionWithTitle:@"确定"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         [block_self clearAndNewProject:sender];
                                     }];
        [alert addAction:takeAction];

        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"取消"
                                       style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        
        
        [self presentViewController:alert animated:YES
                         completion:nil];
    }
    else
    {
        [self clearAndNewProject:nil];
    }

}

- (void) clearAndNewProject:(UIButton*)sender{
    
#if LOGIN_REGULUS
    
    sender.enabled = NO;
    
    if([DataSync sharedDataSync]._currentReglusLogged)
    {
        IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
        
        [[RegulusSDK sharedRegulusSDK] NewProject:@"Veenoon"
                                       completion:^(BOOL result, NSError *error) {
            
            sender.enabled = YES;
            
            if(result)
            {
                [block_self setNewProject];
            }
            else
            {
                NSLog(@"%@", [error description]);
            }
        }];
        
        
    }
    else
    {
        [KVNProgress showErrorWithStatus:@"未登录"];
        
        sender.enabled = YES;
    }
    
#else
    [self setNewProject];
#endif
}



- (void) setNewProject{
    
    
    [self actionNewArea];
    
    /*
    [KVNProgress show];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(actionNewArea)
                                   userInfo:nil
                                    repeats:NO];
     */
}

- (void) actionNewArea{
    
   //[KVNProgress dismiss];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"Call: NewProject");
        
        [[DataSync sharedDataSync] newVeenoonArea];
        
        MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
        [[DataBase sharedDatabaseInstance] deleteScenarioByRoom:room.regulus_id];
        [_sceneDrivers removeAllObjects];
        
        EngineerNewTeslariViewCtrl *ctrl = [[EngineerNewTeslariViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    });
    

}


- (void) cancelAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) linktoSysAction:(id)sender{
    
    if([_sceneDrivers count])
    {
        EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
        ctrl._scenarioArray = _sceneDrivers;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else
    {
        [KVNProgress showErrorWithStatus:@"您还没有创建场景!"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //NSLog(@"pageHeight = %f", pageHeight);
    int _pageIndex = scrollView.contentOffset.x / pageWidth;
    
    if(_pageIndex == 0) {
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
        
    }  else{
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

