//
//  CreateScenarioViewController.m
//  veenoon
//
//  Created by chen jack on 2018/5/13.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "CreateScenarioViewController.h"
#import "DeviceCmdSlice.h"
#import "RegulusSDK.h"
#import "BasePlugElement.h"

#import "EngineerElectronicSysConfigViewCtrl.h"
#import "EngineerPlayerSettingsViewCtrl.h"
#import "EngineerWirlessYaoBaoViewCtrl.h"
#import "EngineerHunYinSysViewController.h"
#import "EngineerHandtoHandViewCtrl.h"
#import "EngineerWirelessMeetingViewCtrl.h"
#import "EngineerAudioProcessViewCtrl.h"
#import "EngineerPVExpendViewCtrl.h"
#import "EngineerDVDViewController.h"
#import "EngineerCameraViewController.h"
#import "EngineerRemoteVideoViewCtrl.h"
#import "EngineerVideoProcessViewCtrl.h"
#import "EngineerVideoPinJieViewCtrl.h"
#import "EngineerTVViewController.h"
#import "EngineerLuBoJiViewController.h"
#import "EngineerTouYingJiViewCtrl.h"
#import "EngineerLightViewController.h"
#import "EngineerAireConditionViewCtrl.h"
#import "EngineerElectronicAutoViewCtrl.h"
#import "EngineerNewWindViewCtrl.h"
#import "EngineerFloorWarmViewCtrl.h"
#import "EngineerAirCleanViewCtrl.h"
#import "EngineerAddWetViewCtrl.h"
#import "EngineerMonitorViewCtrl.h"
#import "EngineerInfoCollectViewCtrl.h"
#import "EngineerScenarioSettingsViewCtrl.h"

#import "UIButton+Color.h"


@interface CreateScenarioViewController () <UITableViewDelegate, UITableViewDataSource, PlugDeviceCtrlDelegate>
{
    UITableView *_tableView;
    int tableWidth;
    
    UIScrollView *_scrollView;
    
    int _top;
}
@property (nonatomic, strong) NSMutableArray *_slices;
@property (nonatomic, strong) NSMutableDictionary *_mapFlash;
@end

@implementation CreateScenarioViewController
@synthesize _slices;
@synthesize _mapFlash;
@synthesize _selectedDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self._mapFlash = [NSMutableDictionary dictionary];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 20,160, 44);
    [self.view addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];

    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, 84, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"TESLARIA";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                             CGRectGetMaxY(portDNSLabel.frame),
                                                             SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:15];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"创建一个新的场景，选择右边的设备，添加场景条件";
    
    int top = CGRectGetMaxY(portDNSLabel.frame)+10;
    
    self._slices = [NSMutableArray array];

    tableWidth = 320;
    
    UIButton* scenarioButton = [UIButton buttonWithColor:YELLOW_COLOR selColor:nil];
    scenarioButton.frame = CGRectMake(SCREEN_WIDTH-120, 84, 100, 40);
    [self.view addSubview:scenarioButton];
    scenarioButton.layer.cornerRadius = 3;
    scenarioButton.clipsToBounds = YES;
    [scenarioButton setTitle:@"生成场景" forState:UIControlStateNormal];
    [scenarioButton setTitleColor:B_GRAY_COLOR forState:UIControlStateNormal];
    //[scenarioButton setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [scenarioButton addTarget:self
                       action:@selector(createScenarioAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                               top,
                                                               tableWidth,
                                                               SCREEN_HEIGHT-top-50)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    UILabel *spLine = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+tableWidth, top, 1, CGRectGetHeight(_tableView.frame))];
    spLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.view addSubview:spLine];
    
    spLine = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT-1, top, 1, CGRectGetHeight(_tableView.frame))];
    spLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    [self.view addSubview:spLine];
    
    
    int w = SCREEN_WIDTH - CGRectGetWidth(_tableView.frame) - 2*ENGINEER_VIEW_LEFT - 30;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tableView.frame)+30,
                                                                         top,
                                                                         w,
                                                                 CGRectGetHeight(_tableView.frame))];
    
    [self.view addSubview:_scrollView];
    
    
    [self showDevices];
}

- (void) createScenarioAction:(id)sender{
    
    
}

- (void) showDevices{
    
    _top = 20;
    
    NSArray *audios = [_selectedDevices objectForKey:@"audio"];
    [self showCells:1000 datas:audios];
    
    NSArray *videos = [_selectedDevices objectForKey:@"video"];
    [self showCells:2000 datas:videos];
    
    NSArray *envs = [_selectedDevices objectForKey:@"env"];
    [self showCells:3000 datas:envs];
    
}


