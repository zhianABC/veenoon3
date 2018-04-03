//
//  EngineerLuBoJiViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerTouYingJiViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "TouYingJiRightView.h"

@interface EngineerTouYingJiViewCtrl () <CustomPickerViewDelegate>{
    UIButton *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIButton *_luboBtn;
    
    BOOL isSettings;
    TouYingJiRightView *_rightView;
    UIButton *okBtn;
}
@end

@implementation EngineerTouYingJiViewCtrl
@synthesize _touyingjiArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"video_corner_shipinbofang.png" withTitle:@"投影机"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
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
    
    _luboBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _luboBtn.frame = CGRectMake(70, SCREEN_HEIGHT-140, 60, 60);
    _luboBtn.layer.cornerRadius = 5;
    _luboBtn.layer.borderWidth = 2;
    _luboBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _luboBtn.clipsToBounds = YES;
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_luboBtn];
    
    [_luboBtn addTarget:self
                 action:@selector(luboAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    int playerLeft = 215;
    int playerHeight = 60;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(280+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影幕";
    
    UIButton *yingmuUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuUpBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingmuUpBtn.layer.cornerRadius = 5;
    yingmuUpBtn.layer.borderWidth = 2;
    yingmuUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuUpBtn.clipsToBounds = YES;
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuUpBtn];
    
    [yingmuUpBtn addTarget:self
                    action:@selector(yingmuUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingmuStopBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuStopBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingmuStopBtn.layer.cornerRadius = 5;
    yingmuStopBtn.layer.borderWidth = 2;
    yingmuStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuStopBtn.clipsToBounds = YES;
    [yingmuStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuStopBtn];
    
    [yingmuStopBtn addTarget:self
                      action:@selector(yingmuStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *yingmuDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuDownBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingmuDownBtn.layer.cornerRadius = 5;
    yingmuDownBtn.layer.borderWidth = 2;
    yingmuDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuDownBtn.clipsToBounds = YES;
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuDownBtn];
    
    [yingmuDownBtn addTarget:self
                    action:@selector(yingmuDownAction:)
          forControlEvents:UIControlEventTouchUpInside];
    playerLeft-=30;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(455+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影机";
    
    UIButton *yingjiUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiUpBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingjiUpBtn.layer.cornerRadius = 5;
    yingjiUpBtn.layer.borderWidth = 2;
    yingjiUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiUpBtn.clipsToBounds = YES;
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiUpBtn];
    
    [yingjiUpBtn addTarget:self
                    action:@selector(yingjiUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiStopBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiStopBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingjiStopBtn.layer.cornerRadius = 5;
    yingjiStopBtn.layer.borderWidth = 2;
    yingjiStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiStopBtn.clipsToBounds = YES;
    [yingjiStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiStopBtn];
    
    [yingjiStopBtn addTarget:self
                      action:@selector(yingjiStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiDownBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingjiDownBtn.layer.cornerRadius = 5;
    yingjiDownBtn.layer.borderWidth = 2;
    yingjiDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiDownBtn.clipsToBounds = YES;
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiDownBtn];
    
    [yingjiDownBtn addTarget:self
                      action:@selector(yingjiDownAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    playerLeft = 15;
    playerHeight=-40;
    
    UIButton *hmi1Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    hmi1Btn.frame = CGRectMake(155+playerLeft, SCREEN_HEIGHT-435+playerHeight, 80, 80);
    hmi1Btn.layer.cornerRadius = 5;
    hmi1Btn.layer.borderWidth = 2;
    hmi1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    hmi1Btn.clipsToBounds = YES;
    [hmi1Btn setTitle:@"HMI1" forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:hmi1Btn];
    
    [hmi1Btn addTarget:self
                      action:@selector(hmi1Action:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hmi2Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    hmi2Btn.frame = CGRectMake(255+playerLeft, SCREEN_HEIGHT-435+playerHeight, 80, 80);
    hmi2Btn.layer.cornerRadius = 5;
    hmi2Btn.layer.borderWidth = 2;
    hmi2Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    hmi2Btn.clipsToBounds = YES;
    [hmi2Btn setTitle:@"HMI2" forState:UIControlStateNormal];
    [hmi2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hmi2Btn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:hmi2Btn];
    
    [hmi2Btn addTarget:self
                      action:@selector(hmi2Action:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *vgaBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    vgaBtn.frame = CGRectMake(155+playerLeft, SCREEN_HEIGHT-335+playerHeight, 80, 80);
    vgaBtn.layer.cornerRadius = 5;
    vgaBtn.layer.borderWidth = 2;
    vgaBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    vgaBtn.clipsToBounds = YES;
    [vgaBtn setTitle:@"VGA" forState:UIControlStateNormal];
    [vgaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vgaBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:vgaBtn];
    
    [vgaBtn addTarget:self
                      action:@selector(vgaAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *netBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    netBtn.frame = CGRectMake(255+playerLeft, SCREEN_HEIGHT-335+playerHeight, 80, 80);
    netBtn.layer.cornerRadius = 5;
    netBtn.layer.borderWidth = 2;
    netBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    netBtn.clipsToBounds = YES;
    [netBtn setTitle:@"网络" forState:UIControlStateNormal];
    [netBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [netBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:netBtn];
    
    [netBtn addTarget:self
                      action:@selector(netAction:)
            forControlEvents:UIControlEventTouchUpInside];
}
- (void) netAction:(id)sender{
    
}
- (void) vgaAction:(id)sender{
    
}
- (void) hmi2Action:(id)sender{
    
}
- (void) hmi1Action:(id)sender{
    
}
- (void) yingjiDownAction:(id)sender{
    
}
- (void) yingmuDownAction:(id)sender{
    
}
- (void) yingjiStopAction:(id)sender{
    
}
- (void) yingmuStopAction:(id)sender{
    
}
- (void) yingmuUpAction:(id)sender{
    
}
- (void) yingjiUpAction:(id)sender{
    
}
- (void) luboAction:(id)sender{
    
}

- (void) sysSelectAction:(id)sender{
    _customPicker = [[CustomPickerView alloc]
                     initWithFrame:CGRectMake(_selectSysBtn.frame.origin.x, _selectSysBtn.frame.origin.y, _selectSysBtn.frame.size.width, 120) withGrayOrLight:@"gray"];
    
    
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
        _rightView = [[TouYingJiRightView alloc]
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

