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
#import "XDPickView.h"
#import "wsDB.h"
#import "SignupViewController.h"
#import "Utilities.h"
#import "KVNProgress.h"
#import "DataCenter.h"

#define T7DaySecs (7*24*3600)


@interface LoginViewController () <XDPickerDelegate>
{
    //输入部分
    UIView *_inputPannel;
    UILabel *_country;
    UILabel *_countrycode;
    
    XDPickView *pick;
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
    
    self.view.backgroundColor = BLACK_COLOR;
    // Do any additional setup after loading the view.
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(80,
                                                                80,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:18];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"使用手机号码登录";
   
    ///
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
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
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
    _inputPannel.userInteractionEnabled = YES;
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame);
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"国家/地区";
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    _country = [[UILabel alloc] initWithFrame:CGRectMake(left+120, top, w, 50)];
    _country.text = @"中国";
    _country.textColor = YELLOW_COLOR;
    _country.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_country];
    
    //选择箭头 pending....
    UIButton *countrySelector = [UIButton buttonWithType:UIButtonTypeCustom];
    int w2 = CGRectGetWidth(_inputPannel.frame)-20;
    countrySelector.frame = CGRectMake(left+w2-30, top + 10, 54, 30);
    [countrySelector setImage:[UIImage imageNamed:@"down_arraw.png"] forState:UIControlStateNormal];
    [_inputPannel addSubview:countrySelector];
    
    [countrySelector addTarget:self
              action:@selector(countrySelectAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    //包括click事件，弹出popview，选择国家地区
    
    top = CGRectGetMaxY(_country.frame);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [_inputPannel addSubview:line];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left +80, top, 1, 50)];
    line.backgroundColor = [UIColor whiteColor];
    [_inputPannel addSubview:line];
    
    _countrycode = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    _countrycode.text = @"+86";
    _countrycode.textColor = [UIColor whiteColor];
    _countrycode.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_countrycode];
    
    ///手机号输入框 pending....
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(left + 95, top+10, w-95, 30)];
    _userName.delegate = self;
    _userName.returnKeyType = UIReturnKeyDone;
    _userName.placeholder = @"输入手机号码";
    _userName.keyboardType = UIKeyboardTypePhonePad;
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor whiteColor];
    _userName.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_userName];
    ////
    
    top = CGRectGetMaxY(_countrycode.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [_inputPannel addSubview:line];
    
    tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"密码";
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    //密码输入框 pending....
    _userPwd = [[UITextField alloc] initWithFrame:CGRectMake(left + 95, top+10, w-95, 30)];
    _userPwd.delegate = self;
    _userPwd.returnKeyType = UIReturnKeyDone;
    _userPwd.placeholder = @"6-12位密码";
    _userPwd.backgroundColor = [UIColor clearColor];
    _userPwd.textColor = [UIColor whiteColor];
    _userPwd.borderStyle = UITextBorderStyleNone;
    _userPwd.secureTextEntry = YES;
    [_inputPannel addSubview:_userPwd];
    //////
    
    top = CGRectGetMaxY(tL.frame);
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [_inputPannel addSubview:line];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(SCREEN_WIDTH/2 - w/2, CGRectGetMaxY(_inputPannel.frame)+60, w, 50);
    [registerBtn setTitle:@"创建您的TESLARIA账户！" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [registerBtn addTarget:self
                  action:@selector(registerAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
     User *u = [UserDefaultsKV getUser];
    if(u)
    {
        _userName.text = u._cellphone;
        _userPwd.text = [UserDefaultsKV getUserPwd];
    }
}

- (void) registerAction:(id)sender {
    SignupViewController *ctrl = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) countrySelectAction:(id)sender{
    
    NSArray *counrtryArray = [[wsDB sharedDBInstance] queryAllCountryCodes];
    
    NSMutableArray *countiesName = [NSMutableArray arrayWithCapacity:[counrtryArray count]];
    for (NSDictionary *dic in counrtryArray) {
        NSString *name = [dic objectForKey:@"name"];
        
        [countiesName addObject:name];
    }
    
    pick = [[XDPickView alloc] initWithFrame:CGRectMake(0, 0, 600, 300)];
    pick.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    pick.pickViewTextArray = countiesName;//设置数据
    pick.backgroundColor = [UIColor whiteColor];
    pick.contentTextColor = [UIColor blackColor];
    pick.LieWidth = 200;
    pick.delegate = self;
    
    [self.view addSubview:pick];
    
}
                                                        
- (void)PickerSelectorIndixString:(NSString *)str {
    _country.text = str;
    
    NSArray *counrtryArray = [[wsDB sharedDBInstance] queryAllCountryCodes];
    
    for (NSDictionary *dic in counrtryArray) {
        NSString *name = [dic objectForKey:@"name"];
        
        if ([name isEqualToString:str]) {
            NSString *code = [dic objectForKey:@"telcode"];
            code = [@"+" stringByAppendingString:code];
            _countrycode.text = code;
        }
    }
    
    [pick removeFromSuperview];
}
                                                        
- (void) cancelAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) okAction:(UIButton*)btn {
    
    NSString *userName = _userName.text;
    NSString *userPwd = _userPwd.text;
    if ([userName length] < 1) {
        
        [Utilities showMessage:@"请输入登录名！" ctrl:self];
        
        return;
    }
    if ([userPwd length] < 1) {
        
        [Utilities showMessage:@"请输入密码！" ctrl:self];

        return;
    }
    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable) {
        //没有网络的情况下
        
        User *u = [UserDefaultsKV getUser];
        if (u) {
            if([_userName.text isEqualToString:u._cellphone] &&
               [_userPwd.text isEqualToString:[UserDefaultsKV getUserPwd]]) {
                
                [self checkUserActive];
                
            } else {
                
                [Utilities showMessage:@"用户名或密码错误！" ctrl:self];
            }
        } else {
            
            [Utilities showMessage:@"没有离线登录的账号！" ctrl:self];
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
    _autoClient._method = @"/userlogin";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_userName.text forKey:@"telephone"];
    [params setObject:_userPwd.text forKey:@"password"];
    
    _autoClient._requestParam = params;
    
    btn.enabled = NO;
    
    IMP_BLOCK_SELF(LoginViewController);
    
    [KVNProgress show];
    
    [_autoClient requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        [KVNProgress dismiss];
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if ([v isKindOfClass:[NSDictionary class]]) {
                int  code = [[v objectForKey:@"code"] intValue];
                if (code == 200) {
                    
                    NSDictionary *data = [v objectForKey:@"data"];
                    [block_self processLoginData:data];
                    
                } else {
                    btn.enabled = YES;
                    
                    NSString *message = [v objectForKey:@"message"];
                    
                    [Utilities showMessage:message ctrl:self];
                    
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
        
        [KVNProgress dismiss];
    }];
}

- (void) processLoginData:(NSDictionary*)data{
    
    User *u = [[User alloc] initWithDicionary:data];
    [UserDefaultsKV saveUserPwd:_userPwd.text];
    [UserDefaultsKV saveUser:u];
    
    
    [self checkUserActive];
 }

- (void) checkUserActive{
    
    User *u = [UserDefaultsKV getUser];
    
    if(![u isActive])
    {
        InvitationCodeViewCotroller *invitation = [[InvitationCodeViewCotroller alloc] init];
        [self.navigationController pushViewController:invitation animated:YES];
        
    }
    else
    {
        [[DataCenter defaultDataCenter] syncDriversWithServer];
        [[AppDelegate shareAppDelegate] enterApp];
    }
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
         _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 120);
    }
    if (textField == _userName) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 70);
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
