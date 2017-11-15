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

@interface WellcomeViewController ()

@end

@implementation WellcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(1, 138, 182);
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"teslaria_title.png"]];
    [self.view addSubview:icon];
    icon.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.5);
    
    UIButton *login = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    login.frame = CGRectMake(0, 0,260, 50);
    login.layer.cornerRadius = 5;
    login.layer.borderWidth = 2;
    login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.clipsToBounds = YES;
    [self.view addSubview:login];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setTitleColor:RGB(57, 137, 178) forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    login.center = CGPointMake(SCREEN_WIDTH/2-150, CGRectGetMaxY(icon.frame)+140);

    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(0, 0,260, 50);
    signup.layer.cornerRadius = 5;
    signup.layer.borderWidth = 2;
    signup.layer.borderColor = [UIColor whiteColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"注册" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:RGB(57, 137, 178) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    signup.center = CGPointMake(SCREEN_WIDTH/2+150, CGRectGetMaxY(icon.frame)+140);

    [signup addTarget:self
              action:@selector(signupAction:)
    forControlEvents:UIControlEventTouchUpInside];
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
