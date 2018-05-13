//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerHandtoHandViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "HandtoHandSettingsView.h"
#import "AudioEHand2Hand.h"
#import "PlugsCtrlTitleHeader.h"

@interface EngineerHandtoHandViewCtrl () <CustomPickerViewDelegate, EngineerSliderViewDelegate> {
    
    PlugsCtrlTitleHeader *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_imageViewArray;
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    
    NSMutableArray *_selectedBtnArray;
    
    HandtoHandSettingsView *_rightSetView;
    
    BOOL isSettings;
    UIButton *okBtn;
    
    UIView *_channelView;
}
@property (nonatomic,assign) int _number;
@property (nonatomic, strong) AudioEHand2Hand *_curH2H;

@end

@implementation EngineerHandtoHandViewCtrl
@synthesize _number;
@synthesize _handToHandSysArray;
@synthesize _curH2H;

- (void) inintData {
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    _imageViewArray = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    [self inintData];
    
    if([_handToHandSysArray count])
        self._curH2H = [_handToHandSysArray objectAtIndex:0];
    
    [super setTitleAndImage:@"audio_corner_hunyin.png" withTitle:@"有线会议"];
    
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
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    if(_curH2H)
        [_selectSysBtn setShowText:[_curH2H showName]];
    

    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi_n.png"]
                     frame:CGRectZero];
    
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 20;
    _zengyiSlider.minValue = -20;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 150, SCREEN_HEIGHT/2);
    
    [_zengyiSlider setScaleValue:_curH2H._dbVal];
    
    int index = 0;
    int top = 200;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    _channelView = [[UIView alloc] initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 500)];
    [self.view addSubview:_channelView];
    _channelView.backgroundColor = [UIColor clearColor];
    
    
    self._number = [_curH2H channelsCount];
    
    [self.view addSubview:_zengyiSlider];
    
    for (int i = 0; i < self._number; i++) {
        
        NSMutableDictionary *channel = nil;
        if (self._curH2H && [self._curH2H channelsCount] > i) {
            channel = [self._curH2H channelAtIndex:i];
        }
        
        int row = index / colNumber;
        int col = index % colNumber;
        int startX = col * cellWidth + col * space + leftRight;
        int startY = row * cellHeight + space * row + 10;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:nil selColor:RGB(0, 89, 118)];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        scenarioBtn.layer.borderWidth = 2;
        scenarioBtn.layer.borderColor = [UIColor clearColor].CGColor;
        NSString *status = nil;
        if (channel) {
            status = [channel objectForKey:@"status"];
        }
        [_buttonArray addObject:scenarioBtn];
        
        [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
        [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateHighlighted];
        
        if ([status isEqualToString:@"ON"]) {
            [scenarioBtn setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
        }
        scenarioBtn.tag = index;
        [_channelView addSubview:scenarioBtn];
        
        [scenarioBtn addTarget:self
                        action:@selector(scenarioAction:)
              forControlEvents:UIControlEventTouchUpInside];
        if (channel) {
            [self createBtnLabel:scenarioBtn
                         dataDic:channel];
        }
        
        index++;
    }
}

- (void) createBtnLabel:(UIButton*)sender dataDic:(NSMutableDictionary*) dataDic{
   
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sender.frame.size.width, 20)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.backgroundColor = [UIColor clearColor];
    [sender addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:11];
    titleL.textColor  = [UIColor whiteColor];
    
    NSString *nameStr = [dataDic objectForKey:@"name"];
    
    titleL.text = nameStr;
    
    [_buttonChannelArray addObject:titleL];
}

- (void) didSliderValueChanged:(float)value object:(id)object {
    
    _curH2H._dbVal = value;
}

-(void)scenarioAction:(id)sender {
    
    UIButton *button = (UIButton*) sender;
    int tag = (int) button.tag;
    
    UIButton *btn;
    for (UIButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        
        UIButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        NSMutableDictionary *channel = [_curH2H channelAtIndex:tag];
        [channel setObject:@"ON" forKey:@"status"];
        
        [button setImage:[UIImage imageNamed:@"dianyuanshishiqi_s.png"] forState:UIControlStateNormal];
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        [button setImage:[UIImage imageNamed:@"dianyuanshishiqi_n.png"] forState:UIControlStateNormal];
    
        NSMutableDictionary *channel = [_curH2H channelAtIndex:tag];
        [channel setObject:@"OFF" forKey:@"status"];
    }
}

- (void) sysSelectAction:(id)sender{
    
}

- (void) didChangedPickerValue:(NSDictionary*)value{
    
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSDictionary *dic = [value objectForKey:@0];
    NSString *title =  [dic objectForKey:@"value"];
    
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
    
}

- (void) okAction:(id)sender{
    if (!isSettings) {
        if (_rightSetView == nil) {
            _rightSetView = [[HandtoHandSettingsView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightSetView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                              64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        
        [self.view addSubview:_rightSetView];
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightSetView) {
            [_rightSetView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
