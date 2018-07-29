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
#import "Utilities.h"
#import "KVNProgress.h"
#import "DataCenter.h"

#define T7DaySecs (7*24*3600)


@interface InvitationCodeViewCotroller () {
    //输入部分
    UIView *_inputPannel;
    UITextField *_invitationCode;
}
@end

@implementation InvitationCodeViewCotroller
@synthesize showBack;

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
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    if(showBack)
    {
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
    }
    
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
    
    _inputPannel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 180)];
    [self.view addSubview:_inputPannel];
    _inputPannel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    ///在这里编写登录输入内容框 _inputPannel
    int top = 10;
    int left = -10;
    int w = CGRectGetWidth(_inputPannel.frame) - 30;
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


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (void)  textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) okAction:(UIButton*) btn {
    
    NSString *code = _invitationCode.text;
    
    if([code length] < 5)
    {
        [Utilities showMessage:@"请输入合法的序列号" ctrl:self];
    }
    
    User *u = [UserDefaultsKV getUser];

    if(_autoClient == nil)
        _autoClient = [[WebClient alloc] initWithDelegate:self];
    
    _autoClient._httpMethod = @"GET";
    _autoClient._method = @"/validinvitationcode";
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:code forKey:@"invitationCode"];
    [params setObject:u._userId forKey:@"userID"];
    
    _autoClient._requestParam = params;
    
    btn.enabled = NO;
    
    IMP_BLOCK_SELF(InvitationCodeViewCotroller);
    
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
    [UserDefaultsKV saveUser:u];
    
    if([u isActive])
    {
        [[DataCenter defaultDataCenter] syncDriversWithServer];
        [[AppDelegate shareAppDelegate] enterApp];
    }
}


- (void) didLogin {
    
    [[AppDelegate shareAppDelegate] enterApp];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
