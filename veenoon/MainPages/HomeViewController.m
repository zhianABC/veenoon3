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
#import "UserVideoLuBoJiViewCtrl.h"
#import "VNSettingsView.h"

@interface HomeViewController () {
    
    UIButton *_settingsBtn;
    UIButton *_engineerBtn;
    UIButton *_userBtn;
    
    UIView *_homeView;
    UILabel* timeLabel;
    UILabel* dateLabel;
    UILabel* weekdayLabel;
    
    NSTimer *_timer;
    BOOL _isStop;
    
    UIScrollView *_content;
    
    VNSettingsView *_vnsetView;
}

@end

@implementation HomeViewController

- (void) viewWillAppear:(BOOL)animated
{
    if(_timer && [_timer isValid])
    {
        [_timer invalidate];
    }
    
    _isStop = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(updateTime)
                                            userInfo:nil
                                             repeats:NO];

}

- (void) viewWillDisappear:(BOOL)animated{
    
    _isStop = YES;
    if(_timer && [_timer isValid])
    {
        [_timer invalidate];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    
    _homeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self createHomeView];
    
    _vnsetView = [[VNSettingsView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_vnsetView setViewCtrl:self];
    
    _content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _content.bounces = NO;
    [self.view addSubview:_content];
    _content.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT);
    _content.pagingEnabled = YES;
    _content.showsHorizontalScrollIndicator = NO;
    
    [_content addSubview:_homeView];
    [_content addSubview:_vnsetView];

    CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
    UIEdgeInsets inset = _content.contentInset;
    inset.top = -StatusRect.size.height;
    _content.contentInset = inset;
    
}



- (void) createHomeView{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_background.png"]];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_homeView addSubview:imageView];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_shadow.png"]];
    icon.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
    icon.userInteractionEnabled = YES;
    [_homeView addSubview:icon];
    
    
    _engineerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _engineerBtn.frame = CGRectMake(70, SCREEN_HEIGHT - 60, 50, 50);
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_n.png"] forState:UIControlStateNormal];
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_s.png"] forState:UIControlStateHighlighted];
    [_engineerBtn addTarget:self action:@selector(engineerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homeView addSubview:_engineerBtn];
    
    
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 60, 50, 50);
    [_userBtn setImage:[UIImage imageNamed:@"main_user_log_normal.png"] forState:UIControlStateNormal];
    [_userBtn setImage:[UIImage imageNamed:@"main_user_login_selected.png"] forState:UIControlStateHighlighted];
    [_userBtn addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homeView addSubview:_userBtn];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                   SCREEN_HEIGHT - 240,
                                                                   SCREEN_WIDTH, 60)];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:60];
    timeLabel.userInteractionEnabled = YES;
    
    NSString *hourStr = [NSDate currentHour];
    NSString *minuteStr = [NSDate currentMinute];
    timeLabel.text = [hourStr stringByAppendingString:minuteStr];
    
    [_homeView addSubview:timeLabel];
    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                   SCREEN_HEIGHT - 180,
                                                                   110, 40)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:24];
    dateLabel.userInteractionEnabled = YES;
    
    NSString *dateStr = [NSDate currentDate];
    
    dateLabel.text = dateStr;
    [_homeView addSubview:dateLabel];
    
    
    weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(180,
                                                                      SCREEN_HEIGHT - 180,
                                                                      120, 40)];
    weekdayLabel.textColor = [UIColor whiteColor];
    weekdayLabel.font = [UIFont systemFontOfSize:24];
    weekdayLabel.userInteractionEnabled = YES;
    
    NSString *weekDayStr = [NSDate currentWeekday];
    
    weekdayLabel.text = weekDayStr;
    [_homeView addSubview:weekdayLabel];
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [_homeView addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 50, 70, 10);
    
    
    
}

- (void) updateTime{
    
    NSString *hourStr = [NSDate currentHour];
    NSString *minuteStr = [NSDate currentMinute];
    timeLabel.text = [hourStr stringByAppendingString:minuteStr];
    
    NSString *dateStr = [NSDate currentDate];
    dateLabel.text = dateStr;
    
    NSString *weekDayStr = [NSDate currentWeekday];
    weekdayLabel.text = weekDayStr;
    
    if(!_isStop)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateTime)
                                                userInfo:nil
                                                 repeats:NO];
    }
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
