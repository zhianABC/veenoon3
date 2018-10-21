//
//  SignupViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "SignupViewController.h"
#import "AreaPickView.h"
#import "LoginViewController.h"
#import "InvitationCodeViewCotroller.h"
#import "UIButton+Color.h"
#import "Utilities.h"
#import "SBJson4.h"
#import "WaitDialog.h"
#import "User.h"
#import "UserDefaultsKV.h"
#import "M80AttributedLabel.h"
#import "CheckButton.h"
#import "FQCustomAlert.h"


@interface SignupViewController () <AreaPickViewDelegate, M80AttributedLabelDelegate>{
    //输入部分
    UIView *_inputPannel;
    UIButton *_countryBtn;
    UITextField *_companyName;
    UIButton *_regionBtn;
    UITextField *_addressTextfield;
    UITextField *_cellphoneTextfield;
    
    UIButton *_registerNumberBtn;
    UITextField *_jiaoyanmaTextfield;
    
    UILabel *_timerLabel;
    
    UITextField *_password;
    UITextField *_passwordAgain;
    
    AreaPickView *areaPick;
    
    UIButton *loginBtn;
    
    WebClient *_httpGetCode;
    NSTimer *_timer;
    int secondsCount;
    
    WebClient *_http;
    
    CheckButton *_privacyBtn;
}
@property (nonatomic, strong) NSString *_province;
@property (nonatomic, strong) NSString *_city;
@property (nonatomic, strong) NSString *_area;
@end