- (void) showCells:(int)tagBase datas:(NSArray*)datas{
    
    int x = 50;
    int CELL_WIDTH =  60;
    int space = 20;
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(x, _top, 200, 30)];
    tL.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:tL];
    tL.font = [UIFont boldSystemFontOfSize:15];
    tL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    if(tagBase == 1000)
    {
        tL.text = @"音频设备";
    }
    else if(tagBase == 2000)
    {
        tL.text = @"视频设备";
    }
    else if(tagBase == 3000)
    {
        tL.text = @"环境设备";
    }
    _top+=40;
    for(int i = 0; i < [datas count]; i++)
    {
        BasePlugElement *plug = [datas objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInteger:[plug getID]] forKey:@"id"];
        [dic setObject:[plug deviceName] forKey:@"name"];
        if(plug._show_icon_name)
            [dic setObject:plug._show_icon_name forKey:@"icon"];
        if(plug._show_icon_sel_name)
            [dic setObject:plug._show_icon_sel_name forKey:@"icon_sel"];
        
        
        NSString *imageStr = [dic objectForKey:@"icon"];
        UIImage *eImg = [UIImage imageNamed:imageStr];
        
        UIButton *cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(x,_top,CELL_WIDTH,CELL_WIDTH)];
        cellBtn.tag = tagBase+i;
    
        [cellBtn setBackgroundImage:eImg forState:UIControlStateNormal];
        
        [_scrollView addSubview:cellBtn];
        [cellBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];

        
        x+=CELL_WIDTH;
        x+=space;
        
        if(x > CGRectGetWidth(_scrollView.frame) - CELL_WIDTH)
        {
            x = 60;
            _top+=CELL_WIDTH;
            _top+=space;
            
        }
        
    }
    
    _top+=CELL_WIDTH;
    _top+=CELL_WIDTH;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width,
                                         _top);
    
    
    
}

