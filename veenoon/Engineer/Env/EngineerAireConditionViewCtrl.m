//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAireConditionViewCtrl.h"
#import "UIButton+Color.h"
#import "AirConditionRightView.h"
#import "CustomPickerView.h"
#import "AirConditionPlug.h"
#import "RegulusSDK.h"
#import "AirConditionProxy.h"
#import "KVNProgress.h"


@interface EngineerAireConditionViewCtrl () <CustomPickerViewDelegate, AirConditionProxyDelegate>{
    
    NSMutableArray  *_nameLabelArray;
    
    BOOL            isSettings;
    UIButton        *okBtn;
    
    NSMutableArray  *buttonArray;
    NSMutableArray  *selectedBtnArray;
    
    AirConditionRightView *_settingView;
}
@property (nonatomic, strong) AirConditionPlug *_currentObj;
@end

@implementation EngineerAireConditionViewCtrl
@synthesize _airSysArray;
@synthesize _number;
@synthesize _currentObj;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isSettings = NO;
    
    if ([_airSysArray count]) {
        self._currentObj = [_airSysArray objectAtIndex:0];
    }
    
    if(_currentObj == nil) {
        self._currentObj = [[AirConditionPlug alloc] init];
    }
    
    _nameLabelArray = [[NSMutableArray alloc] init];
    buttonArray = [[NSMutableArray alloc] init];
    selectedBtnArray = [[NSMutableArray alloc] init];
    
    
   [self showBasePluginName:self._currentObj chooseEnabled:NO];
    [self setTitleAndImage:@"env_corner_kongtiao.png" withTitle:@"空调"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    for (int i = 0; i < 1; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:nil selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        scenarioBtn.layer.borderWidth = 2;
        scenarioBtn.layer.borderColor = [UIColor clearColor].CGColor;
        
        [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
        [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateHighlighted];
        
        scenarioBtn.tag = index;
        [self.view addSubview:scenarioBtn];
        [buttonArray addObject:scenarioBtn];
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        [dataDic setObject:[NSString stringWithFormat:@"%d", index+1] forKey:@"name"];
        
        [scenarioBtn addTarget:self
                        action:@selector(scenarioAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [self createBtnLabel:scenarioBtn dataDic:dataDic];
        index++;
    }
    
    [self getCurrentDeviceDriverProxys];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerAireConditionViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedACDriverProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedACDriverProxy:(NSArray*)proxys{
    
    id proxy = self._currentObj._proxyObj;
    
    AirConditionProxy *vcam = nil;
    if(proxy && [proxy isKindOfClass:[AirConditionProxy class]])
    {
        vcam = proxy;
    }
    else
    {
        vcam = [[AirConditionProxy alloc] init];
    }
    
    vcam._rgsProxyObj = [proxys objectAtIndex:0];
    vcam.delegate = self;
    
    [vcam checkRgsProxyCommandLoad];

    
    self._currentObj._proxyObj = vcam;
    
}

- (void) didLoadedProxyCommand{
    
    AirConditionProxy *proxy = self._currentObj._proxyObj;
    proxy.delegate = nil;
    
    _settingView._models = [proxy acModeSets];
    _settingView._winds = [proxy acWindSets];
    
    [_settingView reloadData];
}

- (void) scenarioAction:(id)sender{
    UIButton *btn = (UIButton*) sender;
    int tag = (int) btn.tag;
    
    UILabel *nameLabel = [_nameLabelArray objectAtIndex:tag];
    
    UIButton *btnn;
    for (UIButton *button in selectedBtnArray) {
        if (button.tag == tag) {
            btnn = button;
            break;
        }
    }
    // want to choose it
    if (btnn) {
        [btnn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
        nameLabel.textColor  = [UIColor whiteColor];
        [selectedBtnArray removeObject:btnn];
    } else {
        [btn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
        nameLabel.textColor  = RGB(230, 151, 50);
        [selectedBtnArray addObject:btn];
    }
}
- (void) createBtnLabel:(UIButton*)sender dataDic:(NSMutableDictionary*) dataDic{
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(sender.frame.size.width/2 - 40, 0, 80, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:11];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [@"Channel " stringByAppendingString:[dataDic objectForKey:@"name"]];
    [_nameLabelArray addObject:titleL];
}

- (void) settingAction:(id)sender{
    
    if(_settingView == nil)
    {
        _settingView = [[AirConditionRightView alloc]
                        initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                 64, 300, SCREEN_HEIGHT-114)];
        
        AirConditionProxy *proxy = self._currentObj._proxyObj;
        proxy.delegate = nil;
        
        _settingView._models = [proxy acModeSets];
        _settingView._winds = [proxy acWindSets];
    }
    
    if([_settingView superview])
    {
        [_settingView removeFromSuperview];
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    }
    else
    {
       [self.view addSubview:_settingView];
        [okBtn setTitle:@"关闭" forState:UIControlStateNormal];
    }

}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

