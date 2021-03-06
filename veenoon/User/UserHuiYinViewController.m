//
//  UserHuiYinViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/27.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserHuiYinViewController.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "RegulusSDK.h"
#import "AudioEMix.h"
#import "AudioEMixProxy.h"
#import "KVNProgress.h"

@interface UserHuiYinViewController () <CenterCustomerPickerViewDelegate>{
    UIButton *_yuyinjiliBtn;
    UIButton *_shedingzhuxiBtn;
    UIButton *_biaozhunmoshiBtn;
    UIButton *_fayanrenshuBtn;
    
    CenterCustomerPickerView *_peoplePicker;
    
    NSString *_zhuxiDaibiao;
}
@end

@implementation UserHuiYinViewController
@synthesize _processor;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"" withTitle:@""];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int rowGap = 240;
    int gap = 15;
    int buttonWidth = 60;
    int buttonHeight = 100;
    int startX = SCREEN_WIDTH/2 - rowGap/2 - buttonWidth+gap;
    int startyY = 280;
    
    _yuyinjiliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yuyinjiliBtn.frame = CGRectMake(startX, startyY, buttonWidth, buttonHeight);
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_n.png"] forState:UIControlStateNormal];
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_s.png"] forState:UIControlStateHighlighted];
    [_yuyinjiliBtn setTitle:@"语音激励" forState:UIControlStateNormal];
    _yuyinjiliBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_yuyinjiliBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
    [_yuyinjiliBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _yuyinjiliBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_yuyinjiliBtn setTitleEdgeInsets:UIEdgeInsetsMake(_yuyinjiliBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_yuyinjiliBtn setImageEdgeInsets:UIEdgeInsetsMake(-50.0,-10,_yuyinjiliBtn.titleLabel.bounds.size.height, 0)];
    [_yuyinjiliBtn addTarget:self action:@selector(yuyinjiliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yuyinjiliBtn];
    
    int rowGap2 = 40;
    int buttonWidth2 = 80;
    int buttonHeight2 = 30;
    int startX2 = SCREEN_WIDTH/2 - rowGap2/2 - buttonWidth2;
    int startyY2 = 480;
    
    _shedingzhuxiBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    _shedingzhuxiBtn.frame = CGRectMake(startX2, startyY2, buttonWidth2, buttonHeight2);
    _shedingzhuxiBtn.layer.cornerRadius = 5;
    _shedingzhuxiBtn.clipsToBounds = YES;
    [_shedingzhuxiBtn setTitle:@"设定主席" forState:UIControlStateNormal];
    _shedingzhuxiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shedingzhuxiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shedingzhuxiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_shedingzhuxiBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shedingzhuxiBtn];
    
    _biaozhunmoshiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _biaozhunmoshiBtn.frame = CGRectMake(startX+rowGap+buttonWidth, startyY, buttonWidth, buttonHeight);
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_n.png"] forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_s.png"] forState:UIControlStateHighlighted];
    [_biaozhunmoshiBtn setTitle:@"标准模式" forState:UIControlStateNormal];
    _biaozhunmoshiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_biaozhunmoshiBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _biaozhunmoshiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_biaozhunmoshiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_biaozhunmoshiBtn.imageView.frame.size.height+15,-85,-20,-20)];
    [_biaozhunmoshiBtn setImageEdgeInsets:UIEdgeInsetsMake(-50.0,-10.0,_biaozhunmoshiBtn.titleLabel.bounds.size.height, 0)];
    [_biaozhunmoshiBtn addTarget:self action:@selector(biaozhunmoshiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_biaozhunmoshiBtn];
    
    _fayanrenshuBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    _fayanrenshuBtn.frame = CGRectMake(startX2+rowGap2+buttonWidth2, startyY2, buttonWidth2, buttonHeight2);
    _fayanrenshuBtn.layer.cornerRadius = 5;
    _fayanrenshuBtn.clipsToBounds = YES;
    [_fayanrenshuBtn setTitle:@"设定代表" forState:UIControlStateNormal];
    _fayanrenshuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_fayanrenshuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fayanrenshuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_fayanrenshuBtn addTarget:self action:@selector(fayanrenshuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fayanrenshuBtn];
    
    _peoplePicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
    _peoplePicker._pickerDataArray = @[@{@"values":@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]}];
    _peoplePicker.hidden = YES;
    [_peoplePicker removeArray];
    [self.view addSubview:_peoplePicker];
    _peoplePicker.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 160);
    [_peoplePicker selectRow:0 inComponent:0];
    _peoplePicker._selectColor = NEW_ER_BUTTON_SD_COLOR;
    _peoplePicker._rowNormalColor = NEW_UR_BUTTON_GRAY_COLOR;
    _peoplePicker.delegate_ = self;
    
    
    if(_processor._proxyObj)
    {
        [self getCurrentDeviceDriverProxys];
    }
    
    
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_processor == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserHuiYinViewController);
    
    RgsDriverObj *driver = _processor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        /*混音会议 - 没有Proxy，直接访问Commands*/
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedHunyinCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}