- (void) buttonAction:(UIButton*)cellBtn{
    
    int tag = (int)cellBtn.tag;
    int baseTag = tag/1000;
    
    int index = tag%1000;
    
    NSArray *devices = nil;
    if(baseTag == 1)//音频
    {
        devices = [_selectedDevices objectForKey:@"audio"];
    }
    else if(baseTag == 2)//视频
    {
        devices = [_selectedDevices objectForKey:@"video"];
    }
    else
    {
        devices = [_selectedDevices objectForKey:@"env"];
    }
   
    BasePlugElement *plug = [devices objectAtIndex:index];
    
    NSString *name = [plug deviceName];
    
    if ([name isEqualToString:@"8路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 8;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = @[plug];
        }
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    else if ([name isEqualToString:@"16路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 16;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = @[plug];
        }
        ctrl._electronicSysArray = nil;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if(baseTag == 1)
    {
        
        // player array
        if ([name isEqualToString:@"播放器"]) {
            EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
            ctrl._playerSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线麦"]) {
            EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
            ctrl._wirelessYaoBaoSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"混音系统"]) {
            EngineerHunYinSysViewController *ctrl = [[EngineerHunYinSysViewController alloc] init];
            ctrl._hunyinSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"有线会议麦"]) {
            EngineerHandtoHandViewCtrl *ctrl = [[EngineerHandtoHandViewCtrl alloc] init];
            //传
            ctrl._handToHandSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线会议麦"]) {
            EngineerWirelessMeetingViewCtrl *ctrl = [[EngineerWirelessMeetingViewCtrl alloc] init];
            ctrl._wirelessMeetingArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number = 12;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:audio_process_name]) {
            EngineerAudioProcessViewCtrl *ctrl = [[EngineerAudioProcessViewCtrl alloc] init];
            ctrl._audioProcessArray = @[plug];
            ctrl.delegate = self;
            ctrl._isChoosedCmdToScenario = YES;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"功放"]) {
            EngineerPVExpendViewCtrl *ctrl = [[EngineerPVExpendViewCtrl alloc] init];
            ctrl._pvExpendArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else if(baseTag == 2)
    {
        // wuxian array
        if ([name isEqualToString:@"视频播放器"]) {
            EngineerDVDViewController *ctrl = [[EngineerDVDViewController alloc] init];
            ctrl._dvdSysArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            
            ctrl._dvdSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_camera_name]) {
            EngineerCameraViewController *ctrl = [[EngineerCameraViewController alloc] init];
            
            ctrl._cameraSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"远程视讯"]) {
            EngineerRemoteVideoViewCtrl *ctrl = [[EngineerRemoteVideoViewCtrl alloc] init];
            
            ctrl._cameraArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_process_name]) {
            EngineerVideoProcessViewCtrl *ctrl = [[EngineerVideoProcessViewCtrl alloc] init];
            ctrl._videoProcessArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"拼接屏"]) {
            EngineerVideoPinJieViewCtrl *ctrl = [[EngineerVideoPinJieViewCtrl alloc] init];
            ctrl._rowNumber=6;
            ctrl._colNumber=8;
            ctrl._pinjieSysArray = @[plug];// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"液晶电视"]) {
            EngineerTVViewController *ctrl = [[EngineerTVViewController alloc] init];
            ctrl._videoTVArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"录播机"]) {
            EngineerLuBoJiViewController *ctrl = [[EngineerLuBoJiViewController alloc] init];
            ctrl._lubojiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_touying_name]) {
            EngineerTouYingJiViewCtrl *ctrl = [[EngineerTouYingJiViewCtrl alloc] init];
            ctrl._touyingjiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else
    {
        if ([name isEqualToString:@"照明"]) {
            
            EngineerLightViewController *ctrl = [[EngineerLightViewController alloc] init];
            ctrl._lightSysArray = @[plug];// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"空调"]) {
            EngineerAireConditionViewCtrl *ctrl = [[EngineerAireConditionViewCtrl alloc] init];
            ctrl._airSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"电动马达"]) {
            EngineerElectronicAutoViewCtrl *ctrl = [[EngineerElectronicAutoViewCtrl alloc] init];
            ctrl._electronicSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"新风"]) {
            EngineerNewWindViewCtrl *ctrl = [[EngineerNewWindViewCtrl alloc] init];
            ctrl._windSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"地暖"]) {
            EngineerFloorWarmViewCtrl *ctrl = [[EngineerFloorWarmViewCtrl alloc] init];
            ctrl._floorWarmSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"空气净化"]) {
            EngineerAirCleanViewCtrl *ctrl = [[EngineerAirCleanViewCtrl alloc] init];
            ctrl._airCleanSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"加湿器"]) {
            EngineerAddWetViewCtrl *ctrl = [[EngineerAddWetViewCtrl alloc] init];
            ctrl._addWetSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"监控"]) {
            EngineerMonitorViewCtrl *ctrl = [[EngineerMonitorViewCtrl alloc] init];
            ctrl._monitorRoomList = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"能耗统计"]) {
            EngineerInfoCollectViewCtrl *ctrl = [[EngineerInfoCollectViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
}

- (void) didAddToScenarioSlice:(BasePlugElement*)plug cmds:(NSArray*)cmds{
    
    if([cmds count]){
        [_slices addObjectsFromArray:cmds];
        [_tableView reloadData];
    }
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_slices count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    DeviceCmdSlice *data = [_slices objectAtIndex:indexPath.row];
    
    /*
    UIImage *img = [UIImage imageNamed:data._plugicon];
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:img];
    iconImage.frame = CGRectMake(tableWidth-30, 12, 16, 16);
    [cell.contentView addSubview:iconImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFit;
    */
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                10,
                                                                tableWidth-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* subL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              30,
                                                              tableWidth-35, 20)];
    subL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:subL];
    subL.font = [UIFont systemFontOfSize:14];
    subL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    titleL.text = data._deviceName;
    subL.text = [NSString stringWithFormat:@"%@ %@ %@",
                 data._cmdNickName,data._proxyName,data._value];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, tableWidth, 1)];
    line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.2];
    [cell.contentView addSubview:line];
    
    
    if(data)
    {
        UILabel* driverIDL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                       30,
                                                                       tableWidth-20, 20)];
        driverIDL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:driverIDL];
        driverIDL.font = [UIFont systemFontOfSize:12];
        driverIDL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        driverIDL.textAlignment = NSTextAlignmentRight;
        driverIDL.text = [NSString stringWithFormat:@"ID: %d", (int)data.dev_id];
        
    }
    
//    id key = [NSString stringWithFormat:@"%d-%d",
//              (int)indexPath.section,
//              (int)indexPath.row];
//    if(![_mapFlash objectForKey:key])
//    {
//        [_mapFlash setObject:@"1" forKey:key];
//
//        cell.transform = CGAffineTransformMakeTranslation(0, 40);
//        [UIView animateWithDuration:0.5 animations:^{
//
//            cell.transform = CGAffineTransformIdentity;
//        }];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void) cancelAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
