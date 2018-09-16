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
}
@property (nonatomic, strong) NSMutableArray *_autoItems;

@property (nonatomic, strong) NSMutableArray *_subscribeItems;
@property (nonatomic, strong) NSMutableArray *_weekItems;

@property (nonatomic, strong) NSMutableArray *_autoRunCells;

@end

@implementation AutoRunViewController
@synthesize _autoItems;
@synthesize _room;
@synthesize _scenarios;

@synthesize _subscribeItems;
@synthesize _weekItems;

@synthesize _autoRunCells;


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
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(SCREEN_WIDTH-120, 40, 60, 40);
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
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
    btnChuangan.frame = CGRectMake(80, SCREEN_HEIGHT - 50, 60, 50);
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"]
            forState:UIControlStateHighlighted];
    [self.view addSubview:btnChuangan];
    btnChuangan.center = CGPointMake(80, btnChuangan.center.y);
    [btnChuangan addTarget:self
               action:@selector(chuanganAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    btnPre = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPre.frame = CGRectMake(60, SCREEN_HEIGHT - 50, 60, 50);
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
    btnWeek.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT - 50, 60, 50);
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week.png"]
             forState:UIControlStateHighlighted];
    [self.view addSubview:btnWeek];
    btnWeek.center = CGPointMake(SCREEN_WIDTH-80, btnWeek.center.y);
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
    
    _auto_mode = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyRefreshItems:)
                                                 name:@"Notify_Refresh_Items"
                                               object:nil];
    
    [self getSchedules];
    
}

- (void) autoPreAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_n.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 0;
    
    [self layoutAutoCells];
    
    titleL.text = @"预约设置";
}

- (void) editAction:(id)sender{
    
    
    _isEdit = !_isEdit;
    
    for(AutoRunCell *cell in _autoRunCells)
    {
        [cell setEditMode:_isEdit];
    }
    
}

- (void) chuanganAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre_w.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_s.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week_w.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 0;
    
//    [self layoutAutoCells];
    
    titleL.text = @"传感器设置";
}

- (void) autoWeekAction:(id)sender{
    
    [btnPre setImage:[UIImage imageNamed:@"auto_run_pre_w.png"]
            forState:UIControlStateNormal];
    [btnChuangan setImage:[UIImage imageNamed:@"auto_chuangan_n.png"] forState:UIControlStateNormal];
    [btnWeek setImage:[UIImage imageNamed:@"auto_run_week.png"]
             forState:UIControlStateNormal];
    
    _auto_mode = 1;
    
    [self layoutAutoCells];
    
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
    
    NSMutableArray  *items = _subscribeItems;
    if(_auto_mode == 1)
    {
        items = _weekItems;
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
        else
        {
            UIButton *btn = [UIButton buttonWithColor:RGB(0x52, 0x4e, 0x4b)
                                             selColor:nil];
            btn.frame = CGRectMake(x, y, cellWidth, cellWidth);
            [_content addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.clipsToBounds = YES;
            btn.tag = i;
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:btn.bounds];
            titleL.backgroundColor = [UIColor clearColor];
            [btn addSubview:titleL];
            titleL.font = [UIFont systemFontOfSize:16];
            titleL.textColor  = [UIColor whiteColor];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.numberOfLines = 2;
            
            titleL.text = [sche objectForKey:@"name"];
            [btn addTarget:self
                    action:@selector(buttonAddAction:)
          forControlEvents:UIControlEventTouchUpInside];
            
            titleL.font = [UIFont systemFontOfSize:24];
            
        }
        
    }
}

- (void) tappedAutoRunCell:(RgsSchedulerObj*)sch{
    
    [self showAutoRunView:sch];

}

- (void) deleteAutoRunCell:(RgsSchedulerObj*)sch{
    
    IMP_BLOCK_SELF(AutoRunViewController);
    if(sch)
    {
    [[RegulusSDK sharedRegulusSDK] DelSchedulerByID:sch.m_id
                                         completion:^(BOOL result, NSError *error) {
                                            
                                             [block_self getSchedules];
                                         }];
    }
}

- (void) notifyRefreshItems:(id)sender{

    [self getSchedules];
}

- (void) buttonAddAction:(UIButton*)sender{
    
    [self showAutoRunView:nil];
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
    else
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
