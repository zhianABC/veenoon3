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

@interface EngineerSysSelectViewCtrl ()<EngineerPortSettingViewDelegate, EngineerDNSSettingViewDelegate> {
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
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
    
    UIButton *login = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    login.frame = CGRectMake(SCREEN_WIDTH/2 - 130, SCREEN_HEIGHT/2 - 80, 260, 50);
    login.layer.cornerRadius = 5;
    login.layer.borderWidth = 2;
    login.layer.borderColor = [UIColor whiteColor].CGColor;
    login.clipsToBounds = YES;
    [self.view addSubview:login];
    [login setTitle:@"设置新的系统" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    login.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [login addTarget:self
              action:@selector(loginAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signup = [UIButton buttonWithColor:nil selColor:[UIColor whiteColor]];
    signup.frame = CGRectMake(SCREEN_WIDTH/2 - 130, SCREEN_HEIGHT/2 +20, 260, 50);
    signup.layer.cornerRadius = 5;
    signup.layer.borderWidth = 2;
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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT,
                                                                SCREEN_HEIGHT - 100,
                                                                SCREEN_WIDTH, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"关于TESLSRIA";
    
//    [self.view addSubview:titleL];
    
    UIButton *backBtn = [UIButton buttonWithColor:[UIColor whiteColor] selColor:RGB(242, 148, 20)];
    backBtn.frame = CGRectMake(0, 60, 30, 60);
    [self.view addSubview:backBtn];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchDown];
    
    _portView = [[EngineerPortSettingView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    settingsUserView.delegate = self;
    _portView.delegate = self;
    [self.view addSubview:_portView];
    
    
    _dnsView = [[EngineerDNSSettingView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    settingsUserView.delegate = self;
    _dnsView.delegate = self;
    [self.view addSubview:_dnsView];
    
    
    
}
- (void) dnsViewHandleTapGesture {
    if (_dnsView._selectedRow <= -1) {
        return;
    }
    NSMutableDictionary *dic = [_dnsView._portList objectAtIndex:_dnsView._selectedRow];
    
    if (_dnsView._serialLabel) {
        [_dnsView._serialLabel removeFromSuperview];
    }
    if (_dnsView._devicNameLabel) {
        [_dnsView._devicNameLabel removeFromSuperview];
    }
    if (_dnsView._devicIPLabel) {
        [_dnsView._devicIPLabel removeFromSuperview];
    }
    if (_dnsView._macAddressLabel) {
        [_dnsView._macAddressLabel removeFromSuperview];
    }
    if (_dnsView._portLvPicker) {
        [dic setObject:_dnsView._portLvPicker._unitString forKey:@"portLv"];
        [_dnsView._portLvPicker removeFromSuperview];
    }
    if (_dnsView._checkPicker) {
        [dic setObject:_dnsView._checkPicker._unitString forKey:@"checkPosition"];
        [_dnsView._checkPicker removeFromSuperview];
    }
    if (_dnsView._digitPicker) {
        [dic setObject:_dnsView._digitPicker._unitString forKey:@"digitPosition"];
        [_dnsView._digitPicker removeFromSuperview];
    }
    if (_dnsView._stopPicker) {
        [dic setObject:_dnsView._stopPicker._unitString forKey:@"stopPosition"];
        [_dnsView._stopPicker removeFromSuperview];
    }
    _dnsView._selectedRow = -1;
    _dnsView._previousSelectedRow =-1;
    
    [_dnsView._tableView reloadData];
}
- (void) portViewHandleTapGesture {
    if (_portView._selectedRow <= -1) {
        return;
    }
    NSMutableDictionary *dic = [_portView._portList objectAtIndex:_portView._selectedRow];
    
    if (_portView._checkPicker) {
        [dic setObject:_portView._checkPicker._unitString forKey:@"checkPosition"];
        [_portView._checkPicker removeFromSuperview];
    }
    if (_portView._portPicker) {
        [dic setObject:_portView._portPicker._unitString forKey:@"portNumber"];
        [_portView._portPicker removeFromSuperview];
    }
    if (_portView._portTypePicker) {
        [dic setObject:_portView._portTypePicker._unitString forKey:@"portType"];
        [_portView._portTypePicker removeFromSuperview];
    }
    if (_portView._portLvPicker) {
        [dic setObject:_portView._portLvPicker._unitString forKey:@"portLv"];
        [_portView._portLvPicker removeFromSuperview];
    }
    if (_portView._digitPicker) {
        [dic setObject:_portView._digitPicker._unitString forKey:@"digitPosition"];
        [_portView._digitPicker removeFromSuperview];
    }
    if (_portView._stopPicker) {
        [dic setObject:_portView._stopPicker._unitString forKey:@"stopPosition"];
        [_portView._stopPicker removeFromSuperview];
    }
    _portView._selectedRow = -1;
    _portView._previousSelectedRow =-1;
    
    [_portView._tableView reloadData];
}
- (void) loginAction:(id)sender{
    EngineerToUseTeslariViewCtrl *ctrl = [[EngineerToUseTeslariViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) dnsViewdnsAction {
    CGRect rc = _dnsView.frame;
    rc.origin.x = 0;
    
    [UIView beginAnimations:nil context:nil];
    _dnsView.frame = rc;
    [UIView commitAnimations];
    
    CGRect rc2 = _portView.frame;
    rc2.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    _portView.frame = rc2;
    [UIView commitAnimations];
}
- (void) dnsViewPortAction {
    CGRect rc = _portView.frame;
    rc.origin.x = 0;
    
    [UIView beginAnimations:nil context:nil];
    _portView.frame = rc;
    [UIView commitAnimations];
    
    CGRect rc2 = _dnsView.frame;
    rc2.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    _dnsView.frame = rc2;
    [UIView commitAnimations];
}
- (void) portViewPortAction {
    CGRect rc = _portView.frame;
    rc.origin.x = 0;
    
    [UIView beginAnimations:nil context:nil];
    _portView.frame = rc;
    [UIView commitAnimations];
    
    CGRect rc2 = _dnsView.frame;
    rc2.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    _dnsView.frame = rc2;
    [UIView commitAnimations];
}
- (void) portViewdnsAction {
    CGRect rc = _dnsView.frame;
    rc.origin.x = 0;
    
    [UIView beginAnimations:nil context:nil];
    _dnsView.frame = rc;
    [UIView commitAnimations];
    
    CGRect rc2 = _portView.frame;
    rc2.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    _portView.frame = rc2;
    [UIView commitAnimations];
}
- (void) backAction:(id)sender{
    CGRect rc = _portView.frame;
    rc.origin.x = 0;
    
    [UIView beginAnimations:nil context:nil];
    _portView.frame = rc;
    [UIView commitAnimations];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) signupAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

