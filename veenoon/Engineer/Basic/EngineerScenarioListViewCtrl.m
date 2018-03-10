//
//  EngineerScenarioListViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/12.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerScenarioListViewCtrl.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"
#import "EngineerPresetScenarioViewCtrl.h"
#import "SIconSelectView.h"

@interface EngineerScenarioListViewCtrl () <SIconSelectViewDelegate>
{
    
    UIScrollView *scroolView;
    SIconSelectView *_settingview;
}
@property (nonatomic, strong) NSMutableArray *_sBtns;
@property (nonatomic, strong) NSMutableDictionary *_map;

@end

@implementation EngineerScenarioListViewCtrl
@synthesize _meetingRoomDic;
@synthesize _sBtns;
@synthesize _map;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:22];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
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
    int arraySize = (int)[scenarioArray count];
    
    int startX = 100;
    int startY = 20;
    UIButton *scenarioBtn = [UIButton buttonWithColor:nil selColor:RGB(0, 89, 118)];
    scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
    scenarioBtn.layer.cornerRadius = 5;
    scenarioBtn.layer.borderWidth = 2;
    scenarioBtn.layer.borderColor = [UIColor whiteColor].CGColor;;
    scenarioBtn.clipsToBounds = YES;
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
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _settingview = [[SIconSelectView alloc]
           initWithFrame:CGRectMake(SCREEN_WIDTH-310,
                                    64, 310, SCREEN_HEIGHT-114)];
    _settingview.delegate = self;
    
    
    [self.view addSubview:bottomBar];
}

- (void) okAction:(id)sender{
    
    [self.view addSubview:_settingview];
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addAction:(id)sender{
    
    EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void) scenarioAction:(id)sender{
    UIButton *btn = (UIButton*) sender;
    int tag = (int)btn.tag;
    int count = (int)[[self._meetingRoomDic objectForKey:@"scenarioArray"] count];
    if (tag+1 == count) {
        EngineerPresetScenarioViewCtrl *ctrl = [[EngineerPresetScenarioViewCtrl alloc] init];
        ctrl._meetingRoomDic = self._meetingRoomDic;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
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

-(void) initData {
    if (_meetingRoomDic) {
        [_meetingRoomDic removeAllObjects];
    } else {
        _meetingRoomDic = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *scenarioArray = [_meetingRoomDic objectForKey:@"scenarioArray"];
    
    NSMutableDictionary *scenarioDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议1", @"scenarioName",
    nil];
    NSMutableDictionary *scenarioDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议2", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议3", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议4", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议5", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议6", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议7", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic8 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议8", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic9 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议9", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic10 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议10", @"scenarioName",
                                         nil];
    NSMutableDictionary *scenarioDic11 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"离开会议11", @"scenarioName",
                                         nil];
    scenarioArray = [NSMutableArray arrayWithObjects:scenarioDic, scenarioDic2, scenarioDic3, scenarioDic4, scenarioDic5, scenarioDic6, scenarioDic7, scenarioDic8, scenarioDic9, scenarioDic10, scenarioDic11, nil];
    
    [_meetingRoomDic setObject:scenarioArray forKey:@"scenarioArray"];
}

@end
