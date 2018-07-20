//
//  EngineerScenarioListViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/12.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerScenarioListViewCtrl.h"
#import "UIButton+Color.h"
#import "EngineerPresetScenarioViewCtrl.h"
#import "SIconSelectView.h"
#import "DataSync.h"
#import "RegulusSDK.h"
#import "EngineerNewTeslariViewCtrl.h"


@interface EngineerScenarioListViewCtrl () <SIconSelectViewDelegate>
{
    
    UIScrollView *scroolView;
    SIconSelectView *_settingview;
}
@property (nonatomic, strong) NSMutableArray *_sBtns;
@property (nonatomic, strong) NSMutableDictionary *_map;

@end

@implementation EngineerScenarioListViewCtrl
@synthesize _sBtns;
@synthesize _map;
@synthesize _selectedDevices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACK_COLOR;
    
    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                                      ENGINEER_VIEW_TOP+10,
                                                                      SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:22];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"新建场景";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame) + 20, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"在场景内，可选择你需要配置的设备";
    
    NSMutableArray *scenarioArray = [_meetingRoomDic objectForKey:@"scenarioArray"];
    
    scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                CGRectGetMaxY(portDNSLabel.frame) + 20,
                                                                SCREEN_WIDTH,
                                                                SCREEN_HEIGHT-(CGRectGetMaxY(portDNSLabel.frame) + 20))];
    scroolView.userInteractionEnabled=YES;
    scroolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroolView];
    
    int top = 10;
    int leftRight = 60;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int colNumber = 8;
    int space = (SCREEN_WIDTH - colNumber*cellWidth-leftRight*2)/(colNumber-1);
    
    int rowNumber = (int)[scenarioArray count] / colNumber + 1;
    int scrollHeight = rowNumber * cellHeight + (rowNumber-1)*space + top;
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH - 2*leftRight, scrollHeight);
    
    // add new button to the last of array
    NSMutableDictionary *newScenarioDic = [[NSMutableDictionary alloc] init];
    [scenarioArray addObject:newScenarioDic];
    
    int index = 0;
    int startY = 20;
    UIButton *scenarioBtn = [UIButton buttonWithColor:nil selColor:RGB(0, 89, 118)];
    scenarioBtn.layer.cornerRadius = 15;
    scenarioBtn.layer.borderWidth = 2;
    scenarioBtn.layer.borderColor = [UIColor clearColor].CGColor;
    scenarioBtn.clipsToBounds=YES;
    scenarioBtn.frame = CGRectMake(ENGINEER_VIEW_LEFT, startY, cellWidth, cellHeight);
    [scenarioBtn setImage:[UIImage imageNamed:@"engineer_scenario_add_n.png"] forState:UIControlStateNormal];
    [scenarioBtn setImage:[UIImage imageNamed:@"engineer_scenario_add_n.png"] forState:UIControlStateHighlighted];
    scenarioBtn.tag = index;
    [scroolView addSubview:scenarioBtn];
    
    [scenarioBtn addTarget:self
                    action:@selector(addAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
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
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomBar];
}

- (void) okAction:(id)sender{
    
    [self.view addSubview:_settingview];
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addAction:(id)sender{
    
//    RgsDriverInfo *info = [[DataSync sharedDataSync]._mapDrivers
//                           objectForKey:@"System-Regulus-Regulus Scene"];
//    if(info)
//    {
//        RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
//        if(area)
//        {
//            IMP_BLOCK_SELF(EngineerScenarioListViewCtrl);
//
//            [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
//                                                 serial:info.serial
//                                             completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
//                if (result)
//                {
//                    [block_self gotoCreateNewScenario];
//                }
//                else{
//
//                }
//            }];
//        }
//    }
    
    [self gotoCreateNewScenario];
}

- (void) gotoCreateNewScenario{
    
    
//    EngineerNewTeslariViewCtrl *ctrl = [[EngineerNewTeslariViewCtrl alloc] init];
//    ctrl._meetingRoomDic = self._meetingRoomDic;
//    //ctrl._selectedDevices = _selectedDevices;
//    [self.navigationController pushViewController:ctrl animated:YES];

    
    EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
    ctrl._selectedDevices = _selectedDevices;
    [self.navigationController pushViewController:ctrl animated:YES];
//
}

- (void) didMoveDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt{
    
 //   CGPoint viewPoint = [self.view convertPoint:pt fromView:_settingview];
    
//    CGRect rc = _settingview.frame;
//
//    if(viewPoint.x < rc.origin.x && !_settingview.hidden )
//    {
//
//        //rc.origin.x = SCREEN_WIDTH;
//        [UIView beginAnimations:nil context:nil];
//        //_settingview.hidden = YES;
//        [UIView commitAnimations];
//    }
    
}

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt{
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_settingview];
    
//    viewPoint.x -= CGRectGetMinX(scroolView.frame);
//    viewPoint.y -= CGRectGetMinY(scroolView.frame);
//
    NSString *imageName = [data objectForKey:@"iconbig"];
    UIImage *img = [UIImage imageNamed:imageName];
    if(img) {
        for (UIButton *button in _sBtns) {
            
            CGRect rect = [self.view convertRect:button.frame fromView:scroolView];
            if (CGRectContainsPoint(rect, viewPoint)) {
                
                [_map setObject:data forKey:[NSNumber numberWithInteger:button.tag]];
                
                [button setBackgroundImage:img
                                  forState:UIControlStateNormal];
                [button setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
}


@end
