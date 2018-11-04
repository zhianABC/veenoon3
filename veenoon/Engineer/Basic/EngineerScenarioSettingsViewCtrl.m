//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerScenarioSettingsViewCtrl.h"
#import "UIButton+Color.h"
#import "EngineerPresetScenarioViewCtrl.h"
#import "EngineerScenarioListViewCtrl.h"
#import "SIconSelectView.h"
#import "DataBase.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataSync.h"
#import "UIButton+Color.h"
#import "DataCenter.h"
#import "EngineerToUseTeslariViewCtrl.h"
#import "HomeViewController.h"
#import "EngineerNewTeslariViewCtrl.h"
#import "MeetingRoom.h"
#import "ScenarioCellView.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "EngineerLocalPrjsListViewCtrl.h"


@interface EngineerScenarioSettingsViewCtrl ()<SIconSelectViewDelegate, ScenarioDelegate, ScenarioCellViewDelegate, JCActionViewDelegate>{
    
    UIButton *_selectSysBtn;
    SIconSelectView *_settingview;
    UIScrollView *scroolView;
    
    UIButton *iBtn;
    
    int topy;
    
    BOOL _isEditMode;
    
    UIButton *editBtn;
    UIButton *_doneBtn;
    
    NSMutableArray *_deleteCells;
    
    BOOL _isSaved;
    
    WebClient *_client;
}
@property (nonatomic, strong) NSMutableArray *_sBtns;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSString* regulus_id;
@property (nonatomic, strong) Scenario *_curSecenario;


@end

@implementation EngineerScenarioSettingsViewCtrl
@synthesize _scenarioArray;
@synthesize _sBtns;
@synthesize _map;
@synthesize regulus_id;
@synthesize _curSecenario;
@synthesize localPrjName;


- (void) initDat {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isEditMode = NO;
    _deleteCells = [NSMutableArray array];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;

    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    if(room){
        self.regulus_id = room.regulus_id;
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = LOGIN_BLACK_COLOR;
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    bottom.backgroundColor = THEME_COLOR;
    
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(0, 0,160, 50);
//    [bottomBar addSubview:cancelBtn];
//    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
//    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [cancelBtn addTarget:self
//                  action:@selector(backAction:)
//        forControlEvents:UIControlEventTouchUpInside];
//
    
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                                      ENGINEER_VIEW_TOP,
                                                                      SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
    UILabel* tipsL = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    tipsL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsL];
    tipsL.font = [UIFont systemFontOfSize:16];
    tipsL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    tipsL.text = @"在场景内，可选择您所需要配置的设备";
    
    topy = CGRectGetMaxY(tipsL.frame)+20;

    UIButton *goHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goHomeBtn.frame = CGRectMake(10, 0, 160, 50);
    [bottomBar addSubview:goHomeBtn];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon.png"]
               forState:UIControlStateNormal];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon_sel.png"]
               forState:UIControlStateHighlighted];
    [goHomeBtn addTarget:self
              action:@selector(gohomeAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(SCREEN_WIDTH - 160 - 10, 40, 160, 44);
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [editBtn addTarget:self action:@selector(editAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(SCREEN_WIDTH - 160 - 10, ENGINEER_VIEW_TOP-10, 160, 44);
    [self.view addSubview:_doneBtn];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_doneBtn addTarget:self
                 action:@selector(doneAction:)
       forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.hidden = YES;

    
    iBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:iBtn];
    [iBtn setImage:[UIImage imageNamed:@"i_btn_white.png"]
          forState:UIControlStateNormal];
    [iBtn addTarget:self
             action:@selector(iconAction:)
   forControlEvents:UIControlEventTouchUpInside];
    iBtn.center = CGPointMake(SCREEN_WIDTH/2, iBtn.center.y);

    
    UIButton *upCloud = [UIButton buttonWithType:UIButtonTypeCustom];
    upCloud.frame = CGRectMake(SCREEN_WIDTH - 160 - 10, 0,160, 50);
    [bottomBar addSubview:upCloud];
    
    
    BOOL isLocalProject = [DataCenter defaultDataCenter]._isLocalPrj;
    if(isLocalProject)
    {
        _isSaved = NO;
        
        [upCloud setImage:[UIImage imageNamed:@"local_prj_save_n.png"]
                 forState:UIControlStateNormal];
        [upCloud setImage:[UIImage imageNamed:@"local_prj_save_s.png"]
                 forState:UIControlStateHighlighted];
        [upCloud addTarget:self
                    action:@selector(saveLocalProjectAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        //如果不是本地的，直接默认认为已存储
        _isSaved = YES;
        
        [upCloud setImage:[UIImage imageNamed:@"up_cloud_white.png"]
                 forState:UIControlStateNormal];
        [upCloud setImage:[UIImage imageNamed:@"up_cloud_selected.png"]
                 forState:UIControlStateHighlighted];
        [upCloud addTarget:self
                    action:@selector(uploadAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    _settingview = [[SIconSelectView alloc]
                    initWithFrame:CGRectMake(0,
                                             SCREEN_HEIGHT,
                                             SCREEN_WIDTH,
                                             100)];
    _settingview.delegate = self;
    
    [self.view addSubview:_settingview];
    
    [self.view addSubview:topbar];
    [self.view addSubview:bottom];
    [self.view addSubview:bottomBar];

    
    if([_scenarioArray count])
    {
        [self layoutScenarios];
    }
    else
    {
        if(localPrjName)
        {
            [[DataCenter defaultDataCenter] prepareDrivers];
            
            if([DataSync sharedDataSync]._currentArea == nil)
            {
                [self checkArea];
            }
            else
            {
                [self loadSenseFromRegulusCtrl];
            }
        }
        else
        {
            [self loadSenseFromRegulusCtrl];
        }
    }
    
    //获取Regulus支持的插件
    [[DataSync sharedDataSync] syncRegulusDrivers];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyReloadScenario:)
                                                 name:@"Notify_Reload_Senario"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadRpFile:)
                                                 name:@"Notify_Export_Done"
                                               object:nil];
    
    
}

- (void) checkArea{
    
    IMP_BLOCK_SELF(EngineerScenarioSettingsViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
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
                [block_self loadSenseFromRegulusCtrl];
            }
        }
    }];
    
}

- (void) saveLocalProjectAction:(id)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入保存的名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"工程名称";
    }];
    
    IMP_BLOCK_SELF(EngineerScenarioSettingsViewCtrl);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *nameTxt = envirnmentNameTextField.text;
        if (nameTxt && [nameTxt length] > 0) {
            
            [block_self doSaveCurrentLocalProject:nameTxt];
            
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


- (void) doSaveCurrentLocalProject:(NSString*)name{
    
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] SaveLocalProject:name completion:^(BOOL result, NSError *error) {
        
        [KVNProgress dismiss];
        if(result)
        {
            _isSaved = YES;
            [self backToLocalPrjsPage];
        }
        
    }];
}


