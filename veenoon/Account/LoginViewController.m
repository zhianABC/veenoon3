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
#import "InvitationCodeViewCotroller.h"

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
    titleL.text = @"使用手机号码登录";
   
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
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame);
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"国家/地区";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    _country = [[UILabel alloc] initWithFrame:CGRectMake(left+120, top, w, 50)];
    _country.text = @"中国";
    _country.textColor = [UIColor whiteColor];
    _country.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_country];
    
    //选择箭头 pending....
    UIButton *countrySelector = [UIButton buttonWithType:UIButtonTypeCustom];
    int w2 = CGRectGetWidth(_inputPannel.frame)-20;
    countrySelector.frame = CGRectMake(left+w2, top + 18, 8, 14);
    [countrySelector setBackgroundImage:[UIImage imageNamed:@"login_right_arraw.png"] forState:UIControlStateNormal];
    [_inputPannel addSubview:countrySelector];
    
    [countrySelector addTarget:self
              action:@selector(countrySelectAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    //包括click事件，弹出popview，选择国家地区
    
    top = CGRectGetMaxY(_country.frame);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [_inputPannel addSubview:line];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left +80, top, 1, 50)];
    line.backgroundColor = RGB(75, 163, 202);
    [_inputPannel addSubview:line];
    
    _countrycode = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    _countrycode.text = @"+86";
    _countrycode.textColor = RGB(70, 219, 254);
    _countrycode.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_countrycode];
    
    ///手机号输入框 pending....
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(left + 85, top+10, w-85, 30)];
    _userName.delegate = self;
    _userName.returnKeyType = UIReturnKeyDone;
    _userName.placeholder = @"";
    _userName.keyboardType = UIKeyboardTypePhonePad;
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor whiteColor];
    _userName.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_userName];
    ////
    
    top = CGRectGetMaxY(_countrycode.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [_inputPannel addSubview:line];
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"密码";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    //密码输入框 pending....
    _userPwd = [[UITextField alloc] initWithFrame:CGRectMake(left + 85, top+10, w-85, 30)];
    _userPwd.delegate = self;
    _userPwd.returnKeyType = UIReturnKeyDone;
    _userPwd.placeholder = @"6-12位密码";
    _userPwd.backgroundColor = [UIColor clearColor];
    _userPwd.textColor = RGB(70, 219, 254);
    _userPwd.borderStyle = UITextBorderStyleNone;
    _userPwd.secureTextEntry = YES;
    [_inputPannel addSubview:_userPwd];
    //////
    
    top = CGRectGetMaxY(tL.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [_inputPannel addSubview:line];
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top+160, w, 50)];
    tL.text = @"         创建您的TESLARIA账户！";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL];
}

- (void) countrySelectAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okAction:(UIButton*)btn {
    NSString *userName = _userName.text;
    NSString *userPwd = _userPwd.text;
    // temp login
    if (true) {
        InvitationCodeViewCotroller *invitation = [[InvitationCodeViewCotroller alloc] init];
        [self.navigationController pushViewController:invitation animated:YES];
        return;
    }
    if ([userName length] < 1) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入登录名！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([userPwd length] < 1) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"请输入密码！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable) {
        //没有网络的情况下
        
        User *u = [UserDefaultsKV getUser];
        if (u) {
            if([_userName.text isEqualToString:u._userName] &&
               [_userPwd.text isEqualToString:[UserDefaultsKV getUserPwd]]) {
                InvitationCodeViewCotroller *invitation = [[InvitationCodeViewCotroller alloc] init];
                [self.navigationController pushViewController:invitation animated:YES];
            } else {
                UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:@"用户名或密码错误！"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
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
    [params setObject:_userName.text forKey:@"userName"];
    [params setObject:_userPwd.text forKey:@"userPassword"];
    
    _autoClient._requestParam = params;
    
    btn.enabled = NO;
    
    [_autoClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if ([v isKindOfClass:[NSDictionary class]]) {
                NSString *status = [v objectForKey:@"status"];
                if ([status isEqualToString:@"sucess"]) {
                    NSString *token = [v objectForKey:@"token"];
                    
                    User *u = [[User alloc] initWithDicionary:v];
                    u._userName = _userName.text;
                    [UserDefaultsKV saveUserPwd:_userPwd.text];
                    u._authtoken = token;
                    
                    [UserDefaultsKV saveUser:u];
                    
                    InvitationCodeViewCotroller *invitation = [[InvitationCodeViewCotroller alloc] init];
                    [self.navigationController pushViewController:invitation animated:YES];
                } else {
                    btn.enabled = YES;
                    
                    NSString *message = [v objectForKey:@"loginInfor"];
                    
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
    if (textField == _userPwd) {
         _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 70);
    }
    if (textField == _userName) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 20);
    }
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == _userName) {
        [_userPwd becomeFirstResponder];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
