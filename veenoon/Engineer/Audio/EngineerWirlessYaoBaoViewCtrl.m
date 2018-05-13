//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerWirlessYaoBaoViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "SlideButton.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "WirlessYaoBaoViewSettingsView.h"
#import "AudioEWirlessMike.h"
#import "PlugsCtrlTitleHeader.h"

@interface EngineerWirlessYaoBaoViewCtrl () <CustomPickerViewDelegate, EngineerSliderViewDelegate, SlideButtonDelegate> {

    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_imageViewArray;
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
    NSMutableArray *_signalLabelArray;
    NSMutableArray *_signalViewArray;
    NSMutableArray *_dianchiArray;
    NSMutableArray *_huatongArray;
    
    WirlessYaoBaoViewSettingsView *_rightSetView;
    
    UIButton *okBtn;
    
    NSMutableArray *signalArray;
    
    UIView *_proxysView;
}

@property (nonatomic, strong) AudioEWirlessMike *_curMike;
@property (nonatomic, strong) NSMutableArray *_channels;

@end

@implementation EngineerWirlessYaoBaoViewCtrl
@synthesize _wirelessYaoBaoSysArray;
@synthesize _number;
@synthesize _curMike;
@synthesize _channels;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _imageViewArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    signalArray = [[NSMutableArray alloc] init];
    _signalLabelArray = [[NSMutableArray alloc] init];
    _signalViewArray = [[NSMutableArray alloc] init];
    _dianchiArray = [[NSMutableArray alloc] init];
    _huatongArray = [[NSMutableArray alloc] init];
    
    self._channels = [NSMutableArray array];
    
    if([_wirelessYaoBaoSysArray count]){
        self._curMike = [_wirelessYaoBaoSysArray objectAtIndex:0];
        
        //把所有设备的Channel放入数组
        for(AudioEWirlessMike *mike in _wirelessYaoBaoSysArray)
        {
            [_channels addObjectsFromArray:[mike channles]];
        }
    }
    
    [super setTitleAndImage:@"audio_corner_huatong.png" withTitle:@"无线麦"];
    
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
              action:@selector(settingAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _zengyiSlider = [[EngineerSliderView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi_n.png"]
                       frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 20;
    _zengyiSlider.minValue = -20;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 150, SCREEN_HEIGHT/2);
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 120;
    int cellHeight = 240;
    int colNumber = ENGINEER_VIEW_COLUMN_N-2;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    
    if([_channels count])
    {
        int max = (int)[_channels count];
        
        for (int i = 0; i < max; i++) {
            NSMutableDictionary *dataDic = [_channels objectAtIndex:i];
            
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, cellWidth, 240)];
            view.userInteractionEnabled = YES;
            view.backgroundColor = [UIColor clearColor];
            [self.view addSubview:view];
            
            SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 120)];
            [view addSubview:btn];
            btn.delegate = self;
            btn.tag = i;
            
            int value = [[dataDic objectForKey:@"db"] intValue];
            float circleValue = (value +20.0f)/40.0f;
            [btn setCircleValue:circleValue];
            
            
            UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 - 30, 0, 60, 20)];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.backgroundColor = [UIColor clearColor];
            [view addSubview:titleL];
            titleL.font = [UIFont boldSystemFontOfSize:11];
            titleL.textColor  = [UIColor whiteColor];
            titleL.text = [dataDic objectForKey:@"name"];
            [_buttonNumberArray addObject:titleL];
            
            UILabel* titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -50, btn.frame.size.height - 20, 100, 20)];
            titleL1.textAlignment = NSTextAlignmentCenter;
            titleL1.backgroundColor = [UIColor clearColor];
            [view addSubview:titleL1];
            titleL1.font = [UIFont boldSystemFontOfSize:12];
            titleL1.textColor  = [UIColor whiteColor];
            titleL1.textAlignment = NSTextAlignmentCenter;
            titleL1.text = [dataDic objectForKey:@"nickname"];
            [_buttonChannelArray addObject:titleL1];
            
            UIView *signalView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, cellWidth, 120)];
            [view addSubview:signalView];
            signalView.alpha=0.8;
            [signalArray addObject:signalView];
            
            UIImage *image = nil;
            NSString *huatongType = [dataDic objectForKey:@"type"];
            if ([@"huatong" isEqualToString:huatongType]) {
                image = [UIImage imageNamed:@"huisehuatong.png"];
            } else {
                image = [UIImage imageNamed:@"huiseyaobao.png"];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [_huatongArray addObject: imageView];
            imageView.center = CGPointMake(40, 40);
            [signalView addSubview:imageView];
            
            
            BatteryView *batter = [[BatteryView alloc] initWithFrame:CGRectZero];
            batter.normalColor = [UIColor whiteColor];
            [batter updateGrayBatteryView];
            [signalView addSubview:batter];
            batter.center = CGPointMake(60, 20);
            [_dianchiArray addObject:batter];
            
            id dianliangStr = [dataDic objectForKey:@"battery"];
            int dianliang = [dianliangStr intValue];
            double dianliangDouble = 1.0f * dianliang / 100;
            [batter setBatteryValue:dianliangDouble];
            
            SignalView *signal = [[SignalView alloc] initWithFrameAndStep:CGRectMake(70, 40, 30, 20) step:2];
            [signalView addSubview:signal];
            [signal setLightColor:[UIColor whiteColor]];//
            [signal setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
            int signalInt = [[dataDic objectForKey:@"signal"] intValue];
            [signal setSignalValue:signalInt];
            [_signalViewArray addObject:signal];
            
            UILabel* sgtitleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, 20, 20)];
            sgtitleL.backgroundColor = [UIColor clearColor];
            [signalView addSubview:sgtitleL];
            sgtitleL.font = [UIFont boldSystemFontOfSize:12];
            sgtitleL.textColor  = [UIColor whiteColor];
            sgtitleL.textAlignment = NSTextAlignmentCenter;
            NSString *title = @"优";
            if (signalInt >= 3 && signalInt < 5) {
                title = @"良";
            } else if (signalInt < 3) {
                title = @"差";
            }
            
            sgtitleL.text = title;
            sgtitleL.tag = index;
            [_signalLabelArray addObject:sgtitleL];
            
            [_imageViewArray addObject:imageView];
            [_buttonArray addObject:btn];
            
            index++;
        }
    }
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
}
- (void) handleTapGesture:(id)sender{
    
    if ([_rightSetView superview]) {
        
        CGRect rc = _rightSetView.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             _rightSetView.frame = CGRectMake(SCREEN_WIDTH,
                                                     rc.origin.y,
                                                     rc.size.width,
                                                     rc.size.height);
                         } completion:^(BOOL finished) {
                             [_rightSetView removeFromSuperview];
                         }];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    
}
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    int circleValue = value * 40.0f - 20;
    
    int idx = (int)slbtn.tag;
    NSMutableDictionary *dataDic = [_channels objectAtIndex:idx];
    if(dataDic)
    {
        [dataDic setObject:[NSNumber numberWithInt:circleValue]
                    forKey:@"db"];
    }
    
}
- (void) didSliderValueChanged:(float)value object:(id)object {
    
    float circleValue = (value +20.0f)/40.0f;
    for (SlideButton *button in _selectedBtnArray) {
        [button setCircleValue:circleValue];
        
        int idx = (int)button.tag;
        NSMutableDictionary *dataDic = [_channels objectAtIndex:idx];
        if(dataDic)
        {
            [dataDic setObject:[NSNumber numberWithInt:value]
                        forKey:@"db"];
        }
        
    }
}

