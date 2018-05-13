//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerHunYinSysViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "SlideButton.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "MixVoiceSettingsView.h"
#import "HunyinYinpinchuliViewCtrl.h"


@interface EngineerHunYinSysViewController () <CustomPickerViewDelegate, EngineerSliderViewDelegate, MixVoiceSettingsViewDelegate>{
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    EngineerSliderView *_zengyiSlider;
    UIButton *okBtn;
    BOOL isSettings;
    MixVoiceSettingsView *_rightView;
}
@end

@implementation EngineerHunYinSysViewController
@synthesize _hunyinSysArray;
- (void) inintData {
    if (_hunyinSysArray) {
        [_hunyinSysArray removeAllObjects];
    } else {
        _hunyinSysArray = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *wuxianDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"huatong", @"type",
                                       @"100", @"dianliang", nil];
    NSMutableDictionary *wuxianDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong2", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"yaobao", @"type",
                                       @"100", @"dianliang", nil];
    NSMutableDictionary *wuxianDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"huangliurong3", @"name",
                                       @"off", @"status",
                                       @"1", @"singnal",
                                       @"huatong", @"type",
                                       @"90", @"dianliang", nil];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:wuxianDic1, wuxianDic2, wuxianDic3, wuxianDic1, wuxianDic2, wuxianDic3, wuxianDic1, wuxianDic2, wuxianDic3, nil];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"001", @"name",
                                 array1, @"value", nil];
    [_hunyinSysArray addObject:dic1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self inintData];
    
    isSettings = NO;
    
    [super setTitleAndImage:@"audio_corner_hunyin.png" withTitle:@"混音会议"];
    
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
    
    _selectSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectSysBtn.frame = CGRectMake(50, 100, 80, 30);
    [_selectSysBtn setImage:[UIImage imageNamed:@"engineer_sys_select_down_n.png"] forState:UIControlStateNormal];
    [_selectSysBtn setTitle:@"001" forState:UIControlStateNormal];
    _selectSysBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_selectSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _selectSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selectSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,_selectSysBtn.imageView.bounds.size.width)];
    [_selectSysBtn setImageEdgeInsets:UIEdgeInsetsMake(0,_selectSysBtn.titleLabel.bounds.size.width+35,0,0)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi_n.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 55;
    _zengyiSlider.maxValue = 79;
    _zengyiSlider.minValue = 0;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 150, SCREEN_HEIGHT/2);
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    NSMutableDictionary *dataDic = [_hunyinSysArray objectAtIndex:0];
    NSMutableArray *dataArray = [dataDic objectForKey:@"value"];
    
    if ([dataArray count] == 0) {
        int nameStart = 1;
    } else {
        for (int i = 0; i < [dataArray count]; i++) {
            NSMutableDictionary *dataDic = [dataArray objectAtIndex:i];
            
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            
            UIImage *image = [UIImage imageNamed:@"slide_btn.png"];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.layer.cornerRadius = 10;
            imageView.layer.borderWidth = 0;
            imageView.layer.borderColor = DARK_BLUE_COLOR.CGColor;
            imageView.clipsToBounds = YES;
            
            imageView.frame = CGRectMake(startX, startY, 100, 100);
            imageView.tag = index;
            imageView.userInteractionEnabled=YES;
            imageView.layer.contentsGravity = kCAGravityCenter;
            [self.view addSubview:imageView];
            
            index++;
        }
    }
}

- (void) didSliderValueChanged:(float)value object:(id)object {
    
}

- (void) didSliderEndChanged:(id)object {
    
}

- (void) sysSelectAction:(id)sender{
    
    if(_customPicker == nil)
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 120) withGrayOrLight:@"gray"];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 1; i< 6; i++)
    {
        [arr addObject:[NSString stringWithFormat:@"00%d", i]];
    }
    
    _customPicker._pickerDataArray = @[@{@"values":arr}];
    
    
    _customPicker._selectColor = [UIColor orangeColor];
    _customPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_customPicker];
    _customPicker.delegate_ = self;
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
        if (_rightView == nil) {
            _rightView = [[MixVoiceSettingsView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
            _rightView.delegate_=self;
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
    HunyinYinpinchuliViewCtrl *ctrl = [[HunyinYinpinchuliViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