@implementation SignupViewController
@synthesize _province;
@synthesize _city;
@synthesize _area;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(80,
                                                                80,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"创建您的 TESLARIA 账户";
    
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    _inputPannel.userInteractionEnabled = YES;
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+50);
    
    int top = 80;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame);
    
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 80, 40)];
    tL.text = @"国家/地区";
    tL.textColor = [UIColor whiteColor];
    tL.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL];

    _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryBtn.frame = CGRectMake(left+120, top, w-80, 40);
    [_countryBtn setTitle:@"中国" forState:UIControlStateNormal];
    _countryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _countryBtn.titleLabel.textColor = [UIColor redColor];
    _countryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:_countryBtn];
    [_countryBtn addTarget:self
              action:@selector(countrySelectAction:)
    forControlEvents:UIControlEventTouchUpInside];


    UIImageView *rightArraw = [[UIImageView alloc] initWithFrame:CGRectMake(left + 280 + 100, top+18, 8, 14)];
    [_inputPannel addSubview:rightArraw];
    rightArraw.userInteractionEnabled = YES;
    rightArraw.image = [UIImage imageNamed:@"login_right_arraw.png"];

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(left, top +38, w, 1)];
    line.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line];

    ///手机号输入框 pending....
    _companyName = [[UITextField alloc] initWithFrame:CGRectMake(left, top+40, w-85, 40)];
    _companyName.delegate = self;
    _companyName.returnKeyType = UIReturnKeyDone;
    _companyName.placeholder = @"请输入企业名称";
    [_companyName setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _companyName.backgroundColor = [UIColor clearColor];
    _companyName.textColor = [UIColor whiteColor];
    _companyName.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_companyName];

    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top +78, w, 1)];
    line2.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line2];

    _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _regionBtn.frame = CGRectMake(left, top+80, w-80, 40);
    [_regionBtn setTitle:@"所在地区：" forState:UIControlStateNormal];
    _regionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_regionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:_regionBtn];
    [_regionBtn addTarget:self
                    action:@selector(regionSelectAction:)
          forControlEvents:UIControlEventTouchUpInside];

    UIImageView *rightArraw2 = [[UIImageView alloc] initWithFrame:CGRectMake(left + 280 + 100, top+18+90, 8, 14)];
    [_inputPannel addSubview:rightArraw2];
    rightArraw2.userInteractionEnabled = YES;
    rightArraw2.image = [UIImage imageNamed:@"login_right_arraw.png"];

    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+118, w, 1)];
    line3.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line3];

    _addressTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left, top+120, w-85, 40)];
    _addressTextfield.delegate = self;
    _addressTextfield.returnKeyType = UIReturnKeyDone;
    _addressTextfield.placeholder = @"请输入街道／楼宇／单位";
    [_addressTextfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _addressTextfield.backgroundColor = [UIColor clearColor];
    _addressTextfield.textColor = [UIColor whiteColor];
    _addressTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_addressTextfield];

    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+158, w, 1)];
    line4.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line4];

    UILabel *tL2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+160, 80, 40)];
    tL2.text = @"+86";
    tL2.textColor = [UIColor whiteColor];
    tL2.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL2];

    _cellphoneTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+160, 180, 40)];
    _cellphoneTextfield.delegate = self;
    _cellphoneTextfield.textAlignment = NSTextAlignmentLeft;
    _cellphoneTextfield.returnKeyType = UIReturnKeyDone;
    _cellphoneTextfield.placeholder = @"请输入手机号码";
    [_cellphoneTextfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _cellphoneTextfield.textColor = [UIColor whiteColor];
    _cellphoneTextfield.backgroundColor = [UIColor clearColor];
    _cellphoneTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_cellphoneTextfield];

    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(left+260, top+160, 1, 40)];
    line5.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line5];
    
    _registerNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerNumberBtn.frame = CGRectMake(left+285, top+160, 100, 40);
    [_registerNumberBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _registerNumberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_registerNumberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerNumberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_inputPannel addSubview:_registerNumberBtn];
    [_registerNumberBtn addTarget:self
                    action:@selector(registerNumberAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+198, w, 1)];
    line6.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line6];

    UILabel *tL3 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+200, 80, 40)];
    tL3.text = @"校验码";
    tL3.textColor = [UIColor whiteColor];
    tL3.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL3];

    _jiaoyanmaTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+200, 240, 40)];
    _jiaoyanmaTextfield.delegate = self;
    _jiaoyanmaTextfield.textAlignment = NSTextAlignmentLeft;
    _jiaoyanmaTextfield.returnKeyType = UIReturnKeyDone;
    _jiaoyanmaTextfield.placeholder = @"请输入短信校验码";
    [_jiaoyanmaTextfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _jiaoyanmaTextfield.backgroundColor = [UIColor clearColor];
    _jiaoyanmaTextfield.textColor = [UIColor whiteColor];
    _jiaoyanmaTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_jiaoyanmaTextfield];

    UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(left+260, top+200, 1, 40)];
    line7.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line7];

    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(left+285, top+200, 100, 40)];
    _timerLabel.text = @"180秒内有效";
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:_timerLabel];

    UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+238, w, 1)];
    line8.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line8];

    UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+278, w, 1)];
    line9.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line9];

    UILabel *tL4 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+280, 80, 40)];
    tL4.text = @"设置密码";
    tL4.textColor = [UIColor whiteColor];
    tL4.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL4];

    _password = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+280, 240, 40)];
    _password.delegate = self;
    _password.textAlignment = NSTextAlignmentLeft;
    _password.returnKeyType = UIReturnKeyDone;
    _password.placeholder = @"请输入6-16位密码";
    [_password setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _password.backgroundColor = [UIColor clearColor];
    _password.textColor = [UIColor whiteColor];
    _password.borderStyle = UITextBorderStyleNone;
    _password.secureTextEntry = YES;
    [_inputPannel addSubview:_password];

    UILabel *line10 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+318, w, 1)];
    line10.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line10];

    UILabel *tL5 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+320, 80, 40)];
    tL5.text = @"确认密码";
    tL5.textColor = [UIColor whiteColor];
    tL5.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:tL5];

    _passwordAgain = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+320, 240, 40)];
    _passwordAgain.delegate = self;
    _passwordAgain.textAlignment = NSTextAlignmentLeft;
    _passwordAgain.returnKeyType = UIReturnKeyDone;
    _passwordAgain.placeholder = @"请输入6-16位密码";
    [_passwordAgain setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _passwordAgain.backgroundColor = [UIColor clearColor];
    _passwordAgain.textColor = [UIColor whiteColor];
    _passwordAgain.borderStyle = UITextBorderStyleNone;
    _passwordAgain.secureTextEntry = YES;
    [_inputPannel addSubview:_passwordAgain];

    UILabel *line11 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+358, w, 1)];
    line11.backgroundColor = WHITE_LINE_COLOR;
    [_inputPannel addSubview:line11];
    
    int gap = 90;
    _privacyBtn = [[CheckButton alloc] initWithIcon:[UIImage imageNamed:@"check_box_unsel.png"]
                                                    down:[UIImage imageNamed:@"check_box_p.png"]
                                                   title:@""
                                                   frame:CGRectMake(left-35+gap, top+380, 60, 40)];
    [_inputPannel addSubview:_privacyBtn];
    [_privacyBtn allowUnCheck:YES];

    M80AttributedLabel* rowName = [[M80AttributedLabel alloc] initWithFrame:CGRectMake(left+gap, top+390, w+60, 40)];
    rowName.backgroundColor = [UIColor clearColor];
    rowName.font = [UIFont systemFontOfSize:13];
    rowName.lineSpacing = 2.0;
    rowName.paragraphSpacing = 2.0;
    rowName.autoDetectLinks = NO;
    rowName.textAlignment = 0;
    
    rowName.delegate = self;
    
    rowName.textColor = [UIColor whiteColor];
    [_inputPannel addSubview:rowName];
    NSString *prex = @"已阅读并同意 ";
    [rowName appendText:prex];
    NSString *str = @"隐私协议和在线服务系列协议";
    
    [rowName appendText:str];
    [rowName appendText:@""];
    rowName.underLineForLink = NO;
    
    rowName.linkColor = NEW_ER_BUTTON_SD_COLOR;
    [rowName addCustomLink:@"" forRange:NSMakeRange([prex length], [str length])];

    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(left, top+420, w+60, 40);
    [loginBtn setTitle:@"* 如果您已经使用过了TESLARIA服务，则应返回以使用该账号登录 *" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_inputPannel addSubview:loginBtn];
    [loginBtn addTarget:self
                    action:@selector(loginBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];

}

- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData{
    NSLog(@"");
    
    FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitle:@"规则说明" WithContent:@"系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项，系统将随机从题库中抽取一套题，其中有单选、多选类型题目，请您认真审题后选出您认为正确的选项" WithImageName:@"activity_cloud" WithSureBtnTitle:@"AAA"];
    [alertView show];

}
- (void) loginBtnAction:(UIButton*) btn {

    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) successRegDone{
    
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"注册成功，将转入验证注册码界面"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:@"取消", nil];
    [alert show];
    alert.delegate = self;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _jiaoyanmaTextfield) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 70);
    }
    if (textField == _password) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 110);
    }
    if (textField == _passwordAgain) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 160);
    }
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) cancelAction:(id)sender{
    NSLog(@"enter the method.");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okAction:(UIButton*)btn{
    
    [self stopTimer];
    
    NSString *companyName = _companyName.text;
    NSString *address = _addressTextfield.text;
    NSString *pwd = _password.text;
    NSString *pwd1 = _passwordAgain.text;
    NSString *identifyCode = _jiaoyanmaTextfield.text;
    
    NSString *msg = nil;
    do{
        if([companyName length] == 0)
        {
            msg = @"请输入企业名称";
            break;
        }
        if([identifyCode length] != 6)
        {
            msg = @"请输入正确的验证码";
            break;
        }
        if([_province length] == 0)
        {
            msg = @"请选择行政区域";
            break;
        }
        if([address length] == 0)
        {
            msg = @"请输入地址";
            break;
        }
        if([pwd length] == 0)
        {
            msg = @"请输入密码";
            break;
        }
        if(![pwd isEqualToString:pwd1])
        {
            msg = @"两次输入的密码不一致";
            break;
        }
    }while(0);
    
    if(msg)
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                         message:msg
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *mobile = _cellphoneTextfield.text;
    if(![Utilities IsValidMobeilTel:[mobile UTF8String]])
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"请输入正确的手机号！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(_http == nil)
        _http = [[WebClient alloc] initWithDelegate:self];
    
    _http._httpMethod = @"POST";
    _http._method = @"/userregister";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobile forKey:@"telephone"];
    [params setObject:companyName forKey:@"company"];
    [params setObject:_province forKey:@"province"];
    [params setObject:_city forKey:@"city"];
    [params setObject:_area forKey:@"zone"];
    [params setObject:address forKey:@"address"];
    [params setObject:pwd forKey:@"password"];
    [params setObject:identifyCode forKey:@"identifyCode"];
    
    [params setObject:@"CN" forKey:@"countrycode"];
    _http._requestParam = params;
    
    
    IMP_BLOCK_SELF(SignupViewController);
    
    btn.enabled = NO;
    
    [_http requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        btn.enabled = YES;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                if(code == 200)
                {
                    User *u = [[User alloc] initWithDicionary:v];
                    [UserDefaultsKV saveUser:u];
                    
                    [block_self successRegDone];
                }
                else
                {
                    NSString *message = [v objectForKey:@"msg"];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
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
        
        btn.enabled = YES;
    }];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.cancelButtonIndex == buttonIndex) {
        
        
        InvitationCodeViewCotroller *ctrl = [[InvitationCodeViewCotroller alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
}


- (void) startTimer{
    
    _registerNumberBtn.enabled = NO;
    _registerNumberBtn.alpha = 0.5;
    _timerLabel.text = @"60秒";
    secondsCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                              target:self
                                            selector:@selector(timeCount)
                                            userInfo:nil
                                             repeats:NO];
}

- (void) timeCount{
    
    secondsCount--;
    
    [self performSelectorOnMainThread:@selector(showWait) withObject:nil waitUntilDone:NO];
    
    
    
    if(secondsCount <= 0)
    {
        _registerNumberBtn.enabled = YES;
        _registerNumberBtn.alpha = 1;
        _timerLabel.text = @"60秒";
        
        if([_timer isValid])
            [_timer invalidate];
        _timer = nil;
    }
    else
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timeCount)
                                                userInfo:nil
                                                 repeats:NO];
    }
}

