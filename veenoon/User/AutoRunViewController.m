//
//  AutoRunViewController.m
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AutoRunViewController.h"
#import "UIButton+Color.h"
#import "AutoRunSetView.h"
#import "MeetingRoom.h"
#import "Scenario.h"
#import "DataBase.h"
#import "RegulusSDK.h"
#import "AutoRunCell.h"
#import "KVNProgress.h"
#import "ChuanGanAutoSetView.h"
#import "DataSync.h"
#import "UserSensorObj.h"
#import "Utilities.h"

@interface AutoRunViewController () <AutoRunCellDelegate>
{
    UIScrollView *_content;
    
    int cellWidth;
    
    int _auto_mode;
    
    UIButton *btnChuangan;
    UIButton *btnPre;
    UIButton *btnWeek;
    
    UILabel* titleL;
    
    BOOL _isEdit;
    
    UIButton *editBtn;
    UIButton *addBtn;
}
@property (nonatomic, strong) NSMutableArray *_autoItems;

@property (nonatomic, strong) NSMutableArray *_subscribeItems;
@property (nonatomic, strong) NSMutableArray *_weekItems;
@property (nonatomic, strong) NSMutableArray *_envItems;

@property (nonatomic, strong) NSMutableArray *_autoRunCells;

@property (nonatomic, strong) NSMutableArray *_sensors;

@end

@implementation AutoRunViewController
@synthesize _autoItems;
@synthesize _room;
@synthesize _scenarios;

@synthesize _subscribeItems;
@synthesize _weekItems;
@synthesize _envItems;

@synthesize _autoRunCells;

@synthesize _sensors;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(SCREEN_WIDTH-120, 40, 60, 40);
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [editBtn addTarget:self action:@selector(editAction:)
      forControlEvents:UIControlEventTouchUpInside];

    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, SCREEN_WIDTH-100, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"传感器设置";
    
    
    btnChuangan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChuangan.frame = CGRectMake(120, SCREEN_HEIGHT - 50, 120, 50);
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"]
            forState:UIControlStateHighlighted];
    [self.view addSubview:btnChuangan];
    btnChuangan.center = CGPointMake(120, btnChuangan.center.y);
    [btnChuangan addTarget:self
               action:@selector(chuanganAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    btnPre = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPre.frame = CGRectMake(60, SCREEN_HEIGHT - 50, 120, 50);
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre_w.png"]
              forState:UIControlStateNormal];
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre.png"]
              forState:UIControlStateHighlighted];
    [self.view addSubview:btnPre];
    btnPre.center = CGPointMake(SCREEN_WIDTH/2, btnPre.center.y);
    [btnPre addTarget:self
                 action:@selector(autoPreAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    btnWeek = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWeek.frame = CGRectMake(SCREEN_WIDTH-120, SCREEN_HEIGHT - 50, 120, 50);
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnWeek];
    btnWeek.center = CGPointMake(SCREEN_WIDTH-120, btnWeek.center.y);
    [btnWeek addTarget:self
                action:@selector(autoWeekAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    self._autoItems = [NSMutableArray array];
    cellWidth = 110;
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100,
                                                              SCREEN_WIDTH,
                                                              SCREEN_HEIGHT-100-50)];
    [self.view addSubview:_content];
    _content.clipsToBounds = YES;
    
    //
    
    _auto_mode = 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyRefreshItems:)
                                                 name:@"Notify_Refresh_Items"
                                               object:nil];
    
    //[self getSchedules];
    [self getEnvAutoSet];
    
    self._sensors = [NSMutableArray array];
    [self getSensorDrivers];
    
}

- (void) getSensorDrivers {

    RgsAreaObj *areaObj = [DataSync sharedDataSync]._currentArea;
    NSInteger area_id = areaObj.m_id;
    
    NSMutableArray *sensorArray = [NSMutableArray array];
    
    
    [[RegulusSDK sharedRegulusSDK] GetDrivers:area_id
                                   completion:^(BOOL result,NSArray * drivers,NSError * error) {
                                       if (result) {
                                           for (RgsDriverObj *driverObj in drivers) {
                                               if ([@"Sensor" isEqualToString:driverObj.info.system]) {
                                                   [sensorArray addObject:driverObj];
                                               }
                                           }
                                           IMP_BLOCK_SELF(AutoRunViewController);
                                           
                                           [block_self getDriverConnection:sensorArray];
                                       }
                                   }];
}
- (void) getDriverConnection:(NSMutableArray*)driverArray {
    
    for (RgsDriverObj *driverObj in driverArray) {
        
        UserSensorObj *userSensor = [[UserSensorObj alloc] init];
        userSensor.rgsDriverObj = driverObj;
        [_sensors addObject:userSensor];
    }
    
}

