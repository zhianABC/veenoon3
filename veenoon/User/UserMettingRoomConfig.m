//
//  UserMettingRoomConfig.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMeetingRoomConfig.h"
#import "UserScnarioConfigViewController.h"
#import "KVNProgress.h"
#import "RegulusSDK.h"
#import "DataCenter.h"
#import "DataSync.h"
#import "DataBase.h"
#import "Scenario.h"
#import "MeetingRoom.h"
#import "AutoRunViewController.h"
#import "UserDeviceStateViewController.h"
#import "USenceBlockView.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "HttpFileGetter.h"
#import "SelPickerView.h"
#import "Utilities.h"

@interface UserMeetingRoomConfig () <ScenarioDelegate, USenceBlockViewDelegate, JCActionViewDelegate>{

    UIButton *_trainingBtn;
    UIButton *_envirementControlBtn;
    UIButton *_guestBtn;
    UIButton *_envirementLightBtn;
    UIButton *_discussionBtn;
    UIButton *_leaveMeetingBtn;
    
    UIScrollView *_content;
    
    HttpFileGetter * _downloader;

}
@property (nonatomic, strong) NSMutableDictionary *_mapSelect;

@property (nonatomic, strong) NSString *_regulus_user_id;
@property (nonatomic, strong) NSString *_regulus_gateway_id;
@property (nonatomic, strong) NSMutableArray *_sceneDrivers;

@property (nonatomic, strong) UIImage *_nor_image;
@property (nonatomic, strong) UIImage *_sel_image;
@property (nonatomic, strong) Scenario *_curSecenario;

@property (nonatomic, strong) NSArray *_offlineProjs;


@end

@implementation UserMeetingRoomConfig
@synthesize _currentRoom;
@synthesize _mapSelect;

@synthesize _regulus_user_id;
@synthesize _regulus_gateway_id;
@synthesize _sceneDrivers;

@synthesize _nor_image;
@synthesize _sel_image;
@synthesize _curSecenario;

@synthesize _offlineProjs;


- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.view.backgroundColor = USER_GRAY_COLOR;
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, 40, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [backBtn addTarget:self action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, SCREEN_WIDTH-100, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = [NSString stringWithFormat:@"%@ - 场景应用",_currentRoom.room_name];
    
    UIButton *btnState = [UIButton buttonWithType:UIButtonTypeCustom];
    btnState.frame = CGRectMake(50, SCREEN_HEIGHT - 50, 120, 40);
    [btnState setImage:[UIImage imageNamed:@"state_summary_white.png"]
              forState:UIControlStateNormal];
    [btnState setImage:[UIImage imageNamed:@"state_summary.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnState];
    [btnState addTarget:self
                 action:@selector(stateAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnAuto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAuto.frame = CGRectMake(SCREEN_WIDTH-165, SCREEN_HEIGHT - 50, 120, 50);
    [btnAuto setImage:[UIImage imageNamed:@"syc_icon_white.png"]
              forState:UIControlStateNormal];
    [btnAuto setImage:[UIImage imageNamed:@"sync_icon.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnAuto];
    [btnAuto addTarget:self
                 action:@selector(autoAyncAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    self._mapSelect = [NSMutableDictionary dictionary];
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-80-50)];
    [self.view addSubview:_content];
    _content.clipsToBounds = YES;
    
    
    self._nor_image = [UIImage imageNamed:@"user_training_n.png"];
    self._sel_image = [UIImage imageNamed:@"user_training_s.png"];
    
    self._regulus_gateway_id = _currentRoom.regulus_id;
    self._regulus_user_id = _currentRoom.regulus_user_id;
    
    self._sceneDrivers = [NSMutableArray array];
    
#if LOGIN_REGULUS
    [KVNProgress show];
    
    
    if([_regulus_gateway_id length]
       && [_regulus_user_id length])
    {
        [self loginCtrlDevice];
    }
    else
    {
        [self regCtrlDevice];
    }
    
#endif
    
    UIButton *btnSync = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSync.frame = CGRectMake(SCREEN_WIDTH - 120, 42, 60, 50);
    [btnSync setImage:[UIImage imageNamed:@"sync_data_n.png"] forState:UIControlStateNormal];
    [btnSync setImage:[UIImage imageNamed:@"sync_data_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btnSync];
    btnSync.layer.cornerRadius = 5;
    btnSync.clipsToBounds = YES;
    [btnSync addTarget:self
                action:@selector(dataSyncAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endImportProjectRefresh:)
                                                 name:@"Notify_Reload_Projects_After_Import_Action"
                                               object:nil];
}

- (void) endImportProjectRefresh:(NSNotification*)notify{
    
    [KVNProgress showWithStatus:@"加载中..."];
    
    
}

- (void) relunchUI{
    
    [self checkArea];
}

- (void) dataSyncAction:(id)sender{
    
    JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"从云账户导入", @"从U盘导入"]
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
        [self importFromCloud];
    }
    else if(index == 1)
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
        
        [KVNProgress showWithStatus:@"下载中..."];
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
    else
    {
        [Utilities showMessage:@"没有找到备份文件" ctrl:self];
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
        
        IMP_BLOCK_SELF(UserMeetingRoomConfig);
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

- (void) stateAction:(id)sender{
    UserDeviceStateViewController *ctrl = [[UserDeviceStateViewController alloc] init];
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) autoAyncAction:(id)sender{
    
    AutoRunViewController *autoSync = [[AutoRunViewController alloc] init];
    autoSync._scenarios = _sceneDrivers;
    [self presentViewController:autoSync animated:YES
                     completion:nil];
}


- (void) regCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    [KVNProgress showWithStatus:@"登录中..."];
    
    [[RegulusSDK sharedRegulusSDK] RequestJoinGateWay:_regulus_gateway_id
                                           completion:^(BOOL result,
                                                        NSString *client_id, NSError *error) {
                                               if (result) {
                                                   
                                                   block_self._regulus_user_id = client_id;
                                                   //NSLog(@"user_id:%@,gw:%@\n",user_id,_gw_id.text);
                                                   [[NSUserDefaults standardUserDefaults] setObject:_regulus_gateway_id forKey:@"gateway_id"];
                                                   [[NSUserDefaults standardUserDefaults] setObject:client_id forKey:@"user_id"];
                                                   
                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                                   
                                                   [block_self loginCtrlDevice];
                                               }
                                               else{
                                                   [KVNProgress showErrorWithStatus:[error description]];
                                                   
                                                   [DataSync sharedDataSync]._currentReglusLogged = nil;
                                               }
                                           }];

#endif
    
}

- (void) loginCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
    [[RegulusSDK sharedRegulusSDK] Login:self._regulus_user_id
                                   gw_id:_regulus_gateway_id
                                password:@"111111"
                                   level:1 completion:^(BOOL result, NSInteger level, NSError *error) {
                                       if (result) {
                                           [block_self update];
                                       }
                                       else
                                       {
                                           [DataSync sharedDataSync]._currentReglusLogged = nil;
                                           [KVNProgress showErrorWithStatus:[error description]];
                                       }
                                   }];
    
#endif
    
}

- (void) update{
    
    [DataCenter defaultDataCenter]._currentRoom = _currentRoom;
    _currentRoom.regulus_user_id = _regulus_user_id;
    [[DataBase sharedDatabaseInstance] saveMeetingRoom:_currentRoom];
    
    
    /*
    [[RegulusSDK sharedRegulusSDK] SetDate:[NSDate date]
                                completion:nil];
     */
    
    
    [DataSync sharedDataSync]._currentReglusLogged = @{@"gw_id":_regulus_gateway_id,
                                                       @"user_id":_regulus_user_id
                                                       };
    
    [self checkArea];
    
}

- (void) checkArea{
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
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
    
    IMP_BLOCK_SELF(UserMeetingRoomConfig);
    
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
        //获取Area添加的插件
        [DataSync sharedDataSync]._currentArea = areaObj;
        [[DataSync sharedDataSync] syncAreaHasDrivers];
        
        [[RegulusSDK sharedRegulusSDK] GetAreaScenes:areaObj.m_id
                                          completion:^(BOOL result, NSArray *scenes, NSError *error) {
                                              if (result) {
                                                  
                                                  [block_self checkSceneDriver:scenes];
                                              }
                                          }];
    }
    else
    {
        [KVNProgress dismiss];
    }
}

- (void) checkSceneDriver:(NSArray*)scenes{

    NSArray* savedScenarios = [[DataBase sharedDatabaseInstance]
                               getSavedScenario:_regulus_gateway_id];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for(NSDictionary *senario in savedScenarios)
    {
        int s_driver_id = [[senario objectForKey:@"s_driver_id"] intValue];
        [map setObject:senario forKey:[NSNumber numberWithInt:s_driver_id]];
    }
    
  
    [_sceneDrivers removeAllObjects];
    
    for(RgsSceneObj *dr in scenes)
    {
        id key = [NSNumber numberWithInt:(int)dr.m_id];
        
        Scenario *s = [[Scenario alloc] init];
        if([map objectForKey:key])
        {
            [s prepareDataForUploadCloud:[map objectForKey:key]];
        }
        
        s._rgsSceneObj = dr;
        
        //不在这儿加载了，在下面函数中加载。
        //[s syncDataFromRegulus];
        
        [_sceneDrivers addObject:s];
    }
    
    [KVNProgress dismiss];
    
    [self layoutScenarios];
}


- (void) layoutScenarios{
    
    [[_content subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    int w = 325;
    int ox = (SCREEN_WIDTH - w*3)/2+30;
    int y = 10;
    int x = ox;
    for(int i = 0; i < [_sceneDrivers count]; i++)
    {
        
        if(i%3==0 && i > 0){
            y+=200;
            y-=10;
            x = ox;
        }
        if(i%3 != 0 ){
            x += w;
            x-=20;
        }
        
        Scenario *scen = [_sceneDrivers objectAtIndex:i];
        
        CGRect rc = CGRectMake(x, y, w, 210);
        USenceBlockView *block = [[USenceBlockView alloc] initWithFrame:rc];
        block._senario = scen;
        [block refreshData];
        block.delegate = self;
        [_content addSubview:block];
        block.tag = i;
    
        UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
        [block addGestureRecognizer:longPress0];
    }
    
    _content.contentSize = CGSizeMake(_content.frame.size.width,
                                      y+260);
    
}

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
        int index = (int)viewRecognizer.view.tag;
        
        self._curSecenario = [_sceneDrivers objectAtIndex:index];
        _curSecenario.delegate = self;
        [_curSecenario loadDriverValues];
        
        
    }
}

- (void) didEndLoadingDiverValues{
    
    UserScnarioConfigViewController *invitation = [[UserScnarioConfigViewController alloc] init];
    invitation._data = _curSecenario;
    [self.navigationController pushViewController:invitation animated:YES];
    
}

- (void) didSelectRoomScenario:(Scenario*)s cell:(USenceBlockView*)cellView
{
    Scenario *scen = s;
    id key = [NSNumber numberWithInteger:scen._rgsSceneObj.m_id];
    
    if([_mapSelect objectForKey:key])
    {
        //取消
        [cellView selectedCell:NO];
        
        [_mapSelect removeObjectForKey:key];
    }
    else
    {
        
        USenceBlockView *cell = [_mapSelect objectForKey:@"selected_btn"];
        if(cell)
        {
            id oldkey = [NSNumber numberWithInteger:cell._senario._rgsSceneObj.m_id];
            
            [cell selectedCell:NO];
            
            [_mapSelect removeObjectForKey:oldkey];
        }
        
        [cellView selectedCell:YES];
          
        [KVNProgress show];
        
        RgsSceneObj * scene_obj = scen._rgsSceneObj;
        if(scene_obj && [scene_obj isKindOfClass:[RgsSceneObj class]])
        {
            [[RegulusSDK sharedRegulusSDK] ExecScene:scene_obj.m_id
                                          completion:^(BOOL result, NSError *error) {
                                              if (result) {
                                                  [KVNProgress showSuccess];
                                              }
                                              else{
                                                  [KVNProgress showErrorWithStatus:@"执行失败！"];
                                              }
                                          }];
        }
        
        [_mapSelect setObject:scen forKey:key];
        [_mapSelect setObject:cellView forKey:@"selected_btn"];
    }
}


- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
