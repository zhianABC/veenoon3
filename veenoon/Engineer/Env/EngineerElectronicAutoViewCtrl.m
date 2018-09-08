//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerElectronicAutoViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "ElectronicAutoRightView.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "BlindPluginProxy.h"

@interface EngineerElectronicAutoViewCtrl () <CustomPickerViewDelegate, BlindPluginProxyDelegate>{
    
    NSMutableArray *_nameLabelArray;
    
    BOOL isSettings;
    ElectronicAutoRightView *_rightView;
    UIButton *okBtn;
    
    NSMutableArray *buttonArray;
    NSMutableArray *selectedBtnArray;
    
    UIView *_proxysView;
    
    int minCh;
    int maxCh;
}
@end

@implementation EngineerElectronicAutoViewCtrl
@synthesize _electronicSysArray;
@synthesize _number;
@synthesize _currentObj;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isSettings=NO;
    
    if ([_electronicSysArray count]) {
        self._currentObj = [_electronicSysArray objectAtIndex:0];
    }
    
    if (_currentObj == nil) {
        self._currentObj = [[BlindPlugin alloc] init];
        
        BlindPluginProxy *proxy = [[BlindPluginProxy alloc] init];
        proxy._channelNumber = 4;
        self._currentObj._proxyObj = proxy;
    }
    
    _nameLabelArray = [[NSMutableArray alloc] init];
    buttonArray = [[NSMutableArray alloc] init];
    selectedBtnArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"env_corner_diandongmada.png" withTitle:@"电动马达"];
    
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
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int height = 150;
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           height-5,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-height-60)];
    [self.view addSubview:_proxysView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [_proxysView addGestureRecognizer:tapGesture];
    
    [self getCurrentDeviceDriverProxys];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;

#ifdef OPEN_REG_LIB_DEF
    
    [_currentObj syncDriverComs];
    
    IMP_BLOCK_SELF(EngineerElectronicAutoViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
//        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
//            if (result) {
//                if ([proxys count]) {
//
//                    [block_self loadedHunyinProxys:proxys];
//
//                }
//            }
//            else{
//                [KVNProgress showErrorWithStatus:[error description]];
//            }
//        }];
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedBlindCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedBlindCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _currentObj._driver;
    
    id proxy = self._currentObj._proxyObj;
    
    BlindPluginProxy *vpro = nil;
    if(proxy && [proxy isKindOfClass:[BlindPluginProxy class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[BlindPluginProxy alloc] init];
    }
    
    self._currentObj._proxyObj = vpro;
    self._currentObj._proxyObj.delegate = self;
    
    vpro._deviceId = driver.m_id;
    
    
    [vpro checkRgsProxyCommandLoad:cmds];
    
    if([_currentObj._localSavedCommands count])
    {
        NSDictionary *local = [_currentObj._localSavedCommands objectAtIndex:0];
        [vpro recoverWithDictionary:local];
    }
    
    [self createChannels];
    
    vpro._channelNumber = self._number;
}

- (void) createChannels {
    
    self._number = maxCh - minCh + 1;
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    for (int i = 0; i < self._number; i++) {
        
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
}

- (void) didLoadedProxyCommand {
    
    self._currentObj._proxyObj.delegate = nil;
    
    NSDictionary *inputSettings = [self._currentObj._proxyObj getChRecords];
    
    minCh = [[inputSettings objectForKey:@"min"] intValue];
    maxCh = [[inputSettings objectForKey:@"max"] intValue];
}

- (void) handleTapGesture:(id)sender{
    
    if ([_rightView superview]) {
        
        CGRect rc = _rightView.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             _rightView.frame = CGRectMake(SCREEN_WIDTH,
                                                     rc.origin.y,
                                                     rc.size.width,
                                                     rc.size.height);
                         } completion:^(BOOL finished) {
                             [_rightView removeFromSuperview];
                         }];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
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

- (void) okAction:(id)sender{
    if (!isSettings) {
        _rightView = [[ElectronicAutoRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        [self.view addSubview:_rightView];
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

