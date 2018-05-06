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
#import "SIconSelectView.h"
#import "DataBase.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataSync.h"

@interface EngineerScenarioSettingsViewCtrl ()<SIconSelectViewDelegate>{
    
    UIButton *_selectSysBtn;

    SIconSelectView *_settingview;
    
    UIScrollView *scroolView;
    
    NSMutableArray *_scenarioLabelArray;
    
    int topy;
}
@property (nonatomic, strong) NSMutableArray *_sBtns;
@property (nonatomic, strong) NSMutableDictionary *_map;

@end

@implementation EngineerScenarioSettingsViewCtrl
@synthesize _scenarioArray;
@synthesize _sBtns;
@synthesize _map;
@synthesize _room_id;

- (void) initDat {
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self._sBtns = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    _scenarioLabelArray = [[NSMutableArray alloc] init];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"修改" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(okAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:22];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"在场景内，可选择您所需要配置的设备";
    
    topy = CGRectGetMaxY(portDNSLabel.frame)+20;

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
    
    [self.view addSubview:_settingview];

    
    if([_scenarioArray count])
    {
        [self layoutScenarios];
    }
    else
    {
        [self loadSenseFromRegulusCtrl];
    }
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
    
    NSArray* savedScenarios = [[DataBase sharedDatabaseInstance] getSavedScenario:1];
    
    NSMutableDictionary *map = [NSMutableDictionary dictionary];
    for(NSDictionary *senario in savedScenarios)
    {
        int s_driver_id = [[senario objectForKey:@"s_driver_id"] intValue];
        [map setObject:senario forKey:[NSNumber numberWithInt:s_driver_id]];
    }
    
    
    
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
    
    if([_scenarioArray count])
        [self layoutScenarios];
}

- (void) layoutScenarios{
    
    int scenarioSize = (int)[_scenarioArray count] + 1;
    
    int col = 10;
    int leftRightSpace = ENGINEER_VIEW_LEFT;
    int colGap = 10;
    
    int rowNumber = scenarioSize/col + 1;
    
    int cellWidth = 100;
    int cellHeight = 100;
    int top = 5;
    
    scroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftRightSpace,
                                                                topy,
                                                                SCREEN_WIDTH-leftRightSpace*2,
                                                                SCREEN_HEIGHT-240)];
    [self.view addSubview:scroolView];
    
    int scrollHeight = rowNumber*cellHeight + (rowNumber-1)*colGap+10;
    
    scroolView.contentSize = CGSizeMake(SCREEN_WIDTH-leftRightSpace*2, scrollHeight);
    
    int index = 0;
    for (int i = 0; i < scenarioSize; i++) {
        
        int rowN = index/col;
        int colN = index%col;
        int startX = colN*cellWidth+colN*colGap;
        int startY = rowN*cellHeight+colGap*rowN+top;
        
        UIButton *scenarioView = [[UIButton alloc] init];
        [scroolView addSubview:scenarioView];
        
        [_sBtns addObject:scenarioView];
        
        scenarioView.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioView.userInteractionEnabled=YES;
        scenarioView.backgroundColor = DARK_BLUE_COLOR;
        scenarioView.layer.cornerRadius = 5;
        scenarioView.layer.borderWidth = 2;
        scenarioView.layer.borderColor = [UIColor clearColor].CGColor;;
        scenarioView.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [scenarioView addGestureRecognizer:tapGesture];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, scenarioView.frame.size.height/2-15, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [scenarioView addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        if ([_scenarioArray count] == index) {
            titleL.text = @"+";
            titleL.textColor  = DARK_BLUE_COLOR;
            
            scenarioView.backgroundColor = [UIColor clearColor];
            scenarioView.layer.cornerRadius = 5;
            scenarioView.layer.borderWidth = 2;
            scenarioView.layer.borderColor = DARK_BLUE_COLOR.CGColor;;
            scenarioView.clipsToBounds = YES;
        } else {
            UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
            longPress0.view.tag = index;
            [scenarioView addGestureRecognizer:longPress0];
            
            Scenario *s = [self._scenarioArray objectAtIndex:index];
            titleL.text = [[s senarioData] objectForKey:@"name"];
            titleL.textColor  = [UIColor whiteColor];
            
        }
        
        scenarioView.tag = index;
        
        [_scenarioLabelArray addObject:titleL];
        
        index++;
    }
}

- (void) longPressed0:(id)sender {
    UILongPressGestureRecognizer *viewRecognizer = (UILongPressGestureRecognizer*) sender;
    int index = (int)viewRecognizer.view.tag;
    if (index == [self._scenarioArray count]) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入场景名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"场景名称";
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        NSString *scenarioName = envirnmentNameTextField.text;
        if (scenarioName && [scenarioName length] > 0) {
            
            
            Scenario *s = [self._scenarioArray objectAtIndex:index];
            UILabel *scenarioLabel = [_scenarioLabelArray objectAtIndex:index];
            
            NSMutableDictionary *sdic = [s senarioData];
            [sdic setObject:scenarioName
                            forKey:@"name"];
            scenarioLabel.text = scenarioName;
            
            [[DataBase sharedDatabaseInstance] saveScenario:sdic];
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    UIViewController *target = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[EngineerPresetScenarioViewCtrl class]]) {
            target = vc;
            break;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES];
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
    UIImage *img = [UIImage imageNamed:imageName];
    if(img) {
        for (UIButton *button in _sBtns) {
            
            CGRect rect = [self.view convertRect:button.frame fromView:scroolView];
            if (CGRectContainsPoint(rect, viewPoint)) {
                
                [_map setObject:data forKey:[NSNumber numberWithInteger:button.tag]];
                
                [button setBackgroundImage:img
                                  forState:UIControlStateNormal];
                [button setTitle:@"" forState:UIControlStateNormal];
                
                int index = (int)button.tag;
                if(index < [_scenarioArray count])
                {
                    Scenario *s = [self._scenarioArray objectAtIndex:index];
                    
                    NSMutableDictionary *scenarioDic = [s senarioData];
                    [scenarioDic setObject:imageName forKey:@"small_icon"];
                    [[DataBase sharedDatabaseInstance] saveScenario:scenarioDic];
                }
                
                break;
                
            }
        }
    }
    
}


@end










