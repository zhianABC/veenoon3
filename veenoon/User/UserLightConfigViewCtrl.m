//
//  UserLightConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserLightConfigViewCtrl.h"
#import "JLightSliderView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"

@interface UserLightConfigViewCtrl () {
    IconCenterTextButton *_backBiDengBtn;
    IconCenterTextButton *_houpaidengdai2Btn;
    IconCenterTextButton *_dingdengBtn;
    IconCenterTextButton *_xiaoshedengBtn;
    IconCenterTextButton *_bidengBtn;
    IconCenterTextButton *_tongdengBtn;
    IconCenterTextButton *_tongdengBtn2;
    IconCenterTextButton *_tongdengBtn3;
    
    JLightSliderView *_houpaidengdai1Slider;
    JLightSliderView *_houpaidengdai2Slider;
    JLightSliderView *_dingdengSlider;
    JLightSliderView *_xiaoshengdengSlider;
    JLightSliderView *_bidengSlider;
    JLightSliderView *_tongdengSlider;
    JLightSliderView *_tongdengSlider2;
    JLightSliderView *_tongdengSlider3;
}
@end

@implementation UserLightConfigViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
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
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int leftRight = 60;
    int number = 8;
    int height = 100;
    int rowGap = 115;
    int width = (SCREEN_WIDTH - leftRight*2) / number;
    
    int sliderHeight = 450;
    int sliderLeftRight = 0;
    
    _backBiDengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight, height, width, width)];
    [_backBiDengBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 01" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_backBiDengBtn addTarget:self action:@selector(houpaibidengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBiDengBtn];
    
    _houpaidengdai1Slider = [[JLightSliderView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                       frame:CGRectZero];
    [self.view addSubview:_houpaidengdai1Slider];
    [_houpaidengdai1Slider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _houpaidengdai1Slider.topEdge = 60;
    _houpaidengdai1Slider.bottomEdge = 55;
    _houpaidengdai1Slider.maxValue = 100;
    _houpaidengdai1Slider.minValue = 0;
    [_houpaidengdai1Slider resetScale];
    _houpaidengdai1Slider.center = CGPointMake(sliderLeftRight+rowGap, sliderHeight);
    
    _houpaidengdai2Btn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap, height, width, width)];
    [_houpaidengdai2Btn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 02" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_houpaidengdai2Btn addTarget:self action:@selector(houpaibideng2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_houpaidengdai2Btn];
    
    _houpaidengdai2Slider = [[JLightSliderView alloc]
                        initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                        frame:CGRectZero];
    [self.view addSubview:_houpaidengdai2Slider];
    [_houpaidengdai2Slider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _houpaidengdai2Slider.topEdge = 60;
    _houpaidengdai2Slider.bottomEdge = 55;
    _houpaidengdai2Slider.maxValue = 100;
    _houpaidengdai2Slider.minValue = 0;
    [_houpaidengdai2Slider resetScale];
    _houpaidengdai2Slider.center = CGPointMake(sliderLeftRight+rowGap*2, sliderHeight);
    
    
    _dingdengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*2, height, width, width)];
    [_dingdengBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 03" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_dingdengBtn addTarget:self action:@selector(dingdengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dingdengBtn];
    
    _dingdengSlider = [[JLightSliderView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                           frame:CGRectZero];
    [self.view addSubview:_dingdengSlider];
    [_dingdengSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _dingdengSlider.topEdge = 60;
    _dingdengSlider.bottomEdge = 55;
    _dingdengSlider.maxValue = 100;
    _dingdengSlider.minValue = 0;
    [_dingdengSlider resetScale];
    _dingdengSlider.center = CGPointMake(sliderLeftRight+rowGap*3, sliderHeight);
    
    _xiaoshedengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*3, height, width, width)];
    [_xiaoshedengBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 04" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_xiaoshedengBtn addTarget:self action:@selector(xiaoshedengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xiaoshedengBtn];
    
    _xiaoshengdengSlider = [[JLightSliderView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                           frame:CGRectZero];
    [self.view addSubview:_xiaoshengdengSlider];
    [_xiaoshengdengSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _xiaoshengdengSlider.topEdge = 60;
    _xiaoshengdengSlider.bottomEdge = 55;
    _xiaoshengdengSlider.maxValue = 100;
    _xiaoshengdengSlider.minValue = 0;
    [_xiaoshengdengSlider resetScale];
    _xiaoshengdengSlider.center = CGPointMake(sliderLeftRight+rowGap*4, sliderHeight);
    
    _bidengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*4, height, width, width)];
    [_bidengBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 05" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_bidengBtn addTarget:self action:@selector(bidengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bidengBtn];
    
    _bidengSlider = [[JLightSliderView alloc]
                            initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                            frame:CGRectZero];
    [self.view addSubview:_bidengSlider];
    [_bidengSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _bidengSlider.topEdge = 60;
    _bidengSlider.bottomEdge = 55;
    _bidengSlider.maxValue = 100;
    _bidengSlider.minValue = 0;
    [_bidengSlider resetScale];
    _bidengSlider.center = CGPointMake(sliderLeftRight+rowGap*5, sliderHeight);
    
    _tongdengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*5, height, width, width)];
    [_tongdengBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 06" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_tongdengBtn addTarget:self action:@selector(tongdengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tongdengBtn];
    
    _tongdengSlider = [[JLightSliderView alloc]
                             initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                             frame:CGRectZero];
    [self.view addSubview:_tongdengSlider];
    [_tongdengSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _tongdengSlider.topEdge = 60;
    _tongdengSlider.bottomEdge = 55;
    _tongdengSlider.maxValue = 100;
    _tongdengSlider.minValue = 0;
    [_tongdengSlider resetScale];
    _tongdengSlider.center = CGPointMake(sliderLeftRight+rowGap*6, sliderHeight);
    
    _tongdengBtn2 = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*6, height, width, width)];
    [_tongdengBtn2 buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 07" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_tongdengBtn2 addTarget:self action:@selector(tongdengAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tongdengBtn2];
    
    _tongdengSlider2 = [[JLightSliderView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                       frame:CGRectZero];
    [self.view addSubview:_tongdengSlider2];
    [_tongdengSlider2 setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _tongdengSlider2.topEdge = 60;
    _tongdengSlider2.bottomEdge = 55;
    _tongdengSlider2.maxValue = 100;
    _tongdengSlider2.minValue = 0;
    [_tongdengSlider2 resetScale];
    _tongdengSlider2.center = CGPointMake(sliderLeftRight+rowGap*7, sliderHeight);
    
    _tongdengBtn3 = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*7, height, width, width)];
    [_tongdengBtn3 buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"] text:@"Channel 08" normalColor:SINGAL_COLOR selColor:RGB(230, 151, 50)];
    [_tongdengBtn3 addTarget:self action:@selector(tongdengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tongdengBtn3];
    
    _tongdengSlider3 = [[JLightSliderView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                       frame:CGRectZero];
    [self.view addSubview:_tongdengSlider3];
    [_tongdengSlider3 setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _tongdengSlider3.topEdge = 60;
    _tongdengSlider3.bottomEdge = 55;
    _tongdengSlider3.maxValue = 100;
    _tongdengSlider3.minValue = 0;
    [_tongdengSlider3 resetScale];
    _tongdengSlider3.center = CGPointMake(sliderLeftRight+rowGap*8, sliderHeight);
}
- (void) tongdengAction3:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:YES];
}
- (void) tongdengAction2:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:YES];
    [_tongdengBtn3 setBtnHighlited:NO];
    
}
- (void) tongdengAction:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:YES];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
    
}

- (void) bidengAction:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:YES];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
}

- (void) xiaoshedengAction:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:YES];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
}

- (void) dingdengAction:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:YES];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
}

- (void) houpaibideng2Action:(id)sender{
    [_backBiDengBtn setBtnHighlited:NO];
    [_houpaidengdai2Btn setBtnHighlited:YES];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
}

- (void) houpaibidengAction:(id)sender{
    [_backBiDengBtn setBtnHighlited:YES];
    [_houpaidengdai2Btn setBtnHighlited:NO];
    [_dingdengBtn setBtnHighlited:NO];
    [_xiaoshedengBtn setBtnHighlited:NO];
    [_bidengBtn setBtnHighlited:NO];
    [_tongdengBtn setBtnHighlited:NO];
    [_tongdengBtn2 setBtnHighlited:NO];
    [_tongdengBtn3 setBtnHighlited:NO];
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
