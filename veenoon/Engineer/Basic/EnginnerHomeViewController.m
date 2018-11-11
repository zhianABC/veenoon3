//
//  EnginnerHomeViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EnginnerHomeViewController.h"
#import "UIButton+Color.h"
#import "EngineerMeetingRoomListViewCtrl.h"
#import "ReaderCodeViewController.h"
#import "WebClient.h"
#import "KVNProgress.h"
#import "SBJson4.h"
#import "NetworkChecker.h"
#import "DataBase.h"
#import "MeetingRoom.h"
#import "UserDefaultsKV.h"
#import "Utilities.h"

#define T10Days  (10*24*60*60)

@interface EnginnerHomeViewController () <ReaderCodeDelegate> {
    UITextField *_userNameField;
    UITextField *_userPwdField;
    
    UIButton *_flashBtn;
    UIImageView *_scanLineImageView;
    BOOL _is_Animation;
    UIImageView* shoot_image;
    
    UIView *_inputPannel;
    
    WebClient *_client;
}
@property (nonatomic, strong) ReaderCodeViewController *reader_;
@property (nonatomic, strong) NSString *barcode_;

@end

@implementation EnginnerHomeViewController
@synthesize reader_;
@synthesize barcode_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UIView *_topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topBar.backgroundColor = LOGIN_BLACK_COLOR;
    [self.view addSubview:_topBar];
    
    UILabel *centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleLabel.textColor = [UIColor whiteColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    centerTitleLabel.text = @"工程师登录";
    centerTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_topBar addSubview:centerTitleLabel];
    
    
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    _inputPannel.userInteractionEnabled = YES;
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    UIView *_topBar2 = [[UIView alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, 64)];
    _topBar2.backgroundColor = DARK_GRAY_COLOR;
    [_inputPannel addSubview:_topBar2];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 26+63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(56, 56, 56);
    [_inputPannel addSubview:line];
    
    UIView *_topBar3 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, 64)];
    _topBar3.backgroundColor = DARK_GRAY_COLOR;
    [_inputPannel addSubview:_topBar3];
    
    
    
    _userNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 90-54, SCREEN_WIDTH, 44)];
    _userNameField.delegate = self;
    _userNameField.backgroundColor = [UIColor clearColor];
    _userNameField.returnKeyType = UIReturnKeyNext;
    _userNameField.textColor = [UIColor whiteColor];
    _userNameField.borderStyle = UITextBorderStyleNone;
    _userNameField.textAlignment = NSTextAlignmentCenter;
    _userNameField.font = [UIFont systemFontOfSize:14];
    _userNameField.placeholder=@"ID";
    _userNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_userNameField setValue:PLACE_HOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [_inputPannel addSubview:_userNameField];
    
    
    _userPwdField = [[UITextField alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 44)];
    _userPwdField.delegate = self;
    _userPwdField.backgroundColor = [UIColor clearColor];
    _userPwdField.returnKeyType = UIReturnKeyDone;
    _userPwdField.textColor = [UIColor whiteColor];
    _userPwdField.borderStyle = UITextBorderStyleNone;
    _userPwdField.textAlignment = NSTextAlignmentCenter;
    _userPwdField.placeholder=@"Password";
    _userPwdField.font = [UIFont systemFontOfSize:16];
    _userPwdField.secureTextEntry=YES;
    _userPwdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_userPwdField setValue:PLACE_HOLDER_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [_inputPannel addSubview:_userPwdField];
    
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(SCREEN_WIDTH/2 - 125, 260+128+150, 250, 36);
    signup.layer.cornerRadius = 8;
    signup.layer.borderWidth = 0.5;
    signup.layer.borderColor = [UIColor whiteColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"登录" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:ADMIN_BLACK_COLOR forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [signup addTarget:self
               action:@selector(loginAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(30, 32, 40, 20);
    [backBtn setImage:[UIImage imageNamed:@"left_back_bg.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left_back_bg.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:backBtn];
    
}

- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _userNameField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 70);
    }
    if (textField == _userPwdField) {
        _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 100);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(_userNameField == textField)
    {
        [_userPwdField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    if(_userPwdField == textField)
    {
        [self loginAction:nil];
    }
    
    return YES;
}

- (BOOL) testOfflineLogin{
    
    User *u = [[DataBase sharedDatabaseInstance] queryUser:_userNameField.text];
    
    if (u)
    {
        if([_userNameField.text isEqualToString:u._cellphone] &&
           [_userPwdField.text isEqualToString:u._password])
        {
            if(u.is_engineer)
            {
                [self successLogin];
                return NO;
            }
        }
    }
    
    return YES;
}

- (void) faildGetWifiConnect{
    
    User *u = [[DataBase sharedDatabaseInstance] queryUser:_userNameField.text];
    if (u) {
        if([_userNameField.text isEqualToString:u._cellphone] &&
           [_userPwdField.text isEqualToString:u._password]) {
            
            if(u.is_engineer)
            {
                [self successLogin];
            }
            
        } else {
            
            [Utilities showMessage:@"用户名或密码错误！" ctrl:self];
        }
    } else {
        
        [Utilities showMessage:@"没有离线登录的账号！" ctrl:self];
    }
}

-(void) loginAction:(UIButton*) sender {

    NSString *userName = _userNameField.text;
    NSString *userPwd = _userPwdField.text;
    if ([userName length] < 1) {
        
        [Utilities showMessage:@"请输入登录名！" ctrl:self];
        
        return;
    }
    if ([userPwd length] < 1) {
        
        [Utilities showMessage:@"请输入密码！" ctrl:self];
        
        return;
    }
    
    
    BOOL needConnect = YES;
    id lastEngineerLoginTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEngineerLoginTime"];
    int nowTime = [[NSDate date] timeIntervalSince1970];
    if(lastEngineerLoginTime)
    {
        int span = nowTime - [lastEngineerLoginTime intValue];
        if(span < T10Days)
        {
            needConnect = [self testOfflineLogin];
        }
        
    }
    
    if(!needConnect)
    {
        return;
    }

    
    if([[NetworkChecker sharedNetworkChecker] networkStatus] == NotReachable) {
        //没有网络的情况下
        
        [self faildGetWifiConnect];
        
        //返回
        return;
    }
    
    
    if([_userNameField isFirstResponder])
        [_userNameField resignFirstResponder];
    
    if([_userPwdField isFirstResponder])
        [_userPwdField resignFirstResponder];
    
    
    if(_client == nil)
        _client = [[WebClient alloc] initWithDelegate:self];
    
    _client._httpMethod = @"GET";
    _client._method = @"/userlogin";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userName forKey:@"telephone"];
    [params setObject:userPwd forKey:@"password"];
    
    _client._requestParam = params;
    

    IMP_BLOCK_SELF(EnginnerHomeViewController);
    
    [KVNProgress show];
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
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
        
        [block_self faildGetWifiConnect];
        
        [KVNProgress dismiss];
    }];
}

- (void) processLoginData:(NSDictionary*)data{
    
    User *u = [[User alloc] initWithDicionary:data];
    
    u._password = _userPwdField.text;
    [[DataBase sharedDatabaseInstance] saveUserData:u];
    
    if(u.is_engineer)
    {
        int nowTime = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", nowTime]
                                                  forKey:@"lastEngineerLoginTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self successLogin];
    }
    
}
- (void) successLogin{
    
    [self enterRoomListView];
    
}

- (void) enterRoomListView{
    
    EngineerMeetingRoomListViewCtrl *ctrl = [[EngineerMeetingRoomListViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];

}

@end
