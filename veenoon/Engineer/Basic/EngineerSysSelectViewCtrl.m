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
#import "SelPickerView.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "HttpFileGetter.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"

#endif

@interface EngineerSysSelectViewCtrl ()<UIScrollViewDelegate,JCActionViewDelegate, HttpFileGetterDelegate>{
    
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
    
    UIView       *_container;
    UIScrollView *_switchContent;
    
    UIButton *_portSettingsBtn;
    UIButton *_dnsSettingsBtn;
    
    UIImageView *_aniWaitDialog;
    
    WebClient *_client;
    
    HttpFileGetter *_downloader;
}
@property (nonatomic, strong) NSMutableArray *_sceneDrivers;
@property (nonatomic, strong) NSArray *_scenes;
@property (nonatomic, strong) NSArray *_offlineProjs;

@end

@implementation EngineerSysSelectViewCtrl
@synthesize _sceneDrivers;
@synthesize _scenes;
@synthesize _localPrjName;
@synthesize _offlineProjs;

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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *newSysBtn = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LINE_COLOR];
    newSysBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 - 20, 360, 44);
    newSysBtn.layer.cornerRadius = 8;
    newSysBtn.clipsToBounds = YES;
    [self.view addSubview:newSysBtn];
    [newSysBtn setTitle:@"设置新的系统" forState:UIControlStateNormal];
    [newSysBtn setTitleColor:ADMIN_BLACK_COLOR forState:UIControlStateNormal];
    newSysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [newSysBtn addTarget:self
              action:@selector(renewSysAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *linkSysBtn = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    linkSysBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 +60, 360, 44);
    linkSysBtn.layer.cornerRadius = 8;
    linkSysBtn.layer.borderWidth = 1;
    linkSysBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    linkSysBtn.clipsToBounds = YES;
    [self.view addSubview:linkSysBtn];
    [linkSysBtn setTitle:@"链接已有系统" forState:UIControlStateNormal];
    [linkSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [linkSysBtn setTitleColor:ADMIN_BLACK_COLOR forState:UIControlStateHighlighted];
    linkSysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [linkSysBtn addTarget:self
               action:@selector(linktoSysAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    BOOL isLocal = [DataCenter defaultDataCenter]._isLocalPrj;
    if(!isLocal)
    {
        
        linkSysBtn.center = CGPointMake(newSysBtn.center.x, SCREEN_HEIGHT/2+20);
        newSysBtn.center = CGPointMake(newSysBtn.center.x, CGRectGetMidY(linkSysBtn.frame) - 80);
        
        UIButton *importSysBtn = [UIButton buttonWithColor:nil selColor:nil];
        importSysBtn.frame = CGRectMake(SCREEN_WIDTH - 220, 40, 200, 44);
        [self.view addSubview:importSysBtn];
        [importSysBtn setTitle:@"载入离线配置" forState:UIControlStateNormal];
        [importSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [importSysBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        importSysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
        [importSysBtn addTarget:self
                       action:@selector(importSysAction:)
             forControlEvents:UIControlEventTouchUpInside];
    }

  
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
    _switchContent.delegate = self;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endImportProjectRefresh:)
                                                 name:@"Notify_Reload_Projects_After_Import_Action"
                                               object:nil];
    
}

- (void) endImportProjectRefresh:(id)sender{
    
    [KVNProgress showSuccessWithStatus:@"已导入"];
}

#pragma mark -- import Project --
- (void) importSysAction:(id)sender{
    
    JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"本地账户", @"云账户", @"U盘"]
                                                            frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    jcAction.delegate_ = self;
    jcAction.tag = 2017;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:jcAction];
    [jcAction animatedShow];
    

}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    if(index == 0)
    {
        [self importFromLocal];
    }
    else if(index == 1)
    {
         [self importFromCloud];
    }
    else if(index == 2)
    {
         [self importFromUSB];
    }
}

- (void) importFromCloud{
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    if(room)
    {
        if(_downloader == nil)
       {
           _downloader = [[HttpFileGetter alloc] init];
           _downloader.delegate_ = self;
       }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"Project"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:dir]){
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSString *filename = [NSString stringWithFormat:@"%@.rp",room.regulus_id];
        NSString *filePath = [dir stringByAppendingPathComponent:filename];
        
        NSString *url = [NSString stringWithFormat:@"%@/projectfile/%@", WEB_API_URL, filename];
        
        _downloader.fileSavedPath = filePath;
        
        [KVNProgress show];
        [_downloader startLoading:url];
        
    }

    
    
}

