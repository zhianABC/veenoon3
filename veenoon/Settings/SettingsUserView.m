//
//  SettingUserView.m
//  veenoon
//
//  Created by 安志良 on 2017/11/18.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "SettingsUserView.h"
#import "AreaPickView.h"


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
}

@end

@implementation SettingsUserView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH-80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:20];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"账户与安全";
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(230, 120, SCREEN_WIDTH-230, 20)];
        titleL2.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL2];
        titleL2.font = [UIFont boldSystemFontOfSize:20];
        titleL2.textColor  = [UIColor whiteColor];
        titleL2.text = @"账户信息";
        
        UILabel* titleL3 = [[UILabel alloc] initWithFrame:CGRectMake(230, 320, SCREEN_WIDTH-230, 20)];
        titleL3.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL3];
        titleL3.font = [UIFont boldSystemFontOfSize:20];
        titleL3.textColor  = [UIColor whiteColor];
        titleL3.text = @"安全设置";
        
        int firstGap = 200;
        
        UILabel* titleL4 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120, SCREEN_WIDTH-230-firstGap, 20)];
        titleL4.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL4];
        titleL4.font = [UIFont boldSystemFontOfSize:16];
        titleL4.textColor  = RGB(70, 219, 254);
        titleL4.text = @"企业";
        
        int heightGap = 40;
        
        UILabel* titleL5 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120+heightGap, SCREEN_WIDTH-230-firstGap, 20)];
        titleL5.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL5];
        titleL5.font = [UIFont boldSystemFontOfSize:16];
        titleL5.textColor  = RGB(70, 219, 254);
        titleL5.text = @"地址";
        
        UILabel* titleL6 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120+heightGap*3, SCREEN_WIDTH-230-firstGap, 20)];
        titleL6.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL6];
        titleL6.font = [UIFont boldSystemFontOfSize:16];
        titleL6.textColor  = RGB(70, 219, 254);
        titleL6.text = @"注册手机";
        
        UILabel* titleL7 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120+heightGap*5, SCREEN_WIDTH-230-firstGap, 20)];
        titleL7.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL7];
        titleL7.font = [UIFont boldSystemFontOfSize:16];
        titleL7.textColor  = RGB(70, 219, 254);
        titleL7.text = @"更换手机";
        
        
        UILabel* titleL8 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120+heightGap*7, SCREEN_WIDTH-230-firstGap, 20)];
        titleL8.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL8];
        titleL8.font = [UIFont boldSystemFontOfSize:16];
        titleL8.textColor  = RGB(70, 219, 254);
        titleL8.text = @"更改密码";
        
        UILabel* titleL9 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap, 120+heightGap*8, SCREEN_WIDTH-230-firstGap, 20)];
        titleL9.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL9];
        titleL9.font = [UIFont boldSystemFontOfSize:16];
        titleL9.textColor  = RGB(70, 219, 254);
        titleL9.text = @"确认密码";
        
        int secondGap =100;
        companyField = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40)];
        companyField.delegate = self;
        companyField.textAlignment = NSTextAlignmentLeft;
        companyField.returnKeyType = UIReturnKeyDone;
        companyField.placeholder = @"";
        companyField.backgroundColor = [UIColor clearColor];
        companyField.textColor = [UIColor whiteColor];
        companyField.borderStyle = UITextBorderStyleNone;
        [self addSubview:companyField];
        
        
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line1.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line1];
        
        _regionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _regionBtn.frame = CGRectMake(230+firstGap+secondGap, 120+heightGap*3/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40);
        _regionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_regionBtn setTitleColor:RGB(109, 210, 244) forState:UIControlStateNormal];
        _regionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:_regionBtn];
        [_regionBtn addTarget:self
                       action:@selector(areaPickAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*3/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line2.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line2];
        
        addressField = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*5/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40)];
        addressField.delegate = self;
        addressField.textAlignment = NSTextAlignmentLeft;
        addressField.returnKeyType = UIReturnKeyDone;
        addressField.placeholder = @"";
        addressField.backgroundColor = [UIColor clearColor];
        addressField.textColor = [UIColor whiteColor];
        addressField.borderStyle = UITextBorderStyleNone;
        [self addSubview:addressField];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*5/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line3.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line3];
        
        telphoneField = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*7/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40)];
        telphoneField.delegate = self;
        telphoneField.textAlignment = NSTextAlignmentLeft;
        telphoneField.returnKeyType = UIReturnKeyDone;
        telphoneField.placeholder = @"";
        telphoneField.backgroundColor = [UIColor clearColor];
        telphoneField.textColor = [UIColor whiteColor];
        telphoneField.borderStyle = UITextBorderStyleNone;
        [self addSubview:telphoneField];
        
        UILabel *line4 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*7/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line4.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line4];
        
        againTelphone = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*11/2-35, SCREEN_WIDTH-230-firstGap*2-250, 40)];
        againTelphone.delegate = self;
        againTelphone.textAlignment = NSTextAlignmentLeft;
        againTelphone.returnKeyType = UIReturnKeyDone;
        againTelphone.placeholder = @"";
        againTelphone.backgroundColor = [UIColor clearColor];
        againTelphone.textColor = [UIColor whiteColor];
        againTelphone.borderStyle = UITextBorderStyleNone;
        [self addSubview:againTelphone];
        
        UILabel *line5 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*11/2+1, SCREEN_WIDTH-230-firstGap*2-250, 1)];
        line5.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line5];
        
        UILabel *line6 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap+325, 120+heightGap*11/2+1, SCREEN_WIDTH-230-firstGap*2-375, 1)];
        line6.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line6];
        
        registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtn.frame = CGRectMake(230+firstGap+secondGap+325, 120+heightGap*11/2-40, SCREEN_WIDTH-230-firstGap*2-375, 40);
        [self addSubview:registerBtn];
        [registerBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [registerBtn addTarget:self
                      action:@selector(registerAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        messageCodeField = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*13/2-35, SCREEN_WIDTH-230-firstGap*2-250, 40)];
        messageCodeField.delegate = self;
        messageCodeField.textAlignment = NSTextAlignmentLeft;
        messageCodeField.returnKeyType = UIReturnKeyDone;
        messageCodeField.placeholder = @"";
        messageCodeField.backgroundColor = [UIColor clearColor];
        messageCodeField.textColor = [UIColor whiteColor];
        messageCodeField.borderStyle = UITextBorderStyleNone;
        [self addSubview:messageCodeField];
        
        UILabel *line7 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*13/2+1, SCREEN_WIDTH-230-firstGap*2-250, 1)];
        line7.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line7];
        
        UILabel *line8 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap+325, 120+heightGap*13/2+1, SCREEN_WIDTH-230-firstGap*2-375, 1)];
        line8.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line8];
        
        passwordField = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*15/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40)];
        passwordField.delegate = self;
        passwordField.textAlignment = NSTextAlignmentLeft;
        passwordField.returnKeyType = UIReturnKeyDone;
        passwordField.placeholder = @"";
        passwordField.backgroundColor = [UIColor clearColor];
        passwordField.secureTextEntry = YES;
        passwordField.textColor = [UIColor whiteColor];
        passwordField.borderStyle = UITextBorderStyleNone;
        [self addSubview:passwordField];
        
        UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*15/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line9.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line9];
        
        againPassword = [[UITextField alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*17/2-35, SCREEN_WIDTH-230-firstGap*2-50, 40)];
        againPassword.delegate = self;
        againPassword.textAlignment = NSTextAlignmentLeft;
        againPassword.returnKeyType = UIReturnKeyDone;
        againPassword.placeholder = @"";
        againPassword.backgroundColor = [UIColor clearColor];
        againPassword.textColor = [UIColor whiteColor];
        againPassword.secureTextEntry = YES;
        againPassword.borderStyle = UITextBorderStyleNone;
        [self addSubview:againPassword];
        
        UILabel *line10 = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap, 120+heightGap*17/2+1, SCREEN_WIDTH-230-firstGap*2-50, 1)];
        line10.backgroundColor = RGB(70, 219, 254);
        [self addSubview:line10];
        
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(230+firstGap+secondGap+325, 120+heightGap*13/2-35, SCREEN_WIDTH-230-firstGap*2-375, 40)];
        _timerLabel.text = @"180s 有效";
        _timerLabel.textAlignment = NSTextAlignmentCenter;
        _timerLabel.textColor = RGB(255, 180, 0);
        _timerLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:_timerLabel];
    }
    return self;
}

- (void) areaPickAction:(id)sender{
    areaPick = [[AreaPickView alloc]initWithFrame:CGRectMake(0, 0, 600, 300)];
    areaPick.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    areaPick.delegate = self;
    areaPick.backgroundColor = [UIColor whiteColor];
    [self addSubview:areaPick];
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
    
    
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