- (void) showWait{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       //NSLog(@"%d", secondsCount);
                       //[btnVerify setTitle:[NSString stringWithFormat:@"%d秒后重发", secondsCount] forState:UIControlStateNormal];
                       //[btnVerify setNeedsDisplay];
                       if(secondsCount == 0)
                       {
                           _timerLabel.text = @"60秒";
                       }
                       else
                       {
                           _timerLabel.text = [NSString stringWithFormat:@"%d秒", secondsCount];
                       }
                   });
    
    
}


- (void) stopTimer{
    
    if(_timer)
    {
        if([_timer isValid])
            [_timer invalidate];
        _timer = nil;
    }
}


- (void) registerNumberAction:(UIButton*)btn{
 
    NSString *mobile = _cellphoneTextfield.text;
    if(![Utilities IsValidMobeilTel:[mobile UTF8String]])
    {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                         message:@"请输入正确的手机号！"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(_httpGetCode == nil)
        _httpGetCode = [[WebClient alloc] initWithDelegate:self];
    
    _httpGetCode._httpMethod = @"GET";
    _httpGetCode._method = @"/sendidentifycode";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:mobile forKey:@"telephoneNumber"];
    [params setObject:@"CN" forKey:@"countrycode"];
    _httpGetCode._requestParam = params;
    
    
    IMP_BLOCK_SELF(SignupViewController);
    
    btn.enabled = NO;
    
    [_httpGetCode requestWithSusessBlock:^(id lParam, id rParam) {
        
        NSString *response = lParam;
        //NSLog(@"%@", response);
        
        btn.enabled = YES;
        
        SBJson4ValueBlock block = ^(id v, BOOL *stop) {
            
            if([v isKindOfClass:[NSDictionary class]])
            {
                int code = [[v objectForKey:@"code"] intValue];
                if(code == 200)
                {
                    [block_self showSmsMessage];
                }
                else
                {
                    NSString *message = [v objectForKey:@"msg"];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
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
        
        btn.enabled = YES;
    }];
}


- (void) showSmsMessage{
    
    [self startTimer];
    
    [[WaitDialog sharedAlertDialog] setTitle:@"验证码已发送"];
    [[WaitDialog sharedAlertDialog] animateShow];
}

- (void) countrySelectAction:(id)sender{
    
}

- (void) regionSelectAction:(id)sender{
    NSLog(@"enter the method. regionSelectAction");
    areaPick = [[AreaPickView alloc]initWithFrame:CGRectMake(0, 0, 600, 300)];
    areaPick.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    areaPick.delegate = self;
    areaPick.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:areaPick];
}

- (void) updateAreaInfo {
    NSLog(@"enter the method. updateAreaInfo");
    if (areaPick) {
        NSString *province = areaPick.provinceBtn.titleLabel.text;
        NSString *city = areaPick.cityBtn.titleLabel.text;
        NSString *district = areaPick.districtBtn.titleLabel.text;
        
        self._province = province;
        self._city = city;
        self._area = district;
        
        NSString *baseString = @"所在地区：";
        NSString *buttonTitle = [[[baseString stringByAppendingString:province] stringByAppendingString:city] stringByAppendingString:district];
        [_regionBtn setTitle: buttonTitle forState:UIControlStateNormal];
        
        [areaPick removeFromSuperview];
    }
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
