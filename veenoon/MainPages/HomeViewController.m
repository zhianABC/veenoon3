//
//  HomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "EnginnerHomeViewController.h"
#import "UserHomeViewController.h"
#import "NSDate-Helper.h"

@interface HomeViewController () {
    UIButton *_settingsBtn;
    UIButton *_engineerBtn;
    UIButton *_userBtn;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:imageView];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_shadow.png"]];
    icon.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
    icon.userInteractionEnabled = YES;
    [self.view addSubview:icon];
    
    _settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsBtn.frame = CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 60, 50, 50);
    [_settingsBtn setImage:[UIImage imageNamed:@"main_settings_n.png"] forState:UIControlStateNormal];
    [_settingsBtn setImage:[UIImage imageNamed:@"main_settings_s.png"] forState:UIControlStateHighlighted];
    [_settingsBtn addTarget:self action:@selector(settingsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsBtn];
    
    
    _engineerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _engineerBtn.frame = CGRectMake(CGRectGetMinX(_settingsBtn.frame)-90, SCREEN_HEIGHT - 60, 50, 50);
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_n.png"] forState:UIControlStateNormal];
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_s.png"] forState:UIControlStateHighlighted];
    [_engineerBtn addTarget:self action:@selector(engineerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_engineerBtn];
    
    
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 460, SCREEN_HEIGHT - 60, 50, 50);
    [_userBtn setImage:[UIImage imageNamed:@"main_user_log_normal.png"] forState:UIControlStateNormal];
    [_userBtn setImage:[UIImage imageNamed:@"main_user_login_selected.png"] forState:UIControlStateHighlighted];
    [_userBtn addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userBtn];
    
    UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                SCREEN_HEIGHT - 240,
                                                                SCREEN_WIDTH, 60)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:60];
    timeLabel.userInteractionEnabled = YES;
    
    NSString *hourStr = [NSDate currentHour];
    NSString *minuteStr = [NSDate currentMinute];
    
    timeLabel.text = [hourStr stringByAppendingString:minuteStr];
    [self.view addSubview:timeLabel];
    
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                   SCREEN_HEIGHT - 180,
                                                                   110, 40)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:24];
    dateLabel.userInteractionEnabled = YES;
    
    NSString *dateStr = [NSDate currentDate];
    
    dateLabel.text = dateStr;
    [self.view addSubview:dateLabel];
    
    
    UILabel* weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(180,
                                                                   SCREEN_HEIGHT - 180,
                                                                   120, 40)];
    weekdayLabel.textColor = [UIColor whiteColor];
    weekdayLabel.font = [UIFont systemFontOfSize:24];
    weekdayLabel.userInteractionEnabled = YES;
    
    NSString *weekDayStr = [NSDate currentWeekday];
    
    weekdayLabel.text = weekDayStr;
    [self.view addSubview:weekdayLabel];
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 50,
                                 70, 10);
     [self.view addSubview:titleIcon];
}

- (void) settingsAction:(id)sender{
    SettingsViewController *lctrl = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) userLoginAction:(id)sender{
    UserHomeViewController *lctrl = [[UserHomeViewController alloc] init];
    [self.navigationController pushViewController:lctrl animated:YES];
}

- (void) engineerAction:(id)sender{
    EnginnerHomeViewController *lctrl = [[EnginnerHomeViewController alloc] init];
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
