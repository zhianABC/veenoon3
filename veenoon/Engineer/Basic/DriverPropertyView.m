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

@interface DriverPropertyView () <UITextFieldDelegate>
{
    UITextField *ipTextField;
    
    int leftx;
    
    UILabel* _iptitleL;
    UILabel *_connectionL;
    
    UITextField *_comField;
    UIButton *btnConnect;
    
    UIButton *btnSave;
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
        
        top = CGRectGetMaxY(_comField.frame)+60;
        btnSave = [UIButton buttonWithColor:YELLOW_COLOR selColor:nil];
        btnSave.frame = CGRectMake(leftx, top, 70, 40);
        btnSave.layer.cornerRadius = 3;
        btnSave.clipsToBounds = YES;
        [self addSubview:btnSave];
        [btnSave setTitle:@"保存" forState:UIControlStateNormal];
        btnSave.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return self;
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

}

- (void) recoverSetting{
    
    ipTextField.text = _plugDriver._ipaddress;
}

@end
