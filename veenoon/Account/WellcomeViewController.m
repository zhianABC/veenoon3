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
    [login setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
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
    [signup setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    signup.center = CGPointMake(SCREEN_WIDTH/2+150, CGRectGetMaxY(icon.frame)+140);

    [signup addTarget:self
              action:@selector(signupAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(40,
                                                                SCREEN_HEIGHT - 60,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"关于TESLSRIA";
    
    [self.view addSubview:titleL];
    
    ///测试组件 -- 需要提供背景切图
    CustomPickerView *levelSetting = [[CustomPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    levelSetting._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    
    [self.view addSubview:levelSetting];
    
    levelSetting.center = CGPointMake(SCREEN_WIDTH/2, 80);
    
    [levelSetting selectRow:0 inComponent:0];
    
    IMP_BLOCK_SELF(WellcomeViewController);
    levelSetting._selectionBlock = ^(NSDictionary *values)
    {
        //[block_self didPickerValue:values];
    };
    
    
    ColumnsView *col = [[ColumnsView alloc] initWithFrame:CGRectZero];
    col.xStepPixel = 50;
    col.yStepPixel = 50;
    col.xStepValues = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    col.yStepValues = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90"];
    col._themeColor = [UIColor orangeColor];
    [col initXY];
    
    col.maxColValue = 90;
    col.colWidth = 30;
    col.colValues = @[@"40",@"30",@"50",@"60",@"70",@"20"];
    
    [col draw];
    
    [self.view addSubview:col];
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
