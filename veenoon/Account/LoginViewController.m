//
//  LoginViewController.m
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "LoginViewController.h"
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


@interface LoginViewController ()
{
    //输入部分
    UIView *_inputPannel;
    UILabel *_country;
    UILabel *_countrycode;
}
@end

@implementation LoginViewController

- (void) viewWillAppear:(BOOL)animated
{
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable)
    {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    }
    else
    {
        _networkStatus.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50,
                                                                80,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"使用手机号码登录";
   
    ///
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
                  action:@selector(okAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame)-20;
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"国家/地区";
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    _country = [[UILabel alloc] initWithFrame:CGRectMake(left+130, top, w, 50)];
    _country.text = @"中国";
    _country.textColor = [UIColor whiteColor];
    _country.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_country];
    
    //选择箭头 pending....
    
    //包括click事件，弹出popview，选择国家地区
    
    top = CGRectGetMaxY(_country.frame);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = THEME_COLOR_A(0.5);
    [_inputPannel addSubview:line];
    
    _countrycode = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    _countrycode.text = @"+86";
    _countrycode.textColor = [UIColor whiteColor];
    _countrycode.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_countrycode];
    
    ///手机号输入框 pending....
    
    ////
    
    top = CGRectGetMaxY(_countrycode.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = THEME_COLOR_A(0.5);
    [_inputPannel addSubview:line];
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"密码";
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    //密码输入框 pending....
    
    //////
    
    top = CGRectGetMaxY(tL.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = THEME_COLOR_A(0.5);
    [_inputPannel addSubview:line];
}

- (void) cancelAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okAction:(id)sender{
    
    //登录
}

- (void) notifyNetworkStatusChanged:(NSNotification*)notify{
    
    NSDictionary *userinfo = [notify userInfo];
    BOOL network = [[userinfo objectForKey:@"status"] boolValue];
    if(!network)
    {
        _networkStatus.text = @"没有连接网络...";
        _networkStatus.hidden = NO;
    }
    else
    {
        _networkStatus.hidden = YES;
    }
}




- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    _inputBg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-220);
    
    
    
    _networkStatus.frame = CGRectMake(10,
                                      CGRectGetMaxY(_inputBg.frame)+10,
                                      DEFAULT_SCREEN_WIDTH-20, 20);
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    _inputBg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60);
    
    
    
    _networkStatus.frame = CGRectMake(10,
                                      CGRectGetMaxY(_inputBg.frame)+10,
                                      DEFAULT_SCREEN_WIDTH-20, 20);
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == _userName)
    {
        [_userPwd becomeFirstResponder];
    }
    
    return YES;
}

- (void) enterAdminMode{
    
    
}

- (void) loginAction:(UIButton*)btn{
    
    if([_userName.text length] < 1)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入登录名！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([_userPwd.text length] < 1)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入密码！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable)
    {
        //没有网络的情况下
        
        User *u = [UserDefaultsKV getUser];
        if(u)
        {
            if([_userName.text isEqualToString:u._userName] &&
               [_userPwd.text isEqualToString:[UserDefaultsKV getUserPwd]])
            
                [self didLogin];
            else{
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"用户名或密码错误！"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"没有离线登录的账号！"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
            [alert show];
        }
        
        //返回
        return;
    }
    
    
    if([_userName isFirstResponder])
        [_userName resignFirstResponder];
    
    if([_userPwd isFirstResponder])
        [_userPwd resignFirstResponder];
    
    
    if(_autoClient == nil)
        _autoClient = [[WebClient alloc] initWithDelegate:self];
    
    _autoClient._httpMethod = @"GET";
    _autoClient._method = NEW_API_LOGIN;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_userName.text forKey:@"username"];
    [params setObject:_userPwd.text forKey:@"password"];
    [params setObject:@"CN" forKey:@"countrycode"];
    [params setObject:@"1" forKey:@"NEW_SYS"];
    
    _autoClient._requestParam = params;
    
    IMP_BLOCK_SELF(LoginViewController);
    
    btn.enabled = NO;
    
    [_autoClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                if(code == 0)
                {
                    NSString *token = [v objectForKey:@"token"];
                    
                    User *u = [[User alloc] initWithDicionary:v];
                    u._userName = _userName.text;
                    [UserDefaultsKV saveUserPwd:_userPwd.text];
                    u._authtoken = token;
                    
                    [UserDefaultsKV saveUser:u];
                    
                    [block_self didLogin];
                }
                else
                {
                    btn.enabled = YES;
                    
                    NSString *message = [v objectForKey:@"msg"];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                return;
            }
            
        };
        
        SBJson4ErrorBlock eh = ^(NSError* err) {
            NSLog(@"OOPS: %@", err);
            
        };
        
        id parser = [SBJson4Parser multiRootParserWithBlock:block
                                               errorHandler:eh];
        
        id data = [response dataUsingEncoding:NSUTF8StringEncoding];
        [parser parse:data];
        
        
    } FailBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        NSLog(@"%@", response);
        
        
    }];
    
}

- (void) didLogin{
    
    
    
    [[AppDelegate shareAppDelegate] enterApp];
    
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
