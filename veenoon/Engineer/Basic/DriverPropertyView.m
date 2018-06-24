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
#import "AppDelegate.h"

@interface ConnectionRowCell: UIView
{
    UILabel *_connectionL;
    UITextField *_conField;
    UIButton *btnConnect;
}
@property (nonatomic, readonly) UIButton *btnConnect;
@property (nonatomic, strong) RgsConnectionObj *_connectObj;
@end

@implementation ConnectionRowCell
@synthesize btnConnect;
@synthesize _connectObj;


- (id) initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        _connectionL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 200, 30)];
        _connectionL.textColor = [UIColor whiteColor];
        _connectionL.backgroundColor = [UIColor clearColor];
        [self addSubview:_connectionL];
        _connectionL.font = [UIFont systemFontOfSize:15];
        _connectionL.text = @"串口号: ";
        
        _conField = [[UITextField alloc] initWithFrame:CGRectMake(80,
                                                                  15,
                                                                  frame.size.width - 140, 30)];
        _conField.backgroundColor = [UIColor clearColor];
        _conField.returnKeyType = UIReturnKeyDone;
        _conField.text = @"";
        _conField.textColor = [UIColor whiteColor];
        _conField.borderStyle = UITextBorderStyleNone;
        _conField.textAlignment = NSTextAlignmentLeft;
        _conField.font = [UIFont systemFontOfSize:15];
        _conField.keyboardType = UIKeyboardTypeNumberPad;
        _conField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _conField.userInteractionEnabled = NO;
        [self addSubview:_conField];
        
        
        
        btnConnect = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConnect.frame = CGRectMake(CGRectGetMaxX(_conField.frame), 5, 60, 50);
        [self addSubview:btnConnect];
        [btnConnect setImage:[UIImage imageNamed:@"connect_icon.png"]
                    forState:UIControlStateNormal];
        
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        line.backgroundColor =  B_GRAY_COLOR;
        [self addSubview:line];
        
    }
    
    return self;
}

- (void) fillComConnection:(RgsConnectionObj *)connect{
    
    _connectionL.text = @"串口号: ";
    self._connectObj = connect;
    
    if(connect)
    {
        IMP_BLOCK_SELF(ConnectionRowCell);
        [connect GetBoundings:^(BOOL result, NSArray *connections, NSError *error) {
            
            [block_self queryConnectionResult:connections];
        }];
    }
}

- (void) fillIRConnection:(RgsConnectionObj *)connect{
    
     self._connectObj = connect;
    
    if(connect)
    {
        _connectionL.text = connect.name;
        
        IMP_BLOCK_SELF(ConnectionRowCell);
        [connect GetBoundings:^(BOOL result, NSArray *connections, NSError *error) {
            
            [block_self queryConnectionResult:connections];
        }];
    }
}

- (void) queryConnectionResult:(NSArray *)connections{
    
    if([connections count])
    {
        RgsConnectionObj *connect = [connections objectAtIndex:0];
        
        _conField.text = [NSString stringWithFormat:@"%d:%@ %@",
                          connect.driver_id,
                          connect.driver_name,
                          connect.name];
    }
    
}

- (void) updateConnection{
    
    if(_connectObj)
    {
    IMP_BLOCK_SELF(ConnectionRowCell);
    [_connectObj GetBoundings:^(BOOL result, NSArray *connections, NSError *error) {
        
        [block_self queryConnectionResult:connections];
    }];
    }
}
    

@end


@interface DriverPropertyView () <UITextFieldDelegate>
{
    UITextField *ipTextField;
    
    int leftx;
    
    UILabel* _iptitleL;
    UIButton *btnSave;
    
    DriverConnectionsView   *_connectionView;
    
    UIView *_connectionTableView;
}
@property (nonatomic, strong) NSMutableArray *_connection_cells;

@end

@implementation DriverPropertyView
@synthesize _plugDriver;
@synthesize _connection_cells;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {

    
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.layer.borderColor = B_GRAY_COLOR.CGColor;
        self.layer.borderWidth = 1;
        
        UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                              0,
                                                                              frame.size.width,
                                                                              44)];
        titleBar.backgroundColor = RGB(0x2b, 0x2b, 0x2c);
        [self addSubview:titleBar];
        
        UILabel* rowL = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                  0,
                                                                  200, 44)];
        rowL.backgroundColor = [UIColor clearColor];
        [titleBar addSubview:rowL];
        rowL.font = [UIFont boldSystemFontOfSize:14];
        rowL.textColor  = [UIColor whiteColor];
        rowL.text = @"设置";
        
        UILabel* rightL = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                  0,
                                                                  frame.size.width-30, 44)];
        rightL.backgroundColor = [UIColor clearColor];
        [titleBar addSubview:rightL];
        rightL.font = [UIFont boldSystemFontOfSize:14];
        rightL.textColor  = [UIColor whiteColor];
        rightL.text = @"保存";
        rightL.textAlignment = NSTextAlignmentRight;

        
        leftx = 30;
        
        int top = 44;
        
        _iptitleL = [[UILabel alloc] initWithFrame:CGRectMake(leftx, top+15, 200, 30)];
        _iptitleL.textColor = [UIColor whiteColor];
        _iptitleL.backgroundColor = [UIColor clearColor];
        [self addSubview:_iptitleL];
        _iptitleL.font = [UIFont systemFontOfSize:15];
        _iptitleL.text = @"IP地址: ";
        
        
        ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftx+80,
                                                                    top+15,
                                                                    200, 30)];
        ipTextField.delegate = self;
        ipTextField.backgroundColor = [UIColor clearColor];
        ipTextField.returnKeyType = UIReturnKeyDone;
        ipTextField.text = @"192.168.1.100";
        ipTextField.textColor = [UIColor whiteColor];
        ipTextField.borderStyle = UITextBorderStyleNone;
        ipTextField.textAlignment = NSTextAlignmentLeft;
        ipTextField.font = [UIFont systemFontOfSize:15];
        ipTextField.keyboardType = UIKeyboardTypeNumberPad;
        ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:ipTextField];
        
        top = CGRectGetMaxY(_iptitleL.frame)+15;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, top, frame.size.width, 1)];
        line.backgroundColor =  B_GRAY_COLOR;
        [self addSubview:line];
        
        top = CGRectGetMaxY(line.frame);
        
        _connectionTableView = [[UIView alloc] initWithFrame:CGRectMake(leftx, top,
                                                                   frame.size.width-leftx,
                                                                   60)];
        
        
        [self addSubview:_connectionTableView];
    
        
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(frame.size.width - 15 - 70, 0, 70, 44);
        btnSave.layer.cornerRadius = 3;
        btnSave.clipsToBounds = YES;
        [self addSubview:btnSave];
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
    _connectionView._connectIdx = (int)sender.tag;
    [_connectionView showFromPoint:CGPointMake(CGRectGetMidX(self.bounds),
                                               CGRectGetMidY(self.bounds))];
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
    
    if([_connectionView superview])
        [_connectionView removeFromSuperview];
    
    for(ConnectionRowCell *cell in _connection_cells)
    {
        [cell updateConnection];
    }
}

