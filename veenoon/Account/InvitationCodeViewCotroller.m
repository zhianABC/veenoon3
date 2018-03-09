//
//  LoginViewController.m
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "InvitationCodeViewCotroller.h"
#import "UIButton+Color.h"
#import "UIImageView+WebCache.h"
#import "SBJson4.h"
#import "User.h"
#import "UserDefaultsKV.h"
#import "NetworkChecker.h"
#import "AppDelegate.h"
#import "WaitDialog.h"
#import "DataSync.h"

#define T7DaySecs (7*24*3600)


@interface InvitationCodeViewCotroller () {
    //输入部分
    UIView *_inputPannel;
    UITextField *_invitationCode;
}
@end

@implementation InvitationCodeViewCotroller

- (void) viewWillAppear:(BOOL)animated {
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable) {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    } else {
        _networkStatus.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50,
                                                                80,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"请输入官方授权的序列号";
   
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
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 180)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = -10;
    int w = CGRectGetWidth(_inputPannel.frame) - 30;
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"注册号";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    ///手机号输入框 pending....
    _invitationCode = [[UITextField alloc] initWithFrame:CGRectMake(left + 80, top+10, w-50, 30)];
    _invitationCode.delegate = self;
    _invitationCode.layer.cornerRadius = 5;
    _invitationCode.layer.masksToBounds = YES;
    _invitationCode.textAlignment = NSTextAlignmentCenter;
    _invitationCode.returnKeyType = UIReturnKeyDone;
    _invitationCode.placeholder = @"";
    _invitationCode.backgroundColor = [UIColor whiteColor];
    _invitationCode.textColor = RGB(1, 138, 182);
    _invitationCode.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_invitationCode];
}

- (void) cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okAction:(UIButton*) btn {
    [self didLogin];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) enterAdminMode{
    
    
}

- (void) didLogin {
    
    [[AppDelegate shareAppDelegate] enterApp];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