- (void) didEndLoadingFile:(id)object success:(BOOL)success{
    
    [KVNProgress dismiss];
    if(success)
    {
        [KVNProgress showSuccess];
        MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
        NSString *filename = [NSString stringWithFormat:@"%@",room.regulus_id];
        
        [KVNProgress showWithStatus:@"正在导入"];
        [[RegulusSDK sharedRegulusSDK] ImportProjectFromLocal:filename
                                                   completion:^(BOOL result, NSError *error) {
                                                       
                                                       //[KVNProgress showSuccessWithStatus:@"已导入"];
                                                       
                                                   }];
    }
}

- (void) importFromUSB{
    
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] GetProjectsFromUdisc:^(BOOL result, NSArray *names, NSError *error) {
        
        [KVNProgress dismiss];
        if(result)
        {
            if([names count])
            {
                self._offlineProjs = names;
            }
        }
        
        [self chooseUSDProject];

    }];
}

- (void) chooseUSDProject{
    
    if(self._offlineProjs && [_offlineProjs count])
    {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        SelPickerView *_levelSetting = [[SelPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _levelSetting._pickerDataArray = @[@{@"values":_offlineProjs}];
        
        [_levelSetting showInView:app.window];
        
        [_levelSetting selectRow:0 inComponent:0];
        
        IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
        _levelSetting._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickUSBProjectName:values];
        };
    
    }
    else
    {
        [KVNProgress showSuccessWithStatus:@"没有可导入的项目"];
    }
}

- (void) didPickUSBProjectName:(NSDictionary*)values{
    
    NSString *prjName = [values objectForKey:@0];
    
    [KVNProgress showWithStatus:@"正在导入"];
    
    [[RegulusSDK sharedRegulusSDK] ImportProjectFromUdisc:prjName completion:^(BOOL result, NSError *error) {
        
        //[KVNProgress showSuccessWithStatus:@"已导入"];
        
    }];
}


- (void) importFromLocal{
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetProjectsFromLocal:^(BOOL result, NSArray *names, NSError *error) {
        
        [KVNProgress dismiss];
        
        if(result)
        {
            if([names count])
            {
               self._offlineProjs = names;
            }
        }
        
        [self chooseLocalProject];
        
    }];
    
}

- (void) chooseLocalProject{
    
    if(self._offlineProjs && [_offlineProjs count])
    {
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        SelPickerView *_levelSetting = [[SelPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        _levelSetting._pickerDataArray = @[@{@"values":_offlineProjs}];
        
        [_levelSetting showInView:app.window];
        
        [_levelSetting selectRow:0 inComponent:0];
        
        IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
        _levelSetting._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickProjectName:values];
        };
        
    }
    else
    {
        [KVNProgress showSuccessWithStatus:@"没有可导入的项目"];
    }
}

- (void) didPickProjectName:(NSDictionary*)values{
    
    NSString *prjName = [values objectForKey:@0];
    
    [KVNProgress showWithStatus:@"正在导入"];
    
    [[RegulusSDK sharedRegulusSDK] ImportProjectFromLocal:prjName
                                               completion:^(BOOL result, NSError *error) {
                                                   
                                                   
                                                   
                                               }];
}

- (void) checkArea{
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
            [block_self checkSceneData:RgsAreaObjs];
        }
    }];
    
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
            
            [[DataBase sharedDatabaseInstance] updateMeetingRoomAreaId:room_id
                                                                areaId:(int)areaObj.m_id];
        }
        
        
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
        [KVNProgress dismiss];
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
    
    BOOL isLocal = [DataCenter defaultDataCenter]._isLocalPrj;
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    if(room || isLocal)
    {
        for(RgsSceneObj *dr in _scenes)
        {
            Scenario *s = [[Scenario alloc] init];
            s._rgsSceneObj = dr;
            [s syncDataFromRegulus];
            [_sceneDrivers addObject:s];
        }
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(c_cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
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


- (void) doNewArea{
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] NewProject:@"Veenoon"
                                   completion:^(BOOL result, NSError *error) {
                                       
                                        [KVNProgress dismiss];
                                       
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

- (void) clearAndNewProject:(UIButton*)sender{
 
   
    
    BOOL isLocal = [DataCenter defaultDataCenter]._isLocalPrj;
    
    if(isLocal)
    {
        [self actionNewArea];
        return;
    }
    
     [KVNProgress show];
    if([DataSync sharedDataSync]._currentReglusLogged)
    {
        [self doNewArea];
    }
    else
    {
        [KVNProgress showErrorWithStatus:@"未登录"];
    }
    
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
        if(room)
        {
            [[DataBase sharedDatabaseInstance] deleteScenarioByRoom:room.regulus_id];
        }
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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

