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

@interface EngineerWirlessYaoBaoViewCtrl () {
    
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
    
    UIButton *_luboBtn;
    UIButton *_tanchuBtn;
    
    EngineerSliderView *_zengyiSlider;
}
@end

@implementation EngineerWirlessYaoBaoViewCtrl
@synthesize _wirelessYaoBaoSysArray;
@synthesize _number;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _zengyiSlider = [[EngineerSliderView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                       frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 60;
    _zengyiSlider.bottomEdge = 55;
    _zengyiSlider.maxValue = 20;
    _zengyiSlider.minValue = -20;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(600, 500);
}

@end
