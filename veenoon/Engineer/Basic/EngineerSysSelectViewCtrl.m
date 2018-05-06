//
//  WellcomeViewController.m
//  veenoon
//
//  Created by chen jack on 2017/11/14.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerSysSelectViewCtrl.h"
#import "UIButton+Color.h"
#import "EngineerPortSettingView.h"
#import "EngineerDNSSettingView.h"
#import "EngineerToUseTeslariViewCtrl.h"
#import "KVNProgress.h"
#import "DataSync.h"
#import "WaitDialog.h"
#import "EngineerScenarioSettingsViewCtrl.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"

#endif

@interface EngineerSysSelectViewCtrl ()<UIScrollViewDelegate>{
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
    
    UIView       *_container;
    UIScrollView *_switchContent;
    
    UIButton *_portSettingsBtn;
    UIButton *_dnsSettingsBtn;
    
    UIImageView *_aniWaitDialog;
}
@property (nonatomic, strong) NSString *_regulus_user_id;
@property (nonatomic, strong) NSString *_regulus_gateway_id;
@property (nonatomic, strong) NSMutableArray *_sceneDrivers;
@end

@implementation EngineerSysSelectViewCtrl
@synthesize _meetingRoomDic;
@synthesize _regulus_user_id;
@synthesize _regulus_gateway_id;
@synthesize _sceneDrivers;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(1, 138, 182);
    
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *login = [UIButton buttonWithColor:[UIColor whiteColor]
                                       selColor:LINE_COLOR];
    login.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 - 80, 360, 44);
    login.layer.cornerRadius = 8;
    login.layer.borderWidth = 1;
    login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.clipsToBounds = YES;
    [self.view addSubview:login];
    [login setTitle:@"设置新的系统" forState:UIControlStateNormal];
    [login setTitleColor:RGB(1, 138, 182) forState:UIControlStateNormal];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(renewSysAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(SCREEN_WIDTH/2 - 180, SCREEN_HEIGHT/2 +20, 360, 44);
    signup.layer.cornerRadius = 8;
    signup.layer.borderWidth = 1;
    signup.layer.borderColor = [UIColor whiteColor].CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"链接已有系统" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [signup addTarget:self
               action:@selector(linktoSysAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
//                                                                SCREEN_HEIGHT - 100,
//                                                                SCREEN_WIDTH, 20)];
//    titleL.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:titleL];
//    titleL.font = [UIFont systemFontOfSize:16];
//    titleL.textColor  = [UIColor whiteColor];
//    titleL.text = @"关于TESLSRIA";
//
  
    UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 500)];
    [self.view addSubview:touchView];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [touchView addGestureRecognizer:longPress];
    
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH,
                                                          0,
                                                          SCREEN_WIDTH,
                                                          SCREEN_HEIGHT)];
    
    [self.view addSubview:_container];
    _container.backgroundColor = self.view.backgroundColor;
    
    _switchContent = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    SCREEN_WIDTH,
                                                                    SCREEN_HEIGHT)];
    _switchContent.delegate=self;
    [_container addSubview:_switchContent];
    _switchContent.pagingEnabled = YES;
    [_switchContent setContentSize:CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT)];
    
    
    _portView = [[EngineerPortSettingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_switchContent addSubview:_portView];
    
    
    _dnsView = [[EngineerDNSSettingView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_switchContent addSubview:_dnsView];
    
    
    [self containerView];
    
    self._regulus_gateway_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"gateway_id"];
    self._regulus_user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
#if LOGIN_REGULUS
    [KVNProgress show];
    
    
    if(_regulus_gateway_id && _regulus_user_id)
    {
        [self loginCtrlDevice];
    }
    else
    {
        self._regulus_gateway_id = @"RGS_EOC500_01";
        [self regCtrlDevice];
    }
#endif
    
}

- (void) regCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [KVNProgress showWithStatus:@"登录中..."];
    
    [[RegulusSDK sharedRegulusSDK] RequestJoinGateWay:_regulus_gateway_id
                                           completion:^(NSString *user_id, BOOL is_init, NSError * aError) {
        if (aError) {
            
            [KVNProgress showErrorWithStatus:[aError description]];
            
            [DataSync sharedDataSync]._currentReglusLogged = nil;
        }
        else{
            
            block_self._regulus_user_id = user_id;
            //NSLog(@"user_id:%@,gw:%@\n",user_id,_gw_id.text);
            [[NSUserDefaults standardUserDefaults] setObject:@"RGS_EOC500_01" forKey:@"gateway_id"];
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"user_id"];
            
            
            [block_self loginCtrlDevice];
        }
    }];
#endif
    
}