- (void) getEnvAutoSet{
 
    IMP_BLOCK_SELF(AutoRunViewController);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetAutomation:^(BOOL result, NSArray<RgsAutomationObj *> *auto_objs, NSError *error) {
            [block_self layoutAutoEnvItems:auto_objs];
        
    }];
}

- (void) layoutAutoEnvItems:(NSArray*)auto_objs{
    
    [KVNProgress dismiss];
    
    self._envItems = [NSMutableArray array];
    
    if(auto_objs)
    [self._envItems addObjectsFromArray:auto_objs];
    [self._envItems addObject:@{@"name":@"+", @"type":@"1"}];
    
    [self layoutAutoCells];
}

- (void) autoPreAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_n.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 0;
    
    if([_autoItems count] == 0)
    {
        [self getSchedules];
    }
    else
    {
        [self layoutAutoCells];
    }
    
    
    titleL.text = @"预约设置";
}

- (void) editAction:(id)sender{
    
    
    _isEdit = !_isEdit;
    
    if(_isEdit)
    {
        addBtn.hidden = YES;
        [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        for(AutoRunCell *cell in _autoRunCells)
        {
            [cell setEditMode:_isEdit];
        }
        
    }
    else
    {
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        if(_auto_mode < 2)
        {
            [self getSchedules];
        }
        else
        {
            [self getEnvAutoSet];
        }
    
    }
    
}

- (void) chuanganAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre_w.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 2;
    
    [self layoutAutoCells];
    
    titleL.text = @"传感器设置";
}

- (void) autoWeekAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre_w.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_n.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 1;
    
    if([_autoItems count] == 0)
    {
        [self getSchedules];
    }
    else
    {
        [self layoutAutoCells];
    }
    
    
    titleL.text = @"日程设置";
}

- (void) getSchedules{
    
    IMP_BLOCK_SELF(AutoRunViewController);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetSchedulers:^(BOOL result, NSArray * schedulers, NSError * error) {
 
        [block_self loadAutoItems:schedulers];
        
    }];
}

- (void) loadAutoItems:(NSArray*)datas{
    
    [KVNProgress dismiss];
    
    [_autoItems removeAllObjects];
    [_autoItems addObjectsFromArray:datas];
    
    self._subscribeItems = [NSMutableArray array];
    self._weekItems = [NSMutableArray array];
    
    for(RgsSchedulerObj *sch in _autoItems)
    {
        if([sch.week_items count])
        {
            [_weekItems addObject:sch];
        }
        else
        {
            [_subscribeItems addObject:sch];
        }
    }
    [_subscribeItems addObject:@{@"name":@"+", @"type":@"1"}];
    [_weekItems addObject:@{@"name":@"+", @"type":@"1"}];
    
    [self layoutAutoCells];
}

