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


@interface SignupViewController () <AreaPickViewDelegate>{
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
}
@end

@implementation SignupViewController

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
    titleL.text = @"创建您的 TESLARIA 账户";
    
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
    
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+50);
    
    int top = 10;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame);
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 80, 50)];
    tL.text = @"国家/地区";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    _countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _countryBtn.frame = CGRectMake(left+120, top, w-80, 50);
    [_countryBtn setTitle:@"中国" forState:UIControlStateNormal];
    _countryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _countryBtn.titleLabel.textColor = [UIColor redColor];
    _countryBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_countryBtn];
    [_countryBtn addTarget:self
              action:@selector(countrySelectAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *rightArraw = [[UIImageView alloc] initWithFrame:CGRectMake(left + 280 + 100, top+18, 8, 14)];
    [_inputPannel addSubview:rightArraw];
    rightArraw.userInteractionEnabled = YES;
    rightArraw.image = [UIImage imageNamed:@"login_right_arraw.png"];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(left, top +50, w, 1)];
    line.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line];
    
    ///手机号输入框 pending....
    _companyName = [[UITextField alloc] initWithFrame:CGRectMake(left, top+55, w-85, 40)];
    _companyName.delegate = self;
    _companyName.returnKeyType = UIReturnKeyDone;
    _companyName.placeholder = @"请输入企业名称";
    _companyName.backgroundColor = [UIColor clearColor];
    _companyName.textColor = [UIColor whiteColor];
    _companyName.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_companyName];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top +96, w, 1)];
    line2.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line2];
    
    _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _regionBtn.frame = CGRectMake(left, top+100, w-80, 40);
    [_regionBtn setTitle:@"所在地区：" forState:UIControlStateNormal];
    _regionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_regionBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
    _regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_regionBtn];
    [_regionBtn addTarget:self
                    action:@selector(regionSelectAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *rightArraw2 = [[UIImageView alloc] initWithFrame:CGRectMake(left + 280 + 100, top+18+90, 8, 14)];
    [_inputPannel addSubview:rightArraw2];
    rightArraw2.userInteractionEnabled = YES;
    rightArraw2.image = [UIImage imageNamed:@"login_right_arraw.png"];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+141, w, 1)];
    line3.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line3];
    
    _addressTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left, top+145, w-85, 40)];
    _addressTextfield.delegate = self;
    _addressTextfield.returnKeyType = UIReturnKeyDone;
    _addressTextfield.placeholder = @"请输入街道／楼宇／单位";
    _addressTextfield.backgroundColor = [UIColor clearColor];
    _addressTextfield.textColor = [UIColor whiteColor];
    _addressTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_addressTextfield];
    
    UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+186, w, 1)];
    line4.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line4];
    
    UILabel *tL2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+190, 80, 40)];
    tL2.text = @"+86";
    tL2.textColor = RGB(70, 219, 254);
    tL2.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL2];
    
    _cellphoneTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+190, 240, 40)];
    _cellphoneTextfield.delegate = self;
    _cellphoneTextfield.textAlignment = NSTextAlignmentLeft;
    _cellphoneTextfield.returnKeyType = UIReturnKeyDone;
    _cellphoneTextfield.placeholder = @"";
    _cellphoneTextfield.backgroundColor = [UIColor clearColor];
    _cellphoneTextfield.textColor = [UIColor whiteColor];
    _cellphoneTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_cellphoneTextfield];
    
    UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(left+260, top+190, 1, 40)];
    line5.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line5];
    
    _registerNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerNumberBtn.frame = CGRectMake(left+285, top+190, 100, 40);
    [_registerNumberBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _registerNumberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_registerNumberBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    _registerNumberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_registerNumberBtn];
    [_registerNumberBtn addTarget:self
                    action:@selector(registerNumberAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+231, w, 1)];
    line6.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line6];
    
    UILabel *tL3 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+235, 80, 40)];
    tL3.text = @"校验码";
    tL3.textColor = RGB(70, 219, 254);
    tL3.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL3];
    
    _jiaoyanmaTextfield = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+235, 240, 40)];
    _jiaoyanmaTextfield.delegate = self;
    _jiaoyanmaTextfield.textAlignment = NSTextAlignmentLeft;
    _jiaoyanmaTextfield.returnKeyType = UIReturnKeyDone;
    _jiaoyanmaTextfield.placeholder = @"";
    _jiaoyanmaTextfield.backgroundColor = [UIColor clearColor];
    _jiaoyanmaTextfield.textColor = [UIColor whiteColor];
    _jiaoyanmaTextfield.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_jiaoyanmaTextfield];
    
    UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(left+260, top+235, 1, 40)];
    line7.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line7];
    
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(left+285, top+235, 100, 40)];
    _timerLabel.text = @"180s 有效";
    _timerLabel.textColor = RGB(255, 180, 0);
    _timerLabel.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:_timerLabel];
    
    UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+276, w, 1)];
    line8.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line8];
    
    UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+316, w, 1)];
    line9.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line9];
    
    UILabel *tL4 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+320, 80, 40)];
    tL4.text = @"设置密码";
    tL4.textColor = RGB(70, 219, 254);
    tL4.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL4];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+320, 240, 40)];
    _password.delegate = self;
    _password.textAlignment = NSTextAlignmentLeft;
    _password.returnKeyType = UIReturnKeyDone;
    _password.placeholder = @"请输入6-16位密码";
    _password.backgroundColor = [UIColor clearColor];
    _password.textColor = [UIColor whiteColor];
    _password.borderStyle = UITextBorderStyleNone;
    _password.secureTextEntry = YES;
    [_inputPannel addSubview:_password];
    
    UILabel *line10 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+361, w, 1)];
    line10.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line10];
    
    UILabel *tL5 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+365, 80, 40)];
    tL5.text = @"确认密码";
    tL5.textColor = RGB(70, 219, 254);
    tL5.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL5];
    
    _passwordAgain = [[UITextField alloc] initWithFrame:CGRectMake(left+80, top+365, 240, 40)];
    _passwordAgain.delegate = self;
    _passwordAgain.textAlignment = NSTextAlignmentLeft;
    _passwordAgain.returnKeyType = UIReturnKeyDone;
    _passwordAgain.placeholder = @"请输入6-16位密码";
    _passwordAgain.backgroundColor = [UIColor clearColor];
    _passwordAgain.textColor = [UIColor whiteColor];
    _passwordAgain.borderStyle = UITextBorderStyleNone;
    _passwordAgain.secureTextEntry = YES;
    [_inputPannel addSubview:_passwordAgain];
    
    UILabel *line11 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+406, w, 1)];
    line11.backgroundColor = RGB(70, 219, 254);
    [_inputPannel addSubview:line11];
    
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(left-20, top+480, w+60, 40);
    [loginBtn setTitle:@"* 如果您已经使用过了TESLARIA服务，则应返回以使用该账号登录。*" forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGB(70, 219, 254) forState:UIControlStateNormal];
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_inputPannel addSubview:loginBtn];
    [loginBtn addTarget:self
                    action:@selector(loginBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *tL6 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+506, w, 40)];
//    tL6.text = @"*如果您已经使用过了 TESLARIA 服务， 则应返回以使用该账号登录。 *";
//    tL6.textColor = RGB(70, 219, 254);
//    tL6.font = [UIFont boldSystemFontOfSize:12];
//    [_inputPannel addSubview:tL6];
}
- (void) loginBtnAction:(id) sender {
    LoginViewController *ctrl = [[LoginViewController alloc] init];
    
    [self.navigationController pushViewController:ctrl animated:YES];
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

- (void) okAction:(id)sender{
    NSLog(@"enter the method.");
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@""
                                                     message:@"注册成功，将转入验证注册码界面"
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:@"取消", nil];
    [alert show];
    alert.delegate = self;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.cancelButtonIndex == buttonIndex) {
        InvitationCodeViewCotroller *ctrl = [[InvitationCodeViewCotroller alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void) registerNumberAction:(id)sender{
    NSLog(@"enter the method.");
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
