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

@interface EngineerScenarioSettingsViewCtrl ()<SIconSelectViewDelegate>{
    
    UIButton *_selectSysBtn;
    SIconSelectView *_settingview;
    UIScrollView *scroolView;
    
    int topy;
}
@property (nonatomic, strong) NSMutableArray *_sBtns;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSString* regulus_id;

@end

@implementation EngineerScenarioSettingsViewCtrl
@synthesize _scenarioArray;
@synthesize _sBtns;
@synthesize _map;
@synthesize regulus_id;

- (void) initDat {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACK_COLOR;

    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
    self.regulus_id = room.regulus_id;
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = THEME_COLOR;
    
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
    goHomeBtn.frame = CGRectMake(SCREEN_WIDTH/2-25, 0, 50, 50);
    [bottomBar addSubview:goHomeBtn];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon.png"]
               forState:UIControlStateNormal];
    [goHomeBtn setImage:[UIImage imageNamed:@"gohome_icon_sel.png"]
               forState:UIControlStateHighlighted];
    [goHomeBtn addTarget:self
              action:@selector(gohomeAction:)
    forControlEvents:UIControlEventTouchUpInside];

    _settingview = [[SIconSelectView alloc]
                    initWithFrame:CGRectMake(SCREEN_WIDTH-310,
                                             64, 310, SCREEN_HEIGHT-114)];
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
        [KVNProgress showSuccess];
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
        
        if([map objectForKey:key])
        {
            Scenario *s = [[Scenario alloc] init];
            [s fillWithData:[map objectForKey:key]];
            s._rgsSceneObj = dr;
            
            [_scenarioArray addObject:s];
        }
    }
    
    [KVNProgress showSuccess];
    
    [self layoutScenarios];
}

- (void) layoutScenarios{
    
    int scenarioSize = (int)[_scenarioArray count] + 1;
    
    int col = 5;
    int leftRightSpace = ENGINEER_VIEW_LEFT;
    int colGap = 10;
    
    int rowNumber = scenarioSize/col + 1;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int top = 5;
    
    if(scroolView == nil)
    {
    scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRightSpace,
                                                                topy,
                                                                SCREEN_WIDTH-leftRightSpace*2-300,
                                                                SCREEN_HEIGHT-240)];
        
    }
    else
    {
        [[scroolView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.view insertSubview:scroolView belowSubview:_settingview];
    
    int scrollHeight = rowNumber*cellHeight + (rowNumber-1)*colGap+10;
    
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH-leftRightSpace*2-300, scrollHeight);
    
    [_sBtns removeAllObjects];
    
    int index = 0;
    for (int i = 0; i < scenarioSize; i++) {
        
        int rowN = index/col;
        int colN = index%col;
        int startX = colN*cellWidth+colN*colGap;
        int startY = rowN*cellHeight+colGap*rowN+top;
        
        UIButton *scenarioCellBtn = [UIButton buttonWithColor:DARK_BLUE_COLOR
                                                     selColor:nil];
        [scroolView addSubview:scenarioCellBtn];
        
        [_sBtns addObject:scenarioCellBtn];
        
        scenarioCellBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioCellBtn.layer.cornerRadius = 5;
        scenarioCellBtn.clipsToBounds = YES;
        
        
        [scenarioCellBtn addTarget:self
                         action:@selector(handleTapGesture:)
               forControlEvents:UIControlEventTouchUpInside];
        
        scenarioCellBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        if ([_scenarioArray count] == index) {
            
            [scenarioCellBtn setTitle:@"+" forState:UIControlStateNormal];
            [scenarioCellBtn setTitleColor:DARK_BLUE_COLOR
                               forState:UIControlStateNormal];
            
            [scenarioCellBtn changeNormalColor:[UIColor clearColor]];
            scenarioCellBtn.layer.borderColor = DARK_BLUE_COLOR.CGColor;;
            scenarioCellBtn.clipsToBounds = YES;
            scenarioCellBtn.layer.borderWidth = 2;
            
        } else {
            
            UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
            longPress0.view.tag = index;
            [scenarioCellBtn addGestureRecognizer:longPress0];
            
//            [scenarioCellBtn setTitleEdgeInsets:UIEdgeInsetsMake(70.0, 0, 0, 0)];
//            [scenarioCellBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
//
            
            Scenario *s = [self._scenarioArray objectAtIndex:index];
            NSString *name  = [[s senarioData] objectForKey:@"name"];
            
            
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 70)];
            [scenarioCellBtn addSubview:iconView];
            iconView.tag = 101;
            iconView.contentMode = UIViewContentModeCenter;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(2, 70, cellWidth-4, 1)];
            line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            [scenarioCellBtn addSubview:line];
            
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, cellWidth, 30)];
            titleL.backgroundColor = [UIColor clearColor];
            [scenarioCellBtn addSubview:titleL];
            titleL.font = [UIFont boldSystemFontOfSize:14];
            titleL.textColor  = [UIColor whiteColor];
            titleL.text = name;
            titleL.tag = 102;
            titleL.textAlignment = NSTextAlignmentCenter;
        
            NSString *small = [[s senarioData] objectForKey:@"small_icon"];
            if(small)
            {
                UIImage * img = [UIImage imageNamed:small];
                
                if(img){
                    iconView.image = img;
                }
            }
            
        }
        
        scenarioCellBtn.tag = index;
        
        index++;
    }
}

