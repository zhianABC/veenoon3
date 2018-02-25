//
//  EngineerAudioProcessViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/19.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAudioProcessViewCtrl.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "AudioProcessRightView.h"
#import "AudioInputSettingViewCtrl.h"
#import "AudioOutputSettingViewCtrl.h"
#import "AudioMatrixSettingViewCtrl.h"
#import "AudioIconSettingView.h"

@interface EngineerAudioProcessViewCtrl () <EngineerSliderViewDelegate, CustomPickerViewDelegate, AudioProcessRightViewDelegate> {
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
    
    
    AudioProcessRightView *_rightView;
    BOOL isSettings;
    UIButton *okBtn;
    
    AudioIconSettingView *_inconView;
    BOOL isIcon;
    
    UIImageView *bottomBar;
    UIView *topbar;
}

@end

@implementation EngineerAudioProcessViewCtrl
@synthesize _audioProcessArray;
@synthesize _inputNumber;
@synthesize _outputNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isIcon = NO;
    isSettings = NO;
    _buttonArray = [[NSMutableArray alloc] init];
    
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = THEME_COLOR;
    [self.view addSubview:topbar];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [topbar addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [topbar addSubview:line];

    bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
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
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(70, 100, 250, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"音频处理器" forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-50,0,_selectSysBtn.imageView.bounds.size.width+50)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width,0,-130)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi3.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = 12;
    _zengyiSlider.minValue = -70;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT/2);
    
    int height = 180;
    int inputOutGap = 230;
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, height, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"InPuts";
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, height+inputOutGap, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"OutPuts";
    
    int colNumber = 8;
    int index = 0;
    int cellWidth = 92;
    int cellHeight = 92;
    int leftRight = 150;
    int space = (SCREEN_WIDTH - colNumber*cellWidth-leftRight*2)/(colNumber-1);
    
    for (int i = 0; i < self._inputNumber; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight-80;
        int startY = row*cellHeight+space*row+height+20;
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [btn addGestureRecognizer:tapGesture];
        
        btn.tag = index;
        [self.view addSubview:btn];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width - 30, 20, 30, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [NSString stringWithFormat:@"0%d",i+1];
        [_buttonNumberArray addObject:titleL];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height - 40, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"Channel";
        [_buttonChannelArray addObject:titleL];
        
        UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed2:)];
        
        [btn addGestureRecognizer:longPress2];
        
        [_buttonArray addObject:btn];
        
        index++;
    }
    
    for (int i = 0; i < self._outputNumber; i++) {
        
        int row = i/colNumber;
        int col = i%colNumber;
        int startX = col*cellWidth+col*space+leftRight-80;
        int startY = row*cellHeight+space*row+height+20+inputOutGap;
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.view.tag = index;
        [btn addGestureRecognizer:tapGesture];
        
        btn.tag = index;
        [self.view addSubview:btn];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width - 30, 20, 30, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [NSString stringWithFormat:@"0%d",i+1];
        [_buttonNumberArray addObject:titleL];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2 -40, btn.frame.size.height - 40, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:12];
        titleL.textColor  = [UIColor whiteColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"Channel";
        [_buttonChannelArray addObject:titleL];
        
        UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed2:)];
        
        [btn addGestureRecognizer:longPress2];
        
        [_buttonArray addObject:btn];
        
        index++;
    }
    
    
    
    [self.view bringSubviewToFront:bottomBar];
    [self.view bringSubviewToFront:topbar];
}
- (void) didSliderEndChanged:(id)object {
    
}
- (void) didSliderValueChanged:(int)value object:(id)object {
    float circleValue = (float) (value+70.0f)/82.0f;
    for (SlideButton *button in _selectedBtnArray) {
        [button setCircleValue:circleValue];
    }
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    int tag = (int)gestureRecognizer.view.tag;
    
    SlideButton *btn;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = YELLOW_COLOR;
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = YELLOW_COLOR;
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        UILabel *chanelL = [_buttonChannelArray objectAtIndex:tag];
        chanelL.textColor = [UIColor whiteColor];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = [UIColor whiteColor];;
    }
}


- (void) longPressed2:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
    }
}
- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 200) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 2; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    if (_customPicker) {
        [_customPicker removeFromSuperview];
    }
    NSString *title =  [@"音频处理器" stringByAppendingString:pickerValue];
    [_selectSysBtn setTitle:title forState:UIControlStateNormal];
}

- (void) okAction:(id)sender{
    if (_inconView) {
        [_inconView removeFromSuperview];
    }
    if (!isSettings) {
        if (_rightView == nil) {
            _rightView = [[AudioProcessRightView alloc]
                          initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                   64, 300, SCREEN_HEIGHT-114)];
            _rightView.delegate_ = self;
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                           64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        
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

- (void) didSelectButtonAction:(NSString*)value {
    if ([@"输入设置" isEqualToString:value]) {
        AudioInputSettingViewCtrl *ctrl = [[AudioInputSettingViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    } else if ([@"输出设置" isEqualToString:value]) {
        AudioOutputSettingViewCtrl *ctrl = [[AudioOutputSettingViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    } else if ([@"矩阵路由" isEqualToString:value]) {
        AudioMatrixSettingViewCtrl *ctrl = [[AudioMatrixSettingViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
            
            if (_inconView == nil) {
                _inconView = [[AudioIconSettingView alloc]
                              initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                       64, 300, SCREEN_HEIGHT-114)];
            } else {
                [UIView beginAnimations:nil context:nil];
                _inconView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114);
                [UIView commitAnimations];
            }
            
            [self.view insertSubview:_inconView belowSubview:bottomBar];
            [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        }
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