- (void) recoverSetting{
    
    [_connectionView removeFromSuperview];
    
    [[_connectionTableView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    RgsDriverInfo * info = _plugDriver._driverInfo;
    
    BOOL _isIR = NO;
    if([info.classify isEqualToString:@"IR Controller"])
    {
        _isIR = YES;
    }
    
    if(_plugDriver._ipaddress == nil)
    {
        _iptitleL.alpha = 0.5;
        ipTextField.alpha = 0.5;
        ipTextField.text = @"";
        ipTextField.userInteractionEnabled = NO;
        
        _connectionTableView.hidden = NO;
        
        if([_plugDriver._connections count] == 0)
        {
            [self syncCurrentDriverComs];
        }
        else
        {
            self._connection_cells = [NSMutableArray array];
            
            int y = 0;
            for(int i = 0; i < [_plugDriver._connections count]; i++)
            {
                RgsConnectionObj *connect = [_plugDriver._connections objectAtIndex:i];
                
                CGRect rc = CGRectMake(0, y, _connectionTableView.frame.size.width, 60);
                
                ConnectionRowCell *cell = [[ConnectionRowCell alloc] initWithFrame:rc];
                [_connectionTableView addSubview:cell];
                if(_isIR)
                {
                    [cell fillIRConnection:connect];
                }
                else
                {
                    [cell fillComConnection:connect];
                }
                
                cell.btnConnect.tag = i;
                [cell.btnConnect addTarget:self
                                    action:@selector(connectionSet:)
                          forControlEvents:UIControlEventTouchUpInside];
                
                y = CGRectGetMaxY(cell.frame);
                
                [self._connection_cells addObject:cell];
            }
            
            CGRect rc = _connectionTableView.frame;
            rc.size.height = y;
            _connectionTableView.frame = rc;
        }
        
        
        return;
    }
    else
    {
        _iptitleL.alpha = 1;
        ipTextField.alpha = 1;
        ipTextField.text = @"";
        ipTextField.userInteractionEnabled = YES;
        
        _connectionTableView.hidden = YES;
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

- (void) syncCurrentDriverComs{
    
    if(_plugDriver._driver
       && [_plugDriver._driver isKindOfClass:[RgsDriverObj class]]
       && ![_plugDriver._connections count])
    {
        IMP_BLOCK_SELF(DriverPropertyView);
        
        RgsDriverObj *comd = _plugDriver._driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverConnects:comd.m_id
                                              completion:^(BOOL result, NSArray *connects, NSError *error) {
                                                  if (result) {
                                                      if ([connects count]) {
                                                          
                                                          
                                                          [block_self updateDriverConnections:connects];
                                                      }
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"sync Driver Connection Error");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      
                                                      //[KVNProgress showErrorWithStatus:[error description]];
                                                  }
                                              }];
        
    }
}

- (void) updateDriverConnections:(NSArray *)connects{
    
    _plugDriver._connections = connects;
    //_plugDriver._com = [connects objectAtIndex:0];
    ///_comField.text = _plugDriver._com.name;
    
    RgsDriverInfo * info = _plugDriver._driverInfo;
    
    BOOL _isIR = NO;
    if([info.classify isEqualToString:@"IR Controller"])
    {
        _isIR = YES;
    }
    
    self._connection_cells = [NSMutableArray array];
    
    int y = 0;
    for(int i = 0; i < [_plugDriver._connections count]; i++)
    {
        RgsConnectionObj *connect = [_plugDriver._connections objectAtIndex:i];
        
        CGRect rc = CGRectMake(0, y, _connectionTableView.frame.size.width, 60);
        
        ConnectionRowCell *cell = [[ConnectionRowCell alloc] initWithFrame:rc];
        [_connectionTableView addSubview:cell];
        if(_isIR)
        {
            [cell fillIRConnection:connect];
        }
        else
        {
            [cell fillComConnection:connect];
        }
        
        cell.btnConnect.tag = i;
        [cell.btnConnect addTarget:self
                       action:@selector(connectionSet:)
             forControlEvents:UIControlEventTouchUpInside];

        
        y = CGRectGetMaxY(cell.frame);
        
        [self._connection_cells addObject:cell];
    }
    
    CGRect rc = _connectionTableView.frame;
    rc.size.height = y;
    _connectionTableView.frame = rc;
}

@end