//TODO: 上传到云端备份
- (void) uploadAction:(id)sender{
    
    JCActionView *jcAction = [[JCActionView alloc] initWithTitles:@[@"备份到云账户", @"备份到U盘"]
                                                            frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    jcAction.delegate_ = self;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:jcAction];
    [jcAction animatedShow];
    
}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    if(index == 0)
    {
        [self exportProjectToCloud];
    }
    else if(index == 1)
    {
        [self exportProjectToUdisk];
    }
}

- (void) exportProjectToUdisk{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                             message:@"请输入保存的名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"工程名称";
    }];
    
    IMP_BLOCK_SELF(EngineerScenarioSettingsViewCtrl);
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *nameTxt = envirnmentNameTextField.text;
        if (nameTxt && [nameTxt length] > 0) {
            
            [block_self doSaveCurrentProjectToUDisk:nameTxt];
            
        }
    }]];
    
    
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void) doSaveCurrentProjectToUDisk:(NSString*)name{

    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] ExportProjectToUdisc:name completion:^(BOOL result, NSError *error) {
        
        if(result)
        {
            [KVNProgress showSuccessWithStatus:@"备份完成"];
        }
    }];
}

- (void) exportProjectToCloud{
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] ExportProjectToLocal:[NSString stringWithFormat:@"%@",self.regulus_id]
                                             completion:^(BOOL result,NSError * error) {
                                                 
                                             }];

    
    
    
    
}

- (void) uploadRpFile:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dir = [documentsDirectory stringByAppendingPathComponent:@"Project"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:dir]){
        [fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *filename = [NSString stringWithFormat:@"%@.rp",self.regulus_id];
    NSString *filePath = [dir stringByAppendingPathComponent:filename];
    
   if(![fileManager fileExistsAtPath:filePath])
   {
       [KVNProgress showErrorWithStatus:@"未导出工程文件"];
       return;
   }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"project" forKey:@"type"];
    [param setObject:self.regulus_id forKey:@"regulus_id"];
    
    [KVNProgress showWithStatus:@"云备份"];
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/uploadprojectfile";
    _client._httpMethod = @"POST";
    
    _client._requestParam = param;
    
    [param setObject:@"file" forKey:@"filename"];
    [param setObject:data forKey:@"photo"];
    
    [_client requestWithSusessBlockWithImage:^(id lParam, id rParam) {
        
        [KVNProgress showSuccessWithStatus:@"备份完成"];
        
    } FailBlock:^(id lParam, id rParam) {
        
        [KVNProgress dismiss];
    }];
}

