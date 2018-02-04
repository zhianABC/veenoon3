//
//  SettingsViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsUserView.h"
#import "SettingsViewView.h"
#import "SettingsAccountView.h"
#import "OutSystemView.h"

@interface SettingsViewController () <SettingsAccountViewDelegate> {
    UIButton *userSettingBtn;
    UIButton *viewSettingBtn;
    UIButton *accountSettingBtn;
    
    SettingsUserView *settingsUserView;
    SettingsViewView *settingsViewView;
    SettingsAccountView *settingsAccountView;
    
}

@end

@implementation SettingsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(60, 40, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    ///
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
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
    
    userSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userSettingBtn.frame = CGRectMake(SCREEN_WIDTH/3, CGRectGetMinY(bottomBar.frame) - 70, 50, 50);
    [userSettingBtn setImage:[UIImage imageNamed:@"settings_user_s.png"] forState:UIControlStateNormal];
    [userSettingBtn setImage:[UIImage imageNamed:@"settings_user_s.png"] forState:UIControlStateHighlighted];
    [userSettingBtn addTarget:self action:@selector(userSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userSettingBtn];
    

    viewSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    viewSettingBtn.frame = CGRectMake(SCREEN_WIDTH/2, CGRectGetMinY(bottomBar.frame) - 70, 50, 50);
    [viewSettingBtn setImage:[UIImage imageNamed:@"settings_view_n.png"] forState:UIControlStateNormal];
    [viewSettingBtn setImage:[UIImage imageNamed:@"settings_view_s.png"] forState:UIControlStateHighlighted];
    [viewSettingBtn addTarget:self action:@selector(viewSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewSettingBtn];
    

    accountSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountSettingBtn.frame = CGRectMake(SCREEN_WIDTH*2/3, CGRectGetMinY(bottomBar.frame) - 70, 50, 50);
    [accountSettingBtn setImage:[UIImage imageNamed:@"settings_account_n.png"] forState:UIControlStateNormal];
    [accountSettingBtn setImage:[UIImage imageNamed:@"settings_account_s.png"] forState:UIControlStateHighlighted];
    [accountSettingBtn addTarget:self action:@selector(accountSettingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountSettingBtn];
    

    settingsUserView = [[SettingsUserView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-240)];
    settingsUserView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    settingsUserView.delegate = self;
    settingsUserView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingsUserView];
}
                                      
                                      
- (void) userSettingAction:(id)sender{
    
    [userSettingBtn setImage:[UIImage imageNamed:@"settings_user_s.png"] forState:UIControlStateNormal];
    [viewSettingBtn setImage:[UIImage imageNamed:@"settings_view_n.png"] forState:UIControlStateNormal];
   [accountSettingBtn setImage:[UIImage imageNamed:@"settings_account_n.png"] forState:UIControlStateNormal];
    
    if (settingsViewView) {
        settingsViewView.hidden = YES;
    }
    if (settingsUserView == nil) {
        settingsUserView = [[SettingsUserView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-240)];
        settingsUserView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        //    settingsUserView.delegate = self;
        settingsUserView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:settingsUserView];
    } else {
        settingsUserView.hidden = NO;
    }
    if (settingsAccountView) {
        settingsAccountView.hidden = YES;
    }
}

- (void) viewSettingAction:(id)sender{
    
    [userSettingBtn setImage:[UIImage imageNamed:@"settings_user_n.png"] forState:UIControlStateNormal];
    [viewSettingBtn setImage:[UIImage imageNamed:@"settings_view_s.png"] forState:UIControlStateNormal];
    [accountSettingBtn setImage:[UIImage imageNamed:@"settings_account_n.png"] forState:UIControlStateNormal];
    
    if (settingsUserView) {
        settingsUserView.hidden = YES;
    }
    if (settingsViewView == nil) {
        settingsViewView = [[SettingsViewView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-240)];
        settingsViewView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        //    settingsUserView.delegate = self;
        settingsViewView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:settingsViewView];
    } else {
        settingsViewView.hidden = NO;
    }
    if (settingsAccountView) {
        settingsAccountView.hidden = YES;
    }
}

- (void) accountSettingAction:(id)sender{
    
    [userSettingBtn setImage:[UIImage imageNamed:@"settings_user_n.png"] forState:UIControlStateNormal];
    [viewSettingBtn setImage:[UIImage imageNamed:@"settings_view_n.png"] forState:UIControlStateNormal];
    [accountSettingBtn setImage:[UIImage imageNamed:@"settings_account_s.png"] forState:UIControlStateNormal];
    
    if (settingsViewView) {
        settingsViewView.hidden = YES;
    }
    if (settingsAccountView == nil) {
        settingsAccountView = [[SettingsAccountView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-240)];
        settingsAccountView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        //    settingsUserView.delegate = self;
        settingsAccountView.backgroundColor = [UIColor clearColor];
        settingsAccountView.delegate = self;
        [self.view addSubview:settingsAccountView];
    } else {
        settingsAccountView.hidden = NO;
    }
    if (settingsUserView) {
        settingsUserView.hidden = YES;
    }
}

- (void) enterOutSystem {
    OutSystemView *outSystemView = [[OutSystemView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:outSystemView];
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = outSystemView.frame;
        frame.origin.y = 0.f;
        [outSystemView setFrame:frame];
    }];
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
