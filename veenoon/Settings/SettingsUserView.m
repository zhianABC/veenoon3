//
//  SettingUserView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/18.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "SettingsUserView.h"
#import "AreaPickView.h"
#import "UIButton+Color.h"
#import "UserDefaultsKV.h"
#import "AppDelegate.h"
#import "M80AttributedLabel.h"
#import "FQCustomAlert.h"

@interface SettingsUserView ()<M80AttributedLabelDelegate> {
    UIButton *registerBtn;
    UILabel *_timerLabel;
    
    UITextField *companyField;
    UIButton *_regionBtn;
    UITextField *addressField;
    UITextField *telphoneField;
    UITextField *againTelphone;
    UITextField *messageCodeField;
    UITextField *passwordField;
    UITextField *againPassword;
    
    AreaPickView *areaPick;
    
    UIScrollView *_content;
}

@end

@implementation SettingsUserView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        int left = 165;
        int top = 140;
        int sec2Top = top+250;
        
        float righSpace = 180;
        
        _content = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_content];
        _content.contentSize = CGSizeMake(frame.size.width, frame.size.height+10);
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top+5, 100, 30)];
        titleL2.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL2];
        titleL2.font = [UIFont systemFontOfSize:16];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"账户信息";
        
        
        
        int blockLx = left+160;
        int fieldLx = blockLx + 100;
        
        UILabel* titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top+5,
                                                                     80, 30)];
        titleL4.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL4];
        titleL4.font = [UIFont boldSystemFontOfSize:16];
        titleL4.textColor  = [UIColor whiteColor];
        titleL4.text = @"企业";
        
        companyField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                     top,
                                                                     SCREEN_WIDTH-fieldLx-righSpace, 30)];
        companyField.delegate = self;
        companyField.textAlignment = NSTextAlignmentLeft;
        companyField.returnKeyType = UIReturnKeyDone;
        companyField.placeholder = @"请输入企业名称";
        [companyField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        companyField.backgroundColor = [UIColor clearColor];
        companyField.font = [UIFont systemFontOfSize:16];
        companyField.textColor = RGB(70, 219, 254);
        companyField.borderStyle = UITextBorderStyleNone;
        [_content addSubview:companyField];
        
        top = CGRectGetMaxY(companyField.frame);
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx, top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace, 1)];
        line1.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line1];
        
        top = CGRectGetMaxY(line1.frame);
        top+=10;
        
        UILabel* titleL5 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top+5,
                                                                     80, 30)];
        titleL5.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL5];
        titleL5.font = [UIFont boldSystemFontOfSize:16];
        titleL5.textColor  = [UIColor whiteColor];
        titleL5.text = @"地址";
        
        _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _regionBtn.frame = CGRectMake(fieldLx, top, SCREEN_WIDTH-fieldLx-righSpace, 30);
        _regionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_regionBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
        _regionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_content addSubview:_regionBtn];
        [_regionBtn addTarget:self
                       action:@selector(areaPickAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        top = CGRectGetMaxY(_regionBtn.frame);
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace,
                                                                   1)];
        line2.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line2];
        
        top = CGRectGetMaxY(line2.frame);
        top+=10;
        
        addressField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                     top,
                                                                     SCREEN_WIDTH-fieldLx-righSpace,
                                                                     30)];
        addressField.delegate = self;
        addressField.textAlignment = NSTextAlignmentLeft;
        addressField.returnKeyType = UIReturnKeyDone;
        addressField.placeholder = @"请输入地址";
        [addressField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        addressField.backgroundColor = [UIColor clearColor];
        addressField.textColor = RGB(70, 219, 254);
        addressField.borderStyle = UITextBorderStyleNone;
        addressField.font = [UIFont systemFontOfSize:16];
        [_content addSubview:addressField];
        
         top = CGRectGetMaxY(addressField.frame);
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace,
                                                                   1)];
        line3.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line3];

        top = CGRectGetMaxY(line3.frame);
        top+=15;
        
        UILabel* titleL6 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top+5,
                                                                     80, 30)];
        titleL6.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL6];
        titleL6.font = [UIFont boldSystemFontOfSize:16];
        titleL6.textColor  = [UIColor whiteColor];
        titleL6.text = @"注册手机";
        
        
        telphoneField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      top,
                                                                      SCREEN_WIDTH-fieldLx-righSpace,
                                                                      30)];
        telphoneField.delegate = self;
        telphoneField.textAlignment = NSTextAlignmentLeft;
        telphoneField.returnKeyType = UIReturnKeyDone;
        telphoneField.placeholder = @"输入手机号码";
        [telphoneField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        telphoneField.backgroundColor = [UIColor clearColor];
        telphoneField.textColor = RGB(70, 219, 254);
        telphoneField.borderStyle = UITextBorderStyleNone;
        telphoneField.keyboardType = UIKeyboardTypePhonePad;
        telphoneField.font = [UIFont systemFontOfSize:16];
        [_content addSubview:telphoneField];
        
        top = CGRectGetMaxY(telphoneField.frame);
        
        UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace, 1)];
        line4.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line4];
        
        top = CGRectGetMaxY(line4.frame);
        top+=10;

        
        sec2Top = top + 50;
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(left, sec2Top+5, 100, 30)];
        titleL3.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL3];
        titleL3.font = [UIFont systemFontOfSize:16];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"安全设置";
        
 //////////////////////////////////
        
        UILabel* titleL7 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top+5,
                                                                     80, 30)];
        titleL7.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL7];
        titleL7.font = [UIFont boldSystemFontOfSize:16];
        titleL7.textColor  = [UIColor whiteColor];
        titleL7.text = @"更换手机";
        
        
        againTelphone = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top,
                                                                      SCREEN_WIDTH-fieldLx-righSpace-120,
                                                                      30)];
        againTelphone.delegate = self;
        againTelphone.textAlignment = NSTextAlignmentLeft;
        againTelphone.returnKeyType = UIReturnKeyDone;
        againTelphone.placeholder=@"输入手机号码";
        [againTelphone setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        againTelphone.backgroundColor = [UIColor clearColor];
        againTelphone.textColor = RGB(70, 219, 254);
        againTelphone.borderStyle = UITextBorderStyleNone;
        againTelphone.keyboardType = UIKeyboardTypePhonePad;
        againTelphone.font = [UIFont systemFontOfSize:16];
        [_content addSubview:againTelphone];
        
        UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace-120,
                                                                   1)];
        line5.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line5];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(CGRectGetMaxX(line5.frame)+20,
                                       sec2Top,
                                       100,
                                       30);
        [_content addSubview:registerBtn];
        [registerBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGB(70, 219, 254) forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGB(70, 219, 254) forState:UIControlStateHighlighted];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [registerBtn addTarget:self
                        action:@selector(registerAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        sec2Top = CGRectGetMaxY(registerBtn.frame);
        
        line5.frame = CGRectMake(fieldLx,sec2Top,SCREEN_WIDTH-fieldLx-righSpace-120,
                                 1);
      
        UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line5.frame)+20,
                                                                   sec2Top,
                                                                   100, 1)];
        line7.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line7];
        
        sec2Top = CGRectGetMaxY(line7.frame);
        sec2Top+=10;
        
        messageCodeField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                         sec2Top,
                                                                         SCREEN_WIDTH-fieldLx-righSpace-120,
                                                                         30)];
        messageCodeField.delegate = self;
        messageCodeField.textAlignment = NSTextAlignmentLeft;
        messageCodeField.returnKeyType = UIReturnKeyDone;
        messageCodeField.placeholder=@"短信验证码";
        messageCodeField.attributedPlaceholder = [[NSAttributedString alloc]
                                               initWithString:@"验证码"
                                               attributes:@{NSForegroundColorAttributeName:RGB(70, 219, 254)}];
        [messageCodeField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        messageCodeField.backgroundColor = [UIColor clearColor];
        messageCodeField.textColor = [UIColor whiteColor];
        messageCodeField.borderStyle = UITextBorderStyleNone;
        messageCodeField.keyboardType = UIKeyboardTypeNumberPad;
        messageCodeField.font = [UIFont systemFontOfSize:16];
        [_content addSubview:messageCodeField];
        
        
        
        UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   CGRectGetMaxY(messageCodeField.frame),
                                                                   SCREEN_WIDTH-fieldLx-righSpace-120,
                                                                   1)];
        line6.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line6];

        
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line6.frame)+20,
                                                                sec2Top,
                                                                100, 30)];
        _timerLabel.text = @"180秒 有效";
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.textColor = RGB(70, 219, 254);
        _timerLabel.font = [UIFont systemFontOfSize:16];
        [_content addSubview:_timerLabel];

        sec2Top = CGRectGetMaxY(_timerLabel.frame);
        
        UILabel *line10 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line6.frame)+20,
                                                                    sec2Top,
                                                                    100, 1)];
        line10.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line10];
        
        
        sec2Top = CGRectGetMaxY(line10.frame);
        sec2Top+=10;
        
        UILabel* titleL8 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top+5,
                                                                     80, 30)];
        titleL8.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL8];
        titleL8.font = [UIFont boldSystemFontOfSize:16];
        titleL8.textColor  = [UIColor whiteColor];
        titleL8.text = @"更改密码";
        
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top-10,
                                                                      SCREEN_WIDTH-fieldLx-righSpace,
                                                                      40)];
        passwordField.delegate = self;
        passwordField.textAlignment = NSTextAlignmentLeft;
        passwordField.returnKeyType = UIReturnKeyDone;
        passwordField.placeholder = @"请输入6-18位密码";
        [passwordField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        passwordField.backgroundColor = [UIColor clearColor];
        passwordField.secureTextEntry = YES;
        passwordField.textColor = RGB(70, 219, 254);
        passwordField.borderStyle = UITextBorderStyleNone;
        passwordField.font = [UIFont systemFontOfSize:16];
        [_content addSubview:passwordField];

        sec2Top = CGRectGetMaxY(passwordField.frame);
        
        UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace,
                                                                   1)];
        line8.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line8];
        

        sec2Top = CGRectGetMaxY(line8.frame);
        sec2Top+=10;
        
        UILabel* titleL9 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top+5,
                                                                     80, 30)];
        titleL9.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL9];
        titleL9.font = [UIFont boldSystemFontOfSize:16];
        titleL9.textColor  = [UIColor whiteColor];
        titleL9.text = @"确认密码";
        
        againPassword = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top,
                                                                      SCREEN_WIDTH-fieldLx-righSpace,
                                                                      30)];
        againPassword.delegate = self;
        againPassword.textAlignment = NSTextAlignmentLeft;
        againPassword.returnKeyType = UIReturnKeyDone;
        againPassword.placeholder = @"请输入6-18位密码";
        [againPassword setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        againPassword.backgroundColor = [UIColor clearColor];
        againPassword.textColor = RGB(70, 219, 254);
        againPassword.secureTextEntry = YES;
        againPassword.borderStyle = UITextBorderStyleNone;
        againPassword.font = [UIFont systemFontOfSize:16];
        [_content addSubview:againPassword];

        
        sec2Top = CGRectGetMaxY(againPassword.frame);

        UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top,
                                                                   SCREEN_WIDTH-fieldLx-righSpace,
                                                                   1)];
        line9.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line9];
        
        sec2Top = CGRectGetMaxY(line9.frame);
        sec2Top+=10;
        
        
        int gap = 90;
        int w = CGRectGetWidth(_content.frame);
        M80AttributedLabel* rowName = [[M80AttributedLabel alloc] initWithFrame:CGRectMake(fieldLx+gap, sec2Top+10, w+60, 40)];
        rowName.backgroundColor = [UIColor clearColor];
        rowName.font = [UIFont systemFontOfSize:13];
        rowName.lineSpacing = 2.0;
        rowName.paragraphSpacing = 2.0;
        rowName.autoDetectLinks = NO;
        rowName.textAlignment = 0;
        
        rowName.delegate = self;
        
        rowName.textColor = [UIColor whiteColor];
        [_content addSubview:rowName];
        NSString *prex = @"查看 ";
        [rowName appendText:prex];
        NSString *str = @"隐私协议和在线服务系列协议";
        
        [rowName appendText:str];
        [rowName appendText:@""];
        rowName.underLineForLink = NO;
        
        rowName.linkColor = NEW_ER_BUTTON_SD_COLOR;
        [rowName addCustomLink:@"" forRange:NSMakeRange([prex length], [str length])];
        
        
        UIButton *logout = [UIButton buttonWithColor:USER_GRAY_COLOR
                                            selColor:nil];
        logout.frame = CGRectMake(0, self.frame.size.height - 50,
                                  frame.size.width, 50);
        [self addSubview:logout];
        [logout setTitle:@"退出登录" forState:UIControlStateNormal];
        [logout addTarget:self
                   action:@selector(logoutAction:)
         forControlEvents:UIControlEventTouchUpInside];


    }
    return self;
}

- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData{
    NSLog(@"");
    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"privatecy" ofType:@"txt"];
    NSStringEncoding *useEncodeing = nil;
    
    NSString *body = [NSString stringWithContentsOfFile:txtPath usedEncoding:useEncodeing error:nil];
    
    FQCustomAlert *alertView = [[FQCustomAlert alloc]initWithTitleNoImage:@"规则说明" WithContent:body WithSureBtnTitle:@"AAA"];
    [alertView show];
    
}

- (void) logoutAction:(id)sender{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app logout];
}

- (void) areaPickAction:(UIButton*)sender{
    areaPick = [[AreaPickView alloc]initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(sender.frame),
                                                             600,
                                                             300)];
    areaPick.center = CGPointMake(SCREEN_WIDTH/2, areaPick.center.y);
    areaPick.delegate = self;
    areaPick.backgroundColor = [UIColor whiteColor];
    [self addSubview:areaPick];
    
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(0, 0, 60, 40);
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [areaPick addSubview:btnCancel];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnCancel setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [btnCancel addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void) cancelAction:(id)sender{
    
    [areaPick removeFromSuperview];
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

- (void) registerAction:(id)sender{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    int max = CGRectGetMaxY(textField.frame) + 50 + 40;
    
    if(SCREEN_HEIGHT - 64 - max < 432)
    {
        int y = max - SCREEN_HEIGHT + 432 + 64;
        
        _content.contentOffset = CGPointMake(0, y);
    }
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    _content.contentOffset = CGPointMake(0, 0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) fillCacheData{
    
    User *u = [UserDefaultsKV getUser];
    
    if(u)
    {
    companyField.text = u.companyname;
    
    NSString *baseString = @"所在地区：";
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ %@ %@ %@",
                             baseString,
                             u.province,
                             u.city,
                             u.zone];
    
    [_regionBtn setTitle: buttonTitle forState:UIControlStateNormal];
    
    telphoneField.text = u._cellphone;
    
    addressField.text = u.address;
    }
}

@end
