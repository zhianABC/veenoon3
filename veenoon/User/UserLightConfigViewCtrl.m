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

@interface UserLightConfigViewCtrl () {
    UIButton *_backBiDengBtn;
    UIButton *_houpaidengdai2Btn;
    UIButton *_dingdengBtn;
    UIButton *_xiaoshedengBtn;
    UIButton *_bidengBtn;
    UIButton *_tongdengBtn;
    
    JLightSliderView *_houpaidengdai1Slider;
    JLightSliderView *_houpaidengdai2Slider;
    JLightSliderView *_dingdengSlider;
    JLightSliderView *_xiaoshengdengSlider;
    JLightSliderView *_bidengSlider;
    JLightSliderView *_tongdengSlider;
}
@end

@implementation UserLightConfigViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
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
    
    int leftRight = 70;
    int number = 8;
    int height = 125;
    int rowGap = 125;
    int width = (SCREEN_WIDTH - leftRight*2) / number;
    
    int sliderHeight = 450;
    int sliderLeftRight = 100;
    
    _backBiDengBtn = [UIButton buttonWithColor:nil selColor:nil];
    _backBiDengBtn.frame = CGRectMake(leftRight+rowGap, height, width, width);
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_backBiDengBtn setTitle:@"后排灯带" forState:UIControlStateNormal];
    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_backBiDengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _backBiDengBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_backBiDengBtn setTitleEdgeInsets:UIEdgeInsetsMake(_backBiDengBtn.imageView.frame.size.height+10,-75,-20,40)];
    [_backBiDengBtn setImageEdgeInsets:UIEdgeInsetsMake(-15,0.0,_backBiDengBtn.titleLabel.bounds.size.height, 0)];
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
    
    _houpaidengdai2Btn = [UIButton buttonWithColor:nil selColor:nil];
    _houpaidengdai2Btn.frame = CGRectMake(leftRight+rowGap*2, height, width, width);
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_houpaidengdai2Btn setTitle:@"后排灯带" forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _houpaidengdai2Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_houpaidengdai2Btn setTitleEdgeInsets:UIEdgeInsetsMake(_houpaidengdai2Btn.imageView.frame.size.height+10,-85,-20,25)];
    [_houpaidengdai2Btn setImageEdgeInsets:UIEdgeInsetsMake(-15,0.0,_houpaidengdai2Btn.titleLabel.bounds.size.height, 0)];
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
    
    _dingdengBtn = [UIButton buttonWithColor:nil selColor:nil];
    _dingdengBtn.frame = CGRectMake(leftRight+rowGap*3+10, height, width, width);
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_dingdengBtn setTitle:@"顶灯" forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _dingdengBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_dingdengBtn setTitleEdgeInsets:UIEdgeInsetsMake(_dingdengBtn.imageView.frame.size.height+10,-95,-20,25)];
    [_dingdengBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-30,_dingdengBtn.titleLabel.bounds.size.height, 0)];
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
    
    _xiaoshedengBtn = [UIButton buttonWithColor:nil selColor:nil];
    _xiaoshedengBtn.frame = CGRectMake(leftRight+rowGap*4, height, width, width);
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_xiaoshedengBtn setTitle:@"小射灯" forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _xiaoshedengBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_xiaoshedengBtn setTitleEdgeInsets:UIEdgeInsetsMake(_xiaoshedengBtn.imageView.frame.size.height+10,-80,-20,30)];
    [_xiaoshedengBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_xiaoshedengBtn.titleLabel.bounds.size.height, 0)];
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
    
    _bidengBtn = [UIButton buttonWithColor:nil selColor:nil];
    _bidengBtn.frame = CGRectMake(leftRight+rowGap*5, height, width, width);
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_bidengBtn setTitle:@"壁灯" forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _bidengBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_bidengBtn setTitleEdgeInsets:UIEdgeInsetsMake(_bidengBtn.imageView.frame.size.height+10,-85,-20,20)];
    [_bidengBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-15,_bidengBtn.titleLabel.bounds.size.height, 0)];
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
    
    _tongdengBtn = [UIButton buttonWithColor:nil selColor:nil];
    _tongdengBtn.frame = CGRectMake(leftRight+rowGap*6, height, width, width);
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateHighlighted];
    [_tongdengBtn setTitle:@"筒灯" forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _tongdengBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_tongdengBtn setTitleEdgeInsets:UIEdgeInsetsMake(_tongdengBtn.imageView.frame.size.height+10,-85,-20,20)];
    [_tongdengBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,-15,_tongdengBtn.titleLabel.bounds.size.height, 0)];
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
}

- (void) tongdengAction:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    
    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
}

- (void) bidengAction:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];

    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) xiaoshedengAction:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    
    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) dingdengAction:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    
    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) houpaibideng2Action:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    
    [_backBiDengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) houpaibidengAction:(id)sender{
    [_backBiDengBtn setImage:[UIImage imageNamed:@"user_light_bg_s.png"] forState:UIControlStateNormal];
    [_houpaidengdai2Btn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_dingdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_xiaoshedengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_bidengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    [_tongdengBtn setImage:[UIImage imageNamed:@"user_light_bg_n.png"] forState:UIControlStateNormal];
    
    [_backBiDengBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_houpaidengdai2Btn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_dingdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_xiaoshedengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_bidengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
    [_tongdengBtn setTitleColor:SINGAL_COLOR forState:UIControlStateNormal];
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