- (void) doneAction:(id)sender{
    
    _isEditMode = NO;
    
    _doneBtn.hidden = YES;
    editBtn.hidden = NO;
    
    if([_deleteCells count])
    {
        for(UIButton *btn in _deleteCells)
        {
            [btn removeFromSuperview];
        }
        
        [_deleteCells removeAllObjects];
        
        
        [self layoutScenarios];
    }
    
}

-(void) editAction:(id)sender {
    
    if(_isEditMode)
        return;
    _isEditMode = YES;
    
    _doneBtn.hidden = NO;
    editBtn.hidden = YES;
    
    [_deleteCells removeAllObjects];
    
    int size = (int)[_sBtns count];
    int index = 0;
    for(ScenarioCellView *btn in _sBtns)
    {
        if (index == size - 1) {
            continue;
        }
        UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDel.frame = btn.bounds;
        btnDel.tag = btn.tag;
        
        [btn addSubview:btnDel];
        
        [btnDel setImage:[UIImage imageNamed:@"red_del_icon.png"]
                forState:UIControlStateNormal];
        
        btnDel.imageEdgeInsets = UIEdgeInsetsMake(-75, -75, 0, 0);
        
        [btnDel addTarget:self
                   action:@selector(delButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [_deleteCells addObject:btnDel];
        
        index++;
    }
}

- (void) delButton:(UIButton*)cellBtn{
    
    ScenarioCellView *supBtn = (ScenarioCellView*)cellBtn.superview;
    if([supBtn isKindOfClass:[ScenarioCellView class]])
    {
        Scenario *sen = [supBtn getData];
        if (sen) {
            [[RegulusSDK sharedRegulusSDK] DeleteDriver:sen._rgsSceneObj.m_id
                                             completion:^(BOOL result, NSError *error) {
                if (result) {
                    
                    [supBtn removeFromSuperview];
                    
                    
                    [_sBtns removeObject:supBtn];
                    
                    [self._scenarioArray removeObject:sen];
                    
                }
            }];
        }
    }
    
}

- (void) iconAction:(id)sender{
    
    //如果在显示，消失
    if(CGRectGetMinY(_settingview.frame) < SCREEN_HEIGHT)
    {
        [iBtn setImage:[UIImage imageNamed:@"i_btn_white.png"]
              forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _settingview.frame  = CGRectMake(0,
                                                            SCREEN_HEIGHT,
                                                            SCREEN_WIDTH,
                                                            100);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else//如果没显示，显示
    {
        
        [iBtn setImage:[UIImage imageNamed:@"i_btn_yellow.png"]
              forState:UIControlStateNormal];
        
        
        [UIView beginAnimations:nil context:nil];
        _settingview.frame  = CGRectMake(0,
                                       SCREEN_HEIGHT-150,
                                       SCREEN_WIDTH,
                                       100);
        [UIView commitAnimations];
    }
}

- (void) backToLocalPrjsPage{
    
    UIViewController *engCtrl = nil;
    
    NSArray *ctrls = self.navigationController.viewControllers;
    for(UIViewController *vc in ctrls)
    {
        if([vc isKindOfClass:[EngineerLocalPrjsListViewCtrl class]])
        {
            engCtrl = vc;
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Refresh_Local_Prj_List"
                                                        object:nil];
    if(engCtrl){
        [self.navigationController popToViewController:engCtrl animated:YES];
    }
}

- (void) backToPrevStartPage{
    
    //返回到场景列表页面
    UIViewController *engCtrl = nil;
    
    NSArray *ctrls = self.navigationController.viewControllers;
    for(UIViewController *vc in ctrls)
    {
        if([vc isKindOfClass:[HomeViewController class]])
        {
            engCtrl = vc;
            break;
        }
    }
    
    if(engCtrl){
        [self.navigationController popToViewController:engCtrl animated:YES];
    }
}

- (void) gohomeAction:(id)sender{
    
    if(_isSaved)
    {
        [self backToPrevStartPage];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"您还没有存储当前编辑的工程，现在要保存吗？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        IMP_BLOCK_SELF(EngineerScenarioSettingsViewCtrl);
        UIAlertAction *sveAction = [UIAlertAction
                                     actionWithTitle:@"保存"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         [block_self saveLocalProjectAction:sender];
                                     }];
        [alert addAction:sveAction];
        
        UIAlertAction *noSave = [UIAlertAction
                                     actionWithTitle:@"不保存"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         [block_self backToPrevStartPage];
                                     }];
        [alert addAction:noSave];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"取消"
                                       style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        
        
        [self presentViewController:alert animated:YES
                         completion:nil];
    }
}

- (void) backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) notifyReloadScenario:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadSenseFromRegulusCtrl];
    });
}

