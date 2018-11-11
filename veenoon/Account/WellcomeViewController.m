//
//  WellcomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WellcomeViewController.h"
#import "UIButton+Color.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

#import "CustomPickerView.h"
#import "ColumnsView.h"
#import "JSlideView.h"
#import "SignalView.h"
#import "BatteryView.h"
#import "ColumnView.h"
#import "CircleProgressView.h"
#import "PlayerSettingsPannel.h"
#import "SlideButton.h"
#import "MixVoiceSettingsView.h"

#import "YaXianQi_UIView.h"

@interface WellcomeViewController ()

@end

@implementation WellcomeViewController
@synthesize _isActiving;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teslaria_title.png"]];
    [self.view addSubview:icon];
    icon.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.5-80);
    
    UIButton *login = [UIButton buttonWithColor:[UIColor whiteColor] selColor:LOGIN_BLACK_COLOR];
        login.frame = CGRectMake(0, 0,220, 50);
    login.layer.cornerRadius = 10;
    login.layer.borderWidth = 1;
    login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.clipsToBounds = YES;
    [self.view addSubview:login];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont systemFontOfSize:18];
    login.center = CGPointMake(SCREEN_WIDTH/2-120, CGRectGetMaxY(icon.frame)+160);

    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(0, 0,220, 50);
    signup.layer.cornerRadius = 10;
    signup.layer.borderWidth = 1;
    signup.layer.borderColor = [UIColor whiteColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"注册" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont systemFontOfSize:18];
    signup.center = CGPointMake(SCREEN_WIDTH/2+120, CGRectGetMaxY(icon.frame)+160);

    [signup addTarget:self
              action:@selector(signupAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *titleL = [UIButton buttonWithType:UIButtonTypeCustom];
    titleL.frame = CGRectMake(60,
                              SCREEN_HEIGHT - 60,
                              100, 20);
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.titleLabel.font = [UIFont systemFontOfSize:13];
    [titleL setTitle:@"关于 TESLSRIA" forState:UIControlStateNormal];
    [titleL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [titleL addTarget:self
               action:@selector(webAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleL];
    
    int width = 400;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-400)/2 ,CGRectGetMaxY(signup.frame) + 20,width, 40)];
    title.backgroundColor = [UIColor clearColor];
    [self.view addSubview:title];
    title.font = [UIFont systemFontOfSize:13];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    title.text = @"*本软件需要登录账号，绑定设备后使用！";
    
    
    /*
    ColumnsView *col = [[ColumnsView alloc] initWithFrame:CGRectZero];
    col.xStepPixel = 50;
    col.yStepPixel = 50;
    col.xStepValues = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    col.yStepValues = @[@"0",@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80"];
    col._themeColor = [UIColor orangeColor];
    col.xName = @"日期";
    col.yName = @"KW-h";
    
    [col initXY];
    
    col.maxColValue = 80;
    col.colWidth = 30;
    col.colValues = @[@"40",@"30",@"50",@"60",@"70",@"20",@"10",@"60"];
    
    [col draw];
    
    [self.view addSubview:col];
    
    ///测试组件 -- 需要提供背景切图
    CustomPickerView *levelSetting = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) withGrayOrLight:@"gray"];
    
    levelSetting._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    
    [self.view addSubview:levelSetting];
    
    levelSetting.center = CGPointMake(SCREEN_WIDTH/2, 80);
    
    [levelSetting selectRow:0 inComponent:0];
    
    IMP_BLOCK_SELF(WellcomeViewController);
    levelSetting._selectionBlock = ^(NSDictionary *values)
    {
        //[block_self didPickerValue:values];
    };
    
    
    JSlideView *slider = [[JSlideView alloc]
                          initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                          frame:CGRectZero];
    [self.view addSubview:slider];
    [slider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    
    slider.topEdge = 60;
    slider.bottomEdge = 55;
    slider.maxValue = 20;
    slider.minValue = -20;
    
    [slider resetScale];
    
    slider.center = CGPointMake(600, 400);
    
    
    ColumnView *col1 = [[ColumnView alloc] initWithFrame:CGRectMake(0, 0, 10, 60)];
    [self.view addSubview:col1];
    [col1 setHValue:0.5];
    col1.center =CGPointMake(920, 430);
    
    
    CircleProgressView *circle = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.view addSubview:circle];
    [circle setProgress:0.5];
    circle.center = CGPointMake(600, 340);
    
    SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    
    [self.view addSubview:btn];
    btn.center = CGPointMake(600, 540);
    
//    SignalView *signal = [[SignalView alloc] initWithFrame:CGRectMake(800, 400, 30, 20)];
//    [self.view addSubview:signal];
//    [signal setLightColor:[UIColor greenColor]];//SINGAL_COLOR
//    [signal setGrayColor:[UIColor colorWithWhite:1.0 alpha:0.6]];
//    [signal setSignalValue:4];
//
//    BatteryView *batter = [[BatteryView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:batter];
//    batter.center = CGPointMake(900, 430);
//
//    [batter setBatteryValue:0.5];
//
//    BatteryView *batter1 = [[BatteryView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:batter1];
//    batter1.center = CGPointMake(950, 430);
//
//    [batter1 setBatteryValue:0.18];
    
    
    MixVoiceSettingsView *ecp = [[MixVoiceSettingsView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
    [self.view addSubview:ecp];
     */
    
    
   
    
}

- (void) webAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.teslaria.com"]];
}

- (void) loginAction:(id)sender{
    
    LoginViewController *lctrl = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) signupAction:(id)sender{
    SignupViewController *lctrl = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