- (void) layoutAutoCells{
    
    [[_content subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self._autoRunCells = [NSMutableArray array];
    
    int left = (SCREEN_WIDTH - 15*6 - cellWidth*7)/2;
    
    int x = left;
    int y = 0;
    
    NSArray  *items = _subscribeItems;
    if(_auto_mode == 1)
    {
        items = _weekItems;
    }
    else if(_auto_mode == 2)
    {
        items = _envItems;
    }
    for(int i = 0; i < [items count]; i++)
    {
        id sche = [items objectAtIndex:i];
        
        int row = i/7;
        int col = i%7;
        
        x = col * (cellWidth+15) + left;
        y = row * (cellWidth+15) + 15;
        
        if([sche isKindOfClass:[RgsSchedulerObj class]])
        {
            RgsSchedulerObj *sch = sche;
            
            AutoRunCell *at = [[AutoRunCell alloc]
                               initWithFrame:CGRectMake(x, y, cellWidth, cellWidth)];
            [_content addSubview:at];
            at.button.tag = i;
            at.delegate = self;
            
            [at showRgsSchedule:sch];
            
            [_autoRunCells addObject:at];
        }
        else if([sche isKindOfClass:[RgsAutomationObj class]])
        {
            RgsAutomationObj *sch = sche;
            
            AutoRunCell *at = [[AutoRunCell alloc]
                               initWithFrame:CGRectMake(x, y, cellWidth, cellWidth)];
            [_content addSubview:at];
            at.button.tag = i;
            at.delegate = self;
            
            [at showRgsAutoRun:sch];
            
            [_autoRunCells addObject:at];
        }
        else
        {
            addBtn = [UIButton buttonWithColor:RGB(0x52, 0x4e, 0x4b)
                                             selColor:nil];
            addBtn.frame = CGRectMake(x, y, cellWidth, cellWidth);
            [_content addSubview:addBtn];
            addBtn.layer.cornerRadius = 5;
            addBtn.clipsToBounds = YES;
            addBtn.tag = i;
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:addBtn.bounds];
            titleL.backgroundColor = [UIColor clearColor];
            [addBtn addSubview:titleL];
            titleL.font = [UIFont systemFontOfSize:16];
            titleL.textColor  = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.numberOfLines = 2;
            
            titleL.text = [sche objectForKey:@"name"];
            [addBtn addTarget:self
                    action:@selector(buttonAddAction:)
          forControlEvents:UIControlEventTouchUpInside];
            
            titleL.font = [UIFont systemFontOfSize:24];
            
        }
        
    }
}

- (void) tappedAutoRunCell:(RgsSchedulerObj*)sch{
    
    [self showAutoRunView:sch];

}

- (void) deleteAutoRunCell:(id)sch view:(UIView*)cell{
    
    //IMP_BLOCK_SELF(AutoRunViewController);
    if(sch)
    {
        if(_auto_mode < 2)
        {
            RgsSchedulerObj *rgssch = sch;
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] DelSchedulerByID:rgssch.m_id
                                                 completion:^(BOOL result, NSError *error) {
                                                     
                                                     if(result)
                                                     {
                                                         [cell removeFromSuperview];
                                                     }
                                                     
                                                     [KVNProgress dismiss];
                                                     
                                                     //[block_self getSchedules];
                                                 }];
        }
        else
        {
            RgsAutomationObj *rgsato = sch;
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] DelAutomation:rgsato.m_id completion:^(BOOL result, NSError *error) {
                
                if(result)
                {
                    [cell removeFromSuperview];
                }
                
                [KVNProgress dismiss];
                
            }];
        }
    }
}

- (void) notifyRefreshItems:(id)sender{

    if(_auto_mode < 2)
        [self getSchedules];
    else
        [self getEnvAutoSet];
}

- (void) buttonAddAction:(UIButton*)sender{
    
    if ([self._scenarios count]) {
        [self showAutoRunView:nil];
    } else {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                    message:@"当前系统没有存储任何场景."
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles: nil];
        [av show];
    }
}


- (void) showAutoRunView:(RgsSchedulerObj*)sch{
    
    if(_auto_mode == 0)
    {
        AutoRunSetView *autoView = [[AutoRunSetView alloc] initWithDateAndTime:CGRectMake(0,
                                                                                          0,
                                                                                          SCREEN_WIDTH,
                                                                                          SCREEN_HEIGHT)];
        [self.view addSubview:autoView];
        autoView._scenarios = _scenarios;
        autoView._schedule = sch;
        
        [autoView show];
    }
    else if (_auto_mode == 1)
    {
        AutoRunSetView *autoView = [[AutoRunSetView alloc] initWithWeeks:CGRectMake(0,
                                                                                    0,
                                                                                    SCREEN_WIDTH,
                                                                                    SCREEN_HEIGHT)];
        [self.view addSubview:autoView];
        autoView._scenarios = _scenarios;
        autoView.ctrl = self;
        autoView._schedule = sch;
        
        [autoView show];
    } else {
        
        if([_sensors count])
        {
        
            ChuanGanAutoSetView *autoView = [[ChuanGanAutoSetView alloc] initWithPicker:CGRectMake(0,
                                                                                                   0,
                                                                                                   SCREEN_WIDTH,
                                                                                                   SCREEN_HEIGHT) withScnearios:_scenarios];
            [self.view addSubview:autoView];
            autoView._scenarios = _scenarios;
            autoView.ctrl = self;
            autoView._schedule = sch;
            autoView._sensor = [_sensors objectAtIndex:0];
            
            [autoView show];
        }
        else
        {
            [Utilities showMessage:@"没有添加传感器设备"
                              ctrl:self];
        }
    }
}


- (void)backAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
