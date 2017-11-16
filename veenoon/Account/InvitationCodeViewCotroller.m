//
//  LoginViewController.m
//  CMAForiPad
//
//  Created by jack on 12/7/14.
//  Copyright (c) 2014 jack. All rights reserved.
//

#import "InvitationCodeViewCotroller.h"
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


@interface InvitationCodeViewCotroller () {
    //输入部分
    UIView *_inputPannel;
    UITextField *_invitationCode;
}
@end

@implementation InvitationCodeViewCotroller

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
    titleL.text = @"请输入官方授权的序列号";
   
    ///
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 180)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = 10;
    int w = CGRectGetWidth(_inputPannel.frame);
    UILabel *tL = [[UILabel alloc] initWithFrame:CGRectMake(left, top, w, 50)];
    tL.text = @"注册号";
    tL.textColor = RGB(70, 219, 254);
    tL.font = [UIFont boldSystemFontOfSize:18];
    [_inputPannel addSubview:tL];
    
    ///手机号输入框 pending....
    _invitationCode = [[UITextField alloc] initWithFrame:CGRectMake(left + 80, top+10, w-50, 30)];
    _invitationCode.delegate = self;
    _invitationCode.layer.cornerRadius = 5;
    _invitationCode.layer.masksToBounds = YES;
    _invitationCode.textAlignment = NSTextAlignmentCenter;
    _invitationCode.returnKeyType = UIReturnKeyDone;
    _invitationCode.placeholder = @"";
    _invitationCode.backgroundColor = [UIColor whiteColor];
    _invitationCode.textColor = RGB(1, 138, 182);
    _invitationCode.borderStyle = UITextBorderStyleNone;
    [_inputPannel addSubview:_invitationCode];
}

- (void) cancelAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) okAction:(UIButton*) btn {

    if(_autoClient == nil)
        _autoClient = [[WebClient alloc] initWithDelegate:self];
    
    _autoClient._httpMethod = @"GET";
    _autoClient._method = NEW_API_LOGIN;
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    _autoClient._requestParam = params;
    
    IMP_BLOCK_SELF(InvitationCodeViewCotroller);
    
    // temp login.
    [block_self didLogin];
    
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
                    u._authtoken = token;
                    
                    [UserDefaultsKV saveUser:u];
                    
                    [block_self didLogin];
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
    
    
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) enterAdminMode{
    
    
}

- (void) didLogin {
    
    [[AppDelegate shareAppDelegate] enterApp];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