- (void) loadedHunyinCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _processor._driver;
    
    id proxy = self._processor._proxyObj;
    
    AudioEMixProxy *vpro = nil;
    if(proxy && [proxy isKindOfClass:[AudioEMixProxy class]])
    {
        vpro = proxy;
        
        vpro._deviceId = driver.m_id;
        [vpro checkRgsProxyCommandLoad:cmds];
        
    }
    
    [self updateViewByProxy];
}

- (void) updateViewByProxy {
    if (_processor && _processor._proxyObj) {
        NSString *workMode = _processor._proxyObj._workMode;
        if ([@"语音激励" isEqualToString:workMode]) {
            [_yuyinjiliBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_s.png"] forState:UIControlStateNormal];
            [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_n.png"] forState:UIControlStateNormal];
        } else if ([@"标准模式" isEqualToString:workMode])
        {
            [_biaozhunmoshiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_n.png"] forState:UIControlStateNormal];
            [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_s.png"] forState:UIControlStateNormal];
        } else {
            [_yuyinjiliBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
            [_biaozhunmoshiBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
            
            [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_n.png"] forState:UIControlStateNormal];
        }
        
        NSString *zhuxiDaibiao = _processor._proxyObj._zhuxiDaibiao;
        if ([@"设定主席" isEqualToString:zhuxiDaibiao]) {
            [_shedingzhuxiBtn setSelected:YES];
            _shedingzhuxiBtn.alpha=1;
            [_fayanrenshuBtn setSelected:NO];
            _fayanrenshuBtn.alpha=0.4;
        } else if ([@"设定人数" isEqualToString:zhuxiDaibiao])
        {
            [_shedingzhuxiBtn setSelected:NO];
            _shedingzhuxiBtn.alpha=0.4;
            [_fayanrenshuBtn setSelected:YES];
            _fayanrenshuBtn.alpha=1;
        } else
        {
            [_shedingzhuxiBtn setSelected:NO];
            _shedingzhuxiBtn.alpha=0.4;
            [_fayanrenshuBtn setSelected:NO];
            _fayanrenshuBtn.alpha=0.4;
        }
            
        
        NSMutableDictionary *minMaxDic = [_processor._proxyObj getPriorityMinMax];
        int min = [[minMaxDic objectForKey:@"min"] intValue];
        int max = [[minMaxDic objectForKey:@"max"] intValue];
        
        int count = (max - min) + 1;
        NSMutableArray *pickerArray = [NSMutableArray array];
        for (int index = 0; index < count; index++) {
            [pickerArray addObject:[NSString stringWithFormat:@"%d", min]];
            
            min++;
        }
        _peoplePicker._pickerDataArray = @[@{@"values":pickerArray}];
        _peoplePicker.hidden = NO;
        
        int priority = _processor._proxyObj._fayanPriority;
        
        NSString *priorityStr = [NSString stringWithFormat:@"%d", priority];
        
        //先判断有没有
        if([pickerArray containsObject:priorityStr])
        {
        
            int index = (int) [pickerArray indexOfObject:priorityStr];
            if(index >=0 && index < [pickerArray count])
                [_peoplePicker selectRow:index inComponent:0];
        }
    }
}
-(void) didScrollPickerValue:(NSString*)brand obj:(id)obj{
    if (_peoplePicker) {
        _peoplePicker.hidden = YES;
    }
    
    NSString *priorityValue = brand;
    int priority = [priorityValue intValue];
    
    [_processor._proxyObj controlFayanPriority:priority withType:_zhuxiDaibiao];
}
- (void) fayanrenshuAction:(id)sender{
   
    _peoplePicker.hidden=NO;
    
    [_shedingzhuxiBtn setSelected:NO];
    _shedingzhuxiBtn.alpha=0.4;
    [_fayanrenshuBtn setSelected:YES];
    _fayanrenshuBtn.alpha=1;
    
    _zhuxiDaibiao = @"设定代表";
}
- (void) shedingzhuxiAction:(id)sender{
    
    _peoplePicker.hidden=NO;
    
    [_shedingzhuxiBtn setSelected:YES];
    _shedingzhuxiBtn.alpha=1;
    [_fayanrenshuBtn setSelected:NO];
    _fayanrenshuBtn.alpha=0.4;
    
    _zhuxiDaibiao = @"设定主席";
}

- (void) biaozhunmoshiAction:(id)sender{
    
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_n.png"] forState:UIControlStateNormal];
    [_yuyinjiliBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_s.png"] forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    
    _shedingzhuxiBtn.hidden=YES;
    _fayanrenshuBtn.hidden=YES;
    
    _peoplePicker.hidden=YES;
    
    [_processor._proxyObj controlWorkMode:@"Work"];
}

- (void) yuyinjiliAction:(id)sender{
    [_yuyinjiliBtn setImage:[UIImage imageNamed:@"yuyinjili_s.png"] forState:UIControlStateNormal];
    [_yuyinjiliBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    
    [_biaozhunmoshiBtn setImage:[UIImage imageNamed:@"biaozhunmoshi_n.png"] forState:UIControlStateNormal];
    [_biaozhunmoshiBtn setTitleColor:NEW_UR_BUTTON_GRAY_COLOR forState:UIControlStateNormal];
    _shedingzhuxiBtn.hidden=NO;
    _fayanrenshuBtn.hidden=NO;
    
    _peoplePicker.hidden=YES;
    
    [_processor._proxyObj controlWorkMode:@"Speak"];
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