- (void) longPressed0:(id)sender {
    
    UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
    int index = (int)viewRecognizer.view.tag;
    if (index == [self._scenarioArray count]) {
        return;
    }
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"提示"
                                          message:@"请输入场景名称"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"场景名称";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"英文名称";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([alertController.textFields count] == 2)
        {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            NSString *scenarioName = envirnmentNameTextField.text;
            
            UITextField *enNameTextField = [alertController.textFields objectAtIndex:1];
            NSString *enName = enNameTextField.text;
            
            if (scenarioName && [scenarioName length] > 0 && [enName length])
            {
                Scenario *s = [self._scenarioArray objectAtIndex:index];
                UIButton *scenarioCellBtn = [_sBtns objectAtIndex:index];
                
                NSMutableDictionary *sdic = [s senarioData];
                [sdic setObject:scenarioName
                         forKey:@"name"];
                
                [sdic setObject:enName
                         forKey:@"en_name"];
                
                UILabel *tL = [scenarioCellBtn viewWithTag:102];
                
                if([tL isKindOfClass:[UILabel class]])
                    tL.text = scenarioName;
                
                [s updateProperty];
                
                [[DataBase sharedDatabaseInstance] saveScenario:sdic];
            }
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)handleTapGesture:(UIButton*)sender{
    
    if(sender.tag < [_scenarioArray count])
    {
        Scenario *s = [self._scenarioArray objectAtIndex:sender.tag];
        
        EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
        ctrl._scenario = s;
        [self.navigationController pushViewController:ctrl animated:YES];
        
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
//            EngineerToUseTeslariViewCtrl *ctrl = [[EngineerToUseTeslariViewCtrl alloc] init];
//            ctrl._meetingRoomDic = roomDic;
//            [self.navigationController pushViewController:ctrl animated:YES];

            EngineerNewTeslariViewCtrl *ctrl = [[EngineerNewTeslariViewCtrl alloc] init];
            //ctrl._selectedDevices = _selectedDevices;
            [self.navigationController pushViewController:ctrl animated:YES];
            
            
            
//            EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
//            ctrl._meetingRoomDic =roomDic;
//            [self.navigationController pushViewController:ctrl animated:YES];

            
        }
        
    }

}
- (void) okAction:(id)sender{
    
    
}


- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt{
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_settingview];
    
    //    viewPoint.x -= CGRectGetMinX(scroolView.frame);
    //    viewPoint.y -= CGRectGetMinY(scroolView.frame);
    //
    NSString *imageName = [data objectForKey:@"iconbig"];
    NSString *icon_user = [data objectForKey:@"icon_user"];
    NSString *title = [data objectForKey:@"title"];
    NSString *en_name = [data objectForKey:@"en_name"];
    UIImage *img = [UIImage imageNamed:imageName];
    if(img) {
        for (UIButton *button in _sBtns) {
            
            CGRect rect = [self.view convertRect:button.frame fromView:scroolView];
            if (CGRectContainsPoint(rect, viewPoint)) {
                
                [_map setObject:data forKey:[NSNumber numberWithInteger:button.tag]];
                
    
                UIImageView *icon = [button viewWithTag:101];
                if([icon isKindOfClass:[UIImageView class]])
                    icon.image = img;
                
                
                int index = (int)button.tag;
                if(index < [_scenarioArray count])
                {
                    Scenario *s = [self._scenarioArray objectAtIndex:index];
                    
                    NSMutableDictionary *scenarioDic = [s senarioData];
                    [scenarioDic setObject:imageName forKey:@"small_icon"];
                    [scenarioDic setObject:icon_user forKey:@"icon_user"];
                    [scenarioDic setObject:title forKey:@"name"];
                    
                    if(en_name)
                    [scenarioDic setObject:en_name
                             forKey:@"en_name"];
                    
                    UILabel *tL = [button viewWithTag:102];
                    
                    if([tL isKindOfClass:[UILabel class]])
                        tL.text = title;
                    
                    [s updateProperty];
                    
                    [[DataBase sharedDatabaseInstance] saveScenario:scenarioDic];
                }
                
                break;
                
            }
        }
    }
    
}


@end










