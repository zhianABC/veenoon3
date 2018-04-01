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

@interface EngineerSysSelectViewCtrl ()<UIScrollViewDelegate>{
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
    
    UIView       *_container;
    UIScrollView *_switchContent;
    
    UIButton *_portSettingsBtn;
    UIButton *_dnsSettingsBtn;
}
@end

@implementation EngineerSysSelectViewCtrl
@synthesize _meetingRoomDic;
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
              action:@selector(loginAction:)
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
               action:@selector(signupAction:)
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

- (void) loginAction:(id)sender{
    EngineerToUseTeslariViewCtrl *ctrl = [[EngineerToUseTeslariViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) signupAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

