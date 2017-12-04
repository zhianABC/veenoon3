//
//  EnginnerHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EnginnerHomeViewController.h"
#import "UIButton+Color.h"

@interface EnginnerHomeViewController () {
    UITextField *_userNameField;
    UITextField *_userPwdField;
}

@end

@implementation EnginnerHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    int leftRight = 250;
    int width = SCREEN_WIDTH - leftRight*2;
    int height = width * 2 / 3;
    UIView *_inputPannel = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 150, width, height)];
    [self.view addSubview:_inputPannel];
    _inputPannel.backgroundColor = RGB(0, 89, 118);
    _inputPannel.userInteractionEnabled=YES;
    
    UIImage *roomImage = [UIImage imageNamed:@"engineer_login_icon.png"];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    [_inputPannel addSubview:roomeImageView];
    roomeImageView.frame = CGRectMake(width/2-69, 80, 138, 109);
    roomeImageView.userInteractionEnabled=YES;
    
    UIView *_inputPannel2 = [[UIView alloc] initWithFrame:CGRectMake(leftRight, 100+height, width, 150)];
    [self.view addSubview:_inputPannel2];
    _inputPannel2.backgroundColor = [UIColor whiteColor];
    _inputPannel2.userInteractionEnabled=YES;
    
    UIButton *login = [UIButton buttonWithColor:nil selColor:[UIColor blackColor]];
    login.frame = CGRectMake(_inputPannel2.frame.size.width/2 - 124,_inputPannel2.frame.size.height/2-25,248, 31);
    login.layer.cornerRadius = 5;
    login.layer.borderWidth = 2;
    login.layer.borderColor = [UIColor blackColor].CGColor;
    login.clipsToBounds = YES;
    [_inputPannel2 addSubview:login];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *userImage = [UIImage imageNamed:@"engineer_login_input_n.png"];
    UIImageView *userImageView = [[UIImageView alloc] initWithImage:userImage];
    [_inputPannel addSubview:userImageView];
    userImageView.frame = CGRectMake(_inputPannel.frame.size.width/2 - 124, _inputPannel.frame.size.height-150, 248, 31);
    userImageView.userInteractionEnabled=YES;
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 248, 31)];
    _userNameField.delegate = self;
    _userNameField.returnKeyType = UIReturnKeyDone;
    _userNameField.placeholder = @"";
    _userNameField.backgroundColor = [UIColor clearColor];
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.borderStyle = UITextBorderStyleNone;
    [userImageView addSubview:_userNameField];
    
    //密码输入框 pending....
    UIImage *userImage2 = [UIImage imageNamed:@"engineer_login_input_n.png"];
    UIImageView *userImageView2 = [[UIImageView alloc] initWithImage:userImage2];
    [_inputPannel addSubview:userImageView2];
    userImageView2.frame = CGRectMake(_inputPannel.frame.size.width/2 - 124, _inputPannel.frame.size.height-110, 248, 31);
    userImageView2.userInteractionEnabled=YES;
    
    _userPwdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 248, 31)];
    _userPwdField.delegate = self;
    _userPwdField.returnKeyType = UIReturnKeyDone;
    _userPwdField.backgroundColor = [UIColor clearColor];
    _userPwdField.textColor = [UIColor whiteColor];
    _userPwdField.borderStyle = UITextBorderStyleNone;
    _userPwdField.secureTextEntry = YES;
    [userImageView2 addSubview:_userPwdField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    if(textField == _userNameField) {
        [_userPwdField becomeFirstResponder];
    }
    
    return YES;
}

-(void) loginAction:(id) sender {
    
}
@end
