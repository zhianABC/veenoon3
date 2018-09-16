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


@interface EngineerScenarioSettingsViewCtrl ()<SIconSelectViewDelegate, ScenarioDelegate, ScenarioCellViewDelegate>{
    
    UIButton *_selectSysBtn;
    SIconSelectView *_settingview;
    UIScrollView *scroolView;
    
    UIButton *iBtn;
    
    int topy;
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


- (void) initDat {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;

    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    self.regulus_id = room.regulus_id;
    
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
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(backAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                                      ENGINEER_VIEW_TOP,
                                                                      SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"在场景内，可选择您所需要配置的设备";
    
    topy = CGRectGetMaxY(portDNSLabel.frame)+20;

    UIButton *goHomeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goHomeBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0, 160, 50);
    [bottomBar addSubview:goHomeBtn];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon.png"]
               forState:UIControlStateNormal];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon_sel.png"]
               forState:UIControlStateHighlighted];
    [goHomeBtn addTarget:self
              action:@selector(gohomeAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    iBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:iBtn];
    [iBtn setImage:[UIImage imageNamed:@"i_btn_white.png"]
          forState:UIControlStateNormal];
    [iBtn addTarget:self
             action:@selector(iconAction:)
   forControlEvents:UIControlEventTouchUpInside];
    iBtn.center = CGPointMake(SCREEN_WIDTH/2, iBtn.center.y);

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
        cancelBtn.hidden = YES;
        [self loadSenseFromRegulusCtrl];
    }
    
    //获取Regulus支持的插件
    [[DataSync sharedDataSync] syncRegulusDrivers];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyReloadScenario:)
                                                 name:@"Notify_Reload_Senario"
                                               object:nil];
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

- (void) gohomeAction:(id)sender{
    
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

                [cell refreshDraggedData:data];
                
                break;
                
            }
        }
    }
    
}


@end










