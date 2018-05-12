//
//  DriverPropertyView.m
//  veenoon
//
//  Created by chen jack on 2018/5/10.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DriverPropertyView.h"
#import "AudioEProcessor.h"
#import "VCameraSettingSet.h"
#import "VTouyingjiSet.h"
#import "EDimmerLight.h"
#import "UIButton+Color.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DriverConnectionsView.h"

@interface DriverPropertyView () <UITextFieldDelegate>
{
    UITextField *ipTextField;
    
    int leftx;
    
    UILabel* _iptitleL;
    UILabel *_connectionL;
    
    UITextField *_comField;
    UIButton *btnConnect;
    
    UIButton *btnSave;
    
    DriverConnectionsView   *_connectionView;
}

@end

@implementation DriverPropertyView
@synthesize _plugDriver;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {

        leftx = 60;
        
        _iptitleL = [[UILabel alloc] initWithFrame:CGRectMake(leftx, 30, 200, 30)];
        _iptitleL.textColor = [UIColor whiteColor];
        _iptitleL.backgroundColor = [UIColor clearColor];
        [self addSubview:_iptitleL];
        _iptitleL.font = [UIFont systemFontOfSize:15];
        _iptitleL.text = @"IP地址";
        
        ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftx,
                                                                    60,
                                                                    200, 30)];
        ipTextField.delegate = self;
        ipTextField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        ipTextField.returnKeyType = UIReturnKeyDone;
        ipTextField.text = @"192.168.1.100";
        ipTextField.textColor = [UIColor blackColor];
        ipTextField.borderStyle = UITextBorderStyleRoundedRect;
        ipTextField.textAlignment = NSTextAlignmentLeft;
        ipTextField.font = [UIFont systemFontOfSize:15];
        ipTextField.keyboardType = UIKeyboardTypeNumberPad;
        ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:ipTextField];
        
        int top = CGRectGetMaxY(ipTextField.frame)+50;
        
        _connectionL = [[UILabel alloc] initWithFrame:CGRectMake(leftx, top, 200, 30)];
        _connectionL.textColor = [UIColor whiteColor];
        _connectionL.backgroundColor = [UIColor clearColor];
        [self addSubview:_connectionL];
        _connectionL.font = [UIFont systemFontOfSize:15];
        _connectionL.text = @"串口连接";
        
        _comField = [[UITextField alloc] initWithFrame:CGRectMake(leftx,
                                                                    top+30,
                                                                    200, 30)];
        _comField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        _comField.returnKeyType = UIReturnKeyDone;
        _comField.text = @"";
        _comField.textColor = [UIColor blackColor];
        _comField.borderStyle = UITextBorderStyleRoundedRect;
        _comField.textAlignment = NSTextAlignmentLeft;
        _comField.font = [UIFont systemFontOfSize:15];
        _comField.keyboardType = UIKeyboardTypeNumberPad;
        _comField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _comField.userInteractionEnabled = NO;
        [self addSubview:_comField];

        btnConnect = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConnect.frame = CGRectMake(CGRectGetMaxX(_comField.frame), top+20, 60, 50);
        [self addSubview:btnConnect];
        [btnConnect setImage:[UIImage imageNamed:@"connect_icon.png"]
                    forState:UIControlStateNormal];
        [btnConnect addTarget:self
                       action:@selector(connectionSet:)
             forControlEvents:UIControlEventTouchUpInside];
        
        top = CGRectGetMaxY(_comField.frame)+60;
        btnSave = [UIButton buttonWithColor:YELLOW_COLOR selColor:nil];
        btnSave.frame = CGRectMake(leftx, top, 70, 40);
        btnSave.layer.cornerRadius = 3;
        btnSave.clipsToBounds = YES;
        [self addSubview:btnSave];
        [btnSave setTitle:@"保存" forState:UIControlStateNormal];
        btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnSave addTarget:self
                    action:@selector(saveCurrentSetting)
          forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void) connectionSet:(UIButton*)sender{
    
    if(_connectionView == nil)
    {
        _connectionView = [[DriverConnectionsView alloc] initWithFrame:self.bounds];
        
    }
    [self addSubview:_connectionView];
    
    _connectionView._plug = _plugDriver;
    [_connectionView showFromPoint:CGPointMake(CGRectGetMaxX(sender.frame),
                                               CGRectGetMidY(sender.frame))];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    //_processor._ipaddress = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) saveCurrentSetting{
    
    _plugDriver._ipaddress = ipTextField.text;

    [_plugDriver uploadDriverIPProperty];

}

- (void) updateConnectionSet{
    
    if(_plugDriver._com)
    {
        _comField.text = _plugDriver._com.name;
    }
}

- (void) recoverSetting{
    
    [_connectionView removeFromSuperview];
    
    if(_plugDriver._ipaddress == nil)
    {
        _iptitleL.alpha = 0.5;
        ipTextField.alpha = 0.5;
        ipTextField.text = @"";
        ipTextField.userInteractionEnabled = NO;
        
        _comField.alpha = 1;
        _connectionL.alpha = 1;
        btnConnect.enabled = YES;
        
        [_plugDriver syncDriverComs];
        
        return;
    }
    else
    {
        _iptitleL.alpha = 1;
        ipTextField.alpha = 1;
        ipTextField.text = @"";
        ipTextField.userInteractionEnabled = YES;
        
        _comField.text = @"";
        _comField.alpha = 0.5;
        _connectionL.alpha = 0.5;
        btnConnect.enabled = NO;
    }
    
    if(_plugDriver._com)
    {
        _comField.text = _plugDriver._com.name;
    }
    
    if(_plugDriver._driver_ip_property)
    {
        ipTextField.text = _plugDriver._ipaddress;
        return;
    }
    
    if(_plugDriver._driver && [_plugDriver._driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(DriverPropertyView);
        
        [KVNProgress show];
        RgsDriverObj *rd = (RgsDriverObj*)_plugDriver._driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverProperties:rd.m_id completion:^(BOOL result, NSArray *properties, NSError *error) {
            if (result) {
                if ([properties count]) {
                    
                    [block_self updateDriverProperty:properties];
                
                }
            }
            else
            {
                [KVNProgress showErrorWithStatus:@"加载失败，请重试"];
            }
        }];
    }
    
    
}

- (void) updateDriverProperty:(NSArray*)properties{
    
    for(RgsPropertyObj *pro in properties)
    {
        if([pro.name isEqualToString:@"IP"])
        {
            _plugDriver._driver_ip_property = pro;
            _plugDriver._ipaddress = pro.value;
        }
    }
    
    _plugDriver._properties = properties;
    ipTextField.text = _plugDriver._ipaddress;
    
    [KVNProgress dismiss];
}

@end