- (void) testCurrentMike:(NSString*)deviceno{
    
    for(AudioEWirlessMike *mike in _wirelessYaoBaoSysArray)
    {
        if([mike._deviceno isEqualToString:deviceno])
        {
            self._curMike = mike;
            break;
        }
    }
    
    [self updateCurrentMikeState:deviceno];
    
}

- (void) updateCurrentMikeState:(NSString *)deviceno{
    
    if([_rightSetView superview])
    {
        _rightSetView._audioMike = _curMike;
        [_rightSetView showData];
    }
    
    for(int i = 0; i < [_channels count]; i++)
    {
        NSDictionary *data = [_channels objectAtIndex:i];
        NSString *dn = [data objectForKey:@"device"];
        NSString *huatongType = [data objectForKey:@"type"];
        if([dn isEqualToString:deviceno])
        {
            continue;
        }
        
        SlideButton *btn = [_buttonArray objectAtIndex:i];
        
        [_selectedBtnArray removeObject:btn];
        
        [btn enableValueSet:NO];
        
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:i];
        chanelL.textColor = [UIColor whiteColor];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:i];
        numberL.textColor = [UIColor whiteColor];
        
        UIView *signalView = [signalArray objectAtIndex:i];
        [signalView setAlpha:0.8];
        
        UILabel *sinalLabel = [_signalLabelArray objectAtIndex:i];
        sinalLabel.textColor = [UIColor whiteColor];
        
        SignalView *signalView2 = [_signalViewArray objectAtIndex:i];
        [signalView2 setLightColor:[UIColor whiteColor]];//
        [signalView2 setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        
        BatteryView *batter = [_dianchiArray objectAtIndex:i];
        [batter updateGrayBatteryView];
        batter.normalColor = [UIColor whiteColor];
        
        UIImageView *imageView = [_huatongArray objectAtIndex:i];
        if ([@"huatong" isEqualToString:huatongType]) {
            imageView.image = [UIImage imageNamed:@"huisehuatong.png"];
        } else {
            imageView.image = [UIImage imageNamed:@"huiseyaobao.png"];
        }
    }
}



