//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPortDNSViewCtrl.h"
#import "UIButton+Color.h"
#import "EngineerDNSSettingView.h"
#import "EngineerPortSettingView.h"

@interface EngineerPortDNSViewCtrl () {
    UILabel *_portDNSLabel;
    UIButton *_portSettingsBtn;
    UIButton *_dnsSettingsBtn;
    
    EngineerDNSSettingView *_dnsView;
    EngineerPortSettingView *_portView;
}
@end

@implementation EngineerPortDNSViewCtrl
@synthesize _meetingRoomDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, SCREEN_WIDTH-80, 20)];
    _portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_portDNSLabel];
    _portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    _portDNSLabel.textColor  = [UIColor whiteColor];
    _portDNSLabel.text = @"端口设置";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.userInteractionEnabled = YES;
    [self.view addSubview:maskView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [maskView addGestureRecognizer:tapGesture];
    
    _portSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _portSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT - 130, 50, 50);
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateHighlighted];
    [_portSettingsBtn addTarget:self action:@selector(portAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_portSettingsBtn];
    
    _dnsSettingsBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _dnsSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 130, 50, 50);
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateHighlighted];
    [_dnsSettingsBtn addTarget:self action:@selector(dnsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dnsSettingsBtn];
    
    
    
    _portView = [[EngineerPortSettingView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-270)];
    _portView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    //    settingsUserView.delegate = self;
    [self.view addSubview:_portView];
    
    
    _dnsView = [[EngineerDNSSettingView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-270)];
    _dnsView.hidden = YES;
    _dnsView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    //    settingsUserView.delegate = self;
    [self.view addSubview:_dnsView];
}

- (void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    if (_portView && !_portView.isHidden) {
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
    
    if (_dnsView && !_dnsView.isHidden) {
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
            [dic setObject:_dnsView._checkPicker._unitString forKey:@"portLv"];
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
}

- (void) portAction:(id)sender{
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
    
    _portView.hidden = NO;
    _dnsView.hidden = YES;
}
- (void) dnsAction:(id)sender{
    [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_n.png"] forState:UIControlStateNormal];
    [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateNormal];
    
    _portView.hidden = YES;
    _dnsView.hidden = NO;
}
- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