- (void) loginCtrlDevice{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);

    [[RegulusSDK sharedRegulusSDK] Login:self._regulus_user_id
                                   gw_id:_regulus_gateway_id
                                password:@"111111"
                                   level:1 completion:^(BOOL result, NSInteger level, NSError *error) {
        if (result) {
            [block_self update];
        }
        else{
            
            [DataSync sharedDataSync]._currentReglusLogged = nil;
            [KVNProgress showErrorWithStatus:[error description]];
        }
    }];
    
#endif
    
}

- (void) update{
    
    [DataSync sharedDataSync]._currentReglusLogged = @{@"gw_id":_regulus_gateway_id,
                                                       @"user_id":_regulus_user_id
                                                       };
    
    [self checkArea];
    
}

- (void) checkArea{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] GetAreas:^(NSArray *RgsAreaObjs, NSError *error) {
        if (error) {
            
            [KVNProgress showErrorWithStatus:@"连接中控出错!"];
        }
        else
        {
            [block_self checkSceneData:RgsAreaObjs];
        }
    }];
    
#endif
    
}
- (void) checkSceneData:(NSArray*)RgsAreaObjs{
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);
    
    RgsAreaObj *areaObj = nil;
    if([RgsAreaObjs count])
        areaObj = [RgsAreaObjs objectAtIndex:0];
    if(areaObj)
    {
        [[RegulusSDK sharedRegulusSDK] GetDrivers:areaObj.m_id
                                       completion:^(BOOL result, NSArray *drivers, NSError *error) {
                                           
                                           if (error) {
                                               
                                               
                                               [KVNProgress showErrorWithStatus:[error localizedDescription]];
                                           }
                                           else{
                                               [block_self checkSceneDriver:drivers];
                                           }
                                       }];
    }
    else
    {
        [KVNProgress showSuccess];
    }
    
    
#endif
}

- (void) checkSceneDriver:(NSArray*)drivers{
    
    NSString *keymap = @"b836539a-376c-4fae-86d0-d7d580e7a626";
    
    for(RgsDriverObj *dr in drivers)
    {
        NSString *drkey = dr.info.serial;
        if([drkey isEqualToString:keymap])
        {
            [_sceneDrivers addObject:dr];
        }
    }
    
    
    [KVNProgress showSuccess];
}


- (void) containerView{
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [_container addSubview:bottomBar];
    _container.alpha = 0.0;
    
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
                  action:@selector(c_cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(c_okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _portSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _portSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT - 130, 50, 50);
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateHighlighted];
    [_portSettingsBtn addTarget:self action:@selector(portAction:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_portSettingsBtn];
    
    _dnsSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _dnsSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 130, 50, 50);
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateHighlighted];
    [_dnsSettingsBtn addTarget:self action:@selector(dnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [_container addSubview:_dnsSettingsBtn];

}

- (void) c_cancelAction:(id)sender{
    
    CGRect rc = _container.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         _container.alpha = 0;
                     }];
}
- (void) c_okAction:(id)sender{
    CGRect rc = _container.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         _container.alpha = 0;
                     }];
}

- (void) portAction:(id)sender{
    
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    
    [_switchContent setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void) dnsAction:(id)sender{
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateNormal];

    [_switchContent setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}
- (void) longPress:(id)sender{
    
    [self showContainer:nil];
}

- (void) showContainer:(id)sender{
    CGRect rc = _container.frame;
    rc.origin.x = 0;
    
    [UIView animateWithDuration:0.45
                     animations:^{
                         _container.alpha = 1.0;
                         _container.frame = rc;
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) renewSysAction:(UIButton*)sender{
    
#if LOGIN_REGULUS
    
    sender.enabled = NO;
    
    if([DataSync sharedDataSync]._currentReglusLogged)
    {
        
        //test
        [self setNewProject];
        
        /*
        IMP_BLOCK_SELF(EngineerSysSelectViewCtrl);

        [[RegulusSDK sharedRegulusSDK] NewProject:@"Veenoon" completion:^(BOOL result, NSError *error) {
            
            sender.enabled = YES;
            
            if(result)
            {
                [block_self setNewProject];
            }
            else
            {
                NSLog(@"%@", [error description]);
            }
        }];
         */

    }
    else
    {
        [KVNProgress showErrorWithStatus:@"未登录"];
        
        sender.enabled = YES;
    }
    
#else
    [self setNewProject];
#endif
    
}



- (void) setNewProject{
    
    EngineerToUseTeslariViewCtrl *ctrl = [[EngineerToUseTeslariViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) linktoSysAction:(id)sender{
    
    if([_sceneDrivers count])
    {
        EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else
    {
        [KVNProgress showWithStatus:@"您还没有创建场景!"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //NSLog(@"pageHeight = %f", pageHeight);
    int _pageIndex = scrollView.contentOffset.x / pageWidth;
    
    if(_pageIndex == 0) {
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
        
    }  else{
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateNormal];
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