- (void) didTappedMSelf:(SlideButton*)slbtn{
    
    int tag = (int)slbtn.tag;
    
    SlideButton *btn = nil;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    
    NSMutableDictionary *dataDic = [_channels objectAtIndex:tag];
    NSString *huatongType = [dataDic objectForKey:@"type"];
    
    [self testCurrentMike:[dataDic objectForKey:@"device"]];
    
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        
        [button enableValueSet:YES];
        
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = YELLOW_COLOR;
        
        UIView *signalView = [signalArray objectAtIndex:tag];
        [signalView setAlpha:1];
        
        UILabel *sinalLabel = [_signalLabelArray objectAtIndex:tag];
        sinalLabel.textColor = YELLOW_COLOR;
        
        SignalView *signalView2 = [_signalViewArray objectAtIndex:tag];
        [signalView2 setLightColor:YELLOW_COLOR];//
        
        BatteryView *batter = [_dianchiArray objectAtIndex:tag];
        [batter updateYellowBatteryView];
        batter.normalColor = YELLOW_COLOR;
        
        UIImageView *imageView = [_huatongArray objectAtIndex:tag];
        if ([@"huatong" isEqualToString:huatongType]) {
            imageView.image = [UIImage imageNamed:@"huatong_yellow_n.png"];
        } else {
            imageView.image = [UIImage imageNamed:@"yaobao_yellow_n.png"];
        }
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        [btn enableValueSet:NO];
    
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = [UIColor whiteColor];
        
        UIView *signalView = [signalArray objectAtIndex:tag];
        [signalView setAlpha:0.8];
        
        UILabel *sinalLabel = [_signalLabelArray objectAtIndex:tag];
        sinalLabel.textColor = [UIColor whiteColor];
        
        SignalView *signalView2 = [_signalViewArray objectAtIndex:tag];
        [signalView2 setLightColor:[UIColor whiteColor]];//
        [signalView2 setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
        
        BatteryView *batter = [_dianchiArray objectAtIndex:tag];
        [batter updateGrayBatteryView];
        batter.normalColor = [UIColor whiteColor];
        
        UIImageView *imageView = [_huatongArray objectAtIndex:tag];
        if ([@"huatong" isEqualToString:huatongType]) {
            imageView.image = [UIImage imageNamed:@"huisehuatong.png"];
        } else {
            imageView.image = [UIImage imageNamed:@"huiseyaobao.png"];
        }
    }
}

- (void) scenarioAction:(id)sender{
    
}

- (void) selectCurrentMike:(AudioEWirlessMike*)mike{
    
    
    self._curMike = mike;
    
    
    [self updateCurrentMikeState:mike._deviceno];
}

- (void) chooseDeviceAtIndex:(int)idx{
    
    self._curMike = [_wirelessYaoBaoSysArray objectAtIndex:idx];
    [self updateCurrentMikeState:_curMike._deviceno];
    
}

//显示设置页面
- (void) settingAction:(id)sender{
    
    //检查是否需要创建
    if (_rightSetView == nil) {
        _rightSetView = [[WirlessYaoBaoViewSettingsView alloc]
                         initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                  64, 300, SCREEN_HEIGHT-114)];
        
        //创建底部设备切换按钮
        _rightSetView._numOfDevice = (int)[_wirelessYaoBaoSysArray count];
        
        
        IMP_BLOCK_SELF(EngineerWirlessYaoBaoViewCtrl);
        _rightSetView._callback = ^(int deviceIndex) {
            
            [block_self chooseDeviceAtIndex:deviceIndex];
        };
    }
    
    //如果在显示，消失
    if([_rightSetView superview])
    {

        //写入中控
        //......
        
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _rightSetView.frame  = CGRectMake(SCREEN_WIDTH,
                                                               64, 300, SCREEN_HEIGHT-114);
                         } completion:^(BOOL finished) {
                             [_rightSetView removeFromSuperview];
                         }];
    }
    else//如果没显示，显示
    {
        _rightSetView._audioMike = _curMike;
        [_rightSetView showData];
        
        
        [self.view addSubview:_rightSetView];
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        
        [UIView beginAnimations:nil context:nil];
        _rightSetView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                          64, 300, SCREEN_HEIGHT-114);
        [UIView commitAnimations];
    }
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