- (void) loadSenseFromRegulusCtrl{
    
    self._scenarioArray = [NSMutableArray array];
    [self checkSceneData:[DataSync sharedDataSync]._currentArea];
}

- (void) checkSceneData:(RgsAreaObj*)areaObj{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerScenarioSettingsViewCtrl);
    
    if(areaObj)
    {
        [KVNProgress show];
        
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
    
    
#endif
}

- (void) checkSceneDriver:(NSArray*)scenes{
    
    NSArray* savedScenarios = [[DataBase sharedDatabaseInstance]
                               getSavedScenario:regulus_id];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for(NSDictionary *senario in savedScenarios)
    {
        int s_driver_id = [[senario objectForKey:@"s_driver_id"] intValue];
        [map setObject:senario forKey:[NSNumber numberWithInt:s_driver_id]];
    }
    
    [_scenarioArray removeAllObjects];
    
    for(RgsSceneObj *dr in scenes)
    {
        id key = [NSNumber numberWithInt:(int)dr.m_id];
        
        Scenario *s = [[Scenario alloc] init];
        if([map objectForKey:key])
        {
            [s prepareDataForUploadCloud:[map objectForKey:key]];
        }
        s._rgsSceneObj = dr;
        [_scenarioArray addObject:s];
    }
    
    [KVNProgress showSuccess];
    
    [self layoutScenarios];
}

- (void) layoutScenarios{
    
    int scenarioSize = (int)[_scenarioArray count] + 1;
    
    int col = 8;
    int leftRightSpace = ENGINEER_VIEW_LEFT;
    
    
    int rowNumber = scenarioSize/col + 1;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int top = 5;
    
    if(scroolView == nil)
    {
        scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRightSpace,
                                                                    topy,
                                                                    SCREEN_WIDTH-leftRightSpace*2,
                                                                    SCREEN_HEIGHT-240)];
        
    }
    else
    {
        [[scroolView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.view insertSubview:scroolView belowSubview:_settingview];
    
    float colGap = (CGRectGetWidth(scroolView.frame) - 8*cellWidth)/7.0;
    
    int scrollHeight = rowNumber*cellHeight + (rowNumber-1)*colGap+10;
    
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH-leftRightSpace*2, scrollHeight);
    
    [_sBtns removeAllObjects];
    
    int index = 0;
    for (int i = 0; i < scenarioSize; i++) {
        
        int rowN = index/col;
        int colN = index%col;
        int startX = colN*cellWidth+colN*colGap;
        int startY = rowN*cellHeight+colGap*rowN+top;
        
        CGRect rc = CGRectMake(startX, startY, cellWidth, cellHeight);
        ScenarioCellView *cell = [[ScenarioCellView alloc] initWithFrame:rc];
        [scroolView addSubview:cell];
        [_sBtns addObject:cell];
        cell.ctrl = self;
        cell.delegate = self;
        
        if(i < [_scenarioArray count])
        {
            Scenario *s = [_scenarioArray objectAtIndex:i];
            [cell fillData:s];
        }
        else
        {
            cell.tag = 401;
            [cell fillData:nil];
        }
        
        index++;
    }
}

- (void) didEndLoadingDiverValues{
    
    EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
    ctrl._scenario = _curSecenario;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

- (void) didButtonCellTapped:(Scenario*)s{
    
    if(s)
    {
        self._curSecenario = s;
        _curSecenario.delegate = self;
        [_curSecenario loadDriverValues];
    }
    else
    {
        NSMutableDictionary *devicesSel = [DataCenter defaultDataCenter]._selectedDevice;
        if(devicesSel)
        {
            EngineerNewTeslariViewCtrl *ctrl = [[EngineerNewTeslariViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else
        {
            EngineerNewTeslariViewCtrl *ctrl = [[EngineerNewTeslariViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
            
            
        }
    }
}

- (void) okAction:(id)sender{
    
    
}


- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt{
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_settingview];
    
    NSString *imageName = [data objectForKey:@"iconbig"];
    UIImage *img = [UIImage imageNamed:imageName];
    if(img)
    {
        for (ScenarioCellView *cell in _sBtns)
        {
            CGRect rect = [self.view convertRect:cell.frame fromView:scroolView];
            if (CGRectContainsPoint(rect, viewPoint)) {

                if(cell.tag != 401)
                    [cell refreshDraggedData:data];
                
                break;
                
            }
        }
    }
    
}


@end










