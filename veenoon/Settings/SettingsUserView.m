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

@interface SettingsUserView () {
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
        
        int left = 150;
        int top = 50;
        int sec2Top = top+250;
        
        _content = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_content];
        _content.contentSize = CGSizeMake(frame.size.width, frame.size.height+10);
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, 20)];
        titleL2.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL2];
        titleL2.font = [UIFont systemFontOfSize:16];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"账户信息";
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(left, sec2Top, 100, 20)];
        titleL3.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL3];
        titleL3.font = [UIFont systemFontOfSize:16];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"安全设置";
        
        int blockLx = left+160;
        int fieldLx = blockLx + 100;
        
        UILabel* titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top,
                                                                     80, 20)];
        titleL4.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL4];
        titleL4.font = [UIFont boldSystemFontOfSize:16];
        titleL4.textColor  = [UIColor whiteColor];
        titleL4.text = @"企业";
        
        companyField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                     top-10,
                                                                     SCREEN_WIDTH-fieldLx-150, 40)];
        companyField.delegate = self;
        companyField.textAlignment = NSTextAlignmentLeft;
        companyField.returnKeyType = UIReturnKeyDone;
        companyField.placeholder = @"";
        companyField.backgroundColor = [UIColor clearColor];
        companyField.textColor = RGB(70, 219, 254);
        companyField.borderStyle = UITextBorderStyleNone;
        [_content addSubview:companyField];
        
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx, top+26,
                                                                   SCREEN_WIDTH-fieldLx-150, 1)];
        line1.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line1];
        
        top+=40;
        top+=10;
        
        UILabel* titleL5 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top,
                                                                     80, 20)];
        titleL5.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL5];
        titleL5.font = [UIFont boldSystemFontOfSize:16];
        titleL5.textColor  = [UIColor whiteColor];
        titleL5.text = @"地址";
        
        _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _regionBtn.frame = CGRectMake(fieldLx, top-10, SCREEN_WIDTH-fieldLx-150, 40);
        _regionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_regionBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
        _regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_content addSubview:_regionBtn];
        [_regionBtn addTarget:self
                       action:@selector(areaPickAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top+26,
                                                                   SCREEN_WIDTH-fieldLx-150,
                                                                   1)];
        line2.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line2];
        
        top+=40;
        top+=10;
        
        addressField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                     top-10,
                                                                     SCREEN_WIDTH-fieldLx-150,
                                                                     40)];
        addressField.delegate = self;
        addressField.textAlignment = NSTextAlignmentLeft;
        addressField.returnKeyType = UIReturnKeyDone;
        addressField.placeholder = @"";
        addressField.backgroundColor = [UIColor clearColor];
        addressField.textColor = RGB(70, 219, 254);
        addressField.borderStyle = UITextBorderStyleNone;
        [_content addSubview:addressField];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top+26,
                                                                   SCREEN_WIDTH-fieldLx-150,
                                                                   1)];
        line3.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line3];


        top+=40;
        top+=10;
        
        UILabel* titleL6 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     top,
                                                                     80, 20)];
        titleL6.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL6];
        titleL6.font = [UIFont boldSystemFontOfSize:16];
        titleL6.textColor  = [UIColor whiteColor];
        titleL6.text = @"注册手机";
        
        
        telphoneField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      top-10,
                                                                      SCREEN_WIDTH-fieldLx-150,
                                                                      40)];
        telphoneField.delegate = self;
        telphoneField.textAlignment = NSTextAlignmentLeft;
        telphoneField.returnKeyType = UIReturnKeyDone;
        telphoneField.placeholder = @"";
        telphoneField.backgroundColor = [UIColor clearColor];
        telphoneField.textColor = RGB(70, 219, 254);
        telphoneField.borderStyle = UITextBorderStyleNone;
        telphoneField.keyboardType = UIKeyboardTypePhonePad;
        [_content addSubview:telphoneField];
        
        UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   top+26,
                                                                   SCREEN_WIDTH-fieldLx-150, 1)];
        line4.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line4];
        

 //////////////////////////////////
        
        UILabel* titleL7 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top,
                                                                     80, 20)];
        titleL7.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL7];
        titleL7.font = [UIFont boldSystemFontOfSize:16];
        titleL7.textColor  = [UIColor whiteColor];
        titleL7.text = @"更换手机";
        
        againTelphone = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top-10,
                                                                      SCREEN_WIDTH-fieldLx-150-120,
                                                                      40)];
        againTelphone.delegate = self;
        againTelphone.textAlignment = NSTextAlignmentLeft;
        againTelphone.returnKeyType = UIReturnKeyDone;
        againTelphone.placeholder = @"";
        againTelphone.backgroundColor = [UIColor clearColor];
        againTelphone.textColor = RGB(70, 219, 254);
        againTelphone.borderStyle = UITextBorderStyleNone;
        againTelphone.keyboardType = UIKeyboardTypePhonePad;
        [_content addSubview:againTelphone];
        
        UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top+26,
                                                                   SCREEN_WIDTH-fieldLx-150-120,
                                                                   1)];
        line5.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line5];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(CGRectGetMaxX(line5.frame)+20,
                                       sec2Top-10,
                                       100,
                                       40);
        [_content addSubview:registerBtn];
        [registerBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGB(70, 219, 254) forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGB(70, 219, 254) forState:UIControlStateHighlighted];
        registerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [registerBtn addTarget:self
                        action:@selector(registerAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line5.frame)+20,
                                                                   sec2Top+26,
                                                                   100, 1)];
        line7.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line7];

        
        sec2Top+=40;
        sec2Top+=10;
        
        messageCodeField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                         sec2Top-10,
                                                                         SCREEN_WIDTH-fieldLx-150-120,
                                                                         40)];
        messageCodeField.delegate = self;
        messageCodeField.textAlignment = NSTextAlignmentLeft;
        messageCodeField.returnKeyType = UIReturnKeyDone;
        messageCodeField.placeholder = @"";
        messageCodeField.backgroundColor = [UIColor clearColor];
        messageCodeField.textColor = [UIColor whiteColor];
        messageCodeField.borderStyle = UITextBorderStyleNone;
        messageCodeField.keyboardType = UIKeyboardTypeNumberPad;
        [_content addSubview:messageCodeField];
        
        
        UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top+26,
                                                                   SCREEN_WIDTH-fieldLx-150-120,
                                                                   1)];
        line6.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line6];
        
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line6.frame)+20,
                                                                sec2Top-10,
                                                                100, 40)];
        _timerLabel.text = @"180秒 有效";
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.textColor = RGB(70, 219, 254);
        _timerLabel.font = [UIFont systemFontOfSize:16];
        [_content addSubview:_timerLabel];

        
        UILabel *line10 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line6.frame)+20,
                                                                    sec2Top+26,
                                                                    100, 1)];
        line10.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line10];
        
        
        sec2Top+=40;
        sec2Top+=10;
        
        UILabel* titleL8 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top,
                                                                     80, 20)];
        titleL8.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL8];
        titleL8.font = [UIFont boldSystemFontOfSize:16];
        titleL8.textColor  = [UIColor whiteColor];
        titleL8.text = @"更改密码";
        
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top-10,
                                                                      SCREEN_WIDTH-fieldLx-150,
                                                                      40)];
        passwordField.delegate = self;
        passwordField.textAlignment = NSTextAlignmentLeft;
        passwordField.returnKeyType = UIReturnKeyDone;
        passwordField.placeholder = @"";
        passwordField.backgroundColor = [UIColor clearColor];
        passwordField.secureTextEntry = YES;
        passwordField.textColor = RGB(70, 219, 254);
        passwordField.borderStyle = UITextBorderStyleNone;
        [_content addSubview:passwordField];

        
        UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top+26,
                                                                   SCREEN_WIDTH-fieldLx-150,
                                                                   1)];
        line8.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line8];
        

        
        sec2Top+=40;
        sec2Top+=10;
        
        UILabel* titleL9 = [[UILabel alloc] initWithFrame:CGRectMake(blockLx,
                                                                     sec2Top,
                                                                     80, 20)];
        titleL9.backgroundColor = [UIColor clearColor];
        [_content addSubview:titleL9];
        titleL9.font = [UIFont boldSystemFontOfSize:16];
        titleL9.textColor  = [UIColor whiteColor];
        titleL9.text = @"确认密码";
        
        againPassword = [[UITextField alloc] initWithFrame:CGRectMake(fieldLx,
                                                                      sec2Top-10,
                                                                      SCREEN_WIDTH-fieldLx-150,
                                                                      40)];
        againPassword.delegate = self;
        againPassword.textAlignment = NSTextAlignmentLeft;
        againPassword.returnKeyType = UIReturnKeyDone;
        againPassword.placeholder = @"";
        againPassword.backgroundColor = [UIColor clearColor];
        againPassword.textColor = RGB(70, 219, 254);
        againPassword.secureTextEntry = YES;
        againPassword.borderStyle = UITextBorderStyleNone;
        [_content addSubview:againPassword];

        
        

        UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(fieldLx,
                                                                   sec2Top+26,
                                                                   SCREEN_WIDTH-fieldLx-150,
                                                                   1)];
        line9.backgroundColor = WHITE_LINE_COLOR;
        [_content addSubview:line9];
        
        
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

@end
