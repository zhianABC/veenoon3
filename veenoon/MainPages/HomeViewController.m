//
//  HomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HomeViewController.h"

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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                SCREEN_HEIGHT - 80,
                                                                SCREEN_WIDTH, 80)];
    UIColor *tintColor = [UIColor colorWithWhite:0 alpha:0.3];
    [titleL setBackgroundColor:tintColor];
    titleL.userInteractionEnabled =YES;
    [self.view addSubview:titleL];
    
    _settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsBtn.frame = CGRectMake(SCREEN_WIDTH - 90, SCREEN_HEIGHT - 80, 50, 50);
    [_settingsBtn setImage:[UIImage imageNamed:@"main_settings_n.png"] forState:UIControlStateNormal];
    [_settingsBtn setImage:[UIImage imageNamed:@"main_settings_s.png"] forState:UIControlStateHighlighted];
    [_settingsBtn addTarget:self action:@selector(settingsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsBtn];
    
    
    _engineerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _engineerBtn.frame = CGRectMake(CGRectGetMinX(_settingsBtn.frame)-110, SCREEN_HEIGHT - 80, 50, 50);
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_n.png"] forState:UIControlStateNormal];
    [_engineerBtn setImage:[UIImage imageNamed:@"main_engineer_s.png"] forState:UIControlStateHighlighted];
    [_engineerBtn addTarget:self action:@selector(engineerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_engineerBtn];
    
    
    _userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userBtn.frame = CGRectMake(SCREEN_WIDTH/2 - 200, SCREEN_HEIGHT - 80, 50, 50);
    [_userBtn setImage:[UIImage imageNamed:@"main_user_log_normal.png"] forState:UIControlStateNormal];
    [_userBtn setImage:[UIImage imageNamed:@"main_user_login_selected.png"] forState:UIControlStateHighlighted];
    [_userBtn addTarget:self action:@selector(userLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userBtn];
}

- (void) settingsAction:(id)sender{
    
}

- (void) userLoginAction:(id)sender{
    
}

- (void) engineerAction:(id)sender{
    
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
