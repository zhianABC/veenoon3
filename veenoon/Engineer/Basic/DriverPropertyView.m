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
        _connectionL = [[UILabel alloc] initWithFrame:CGRectMake(30, 7, 110, 30)];
        _connectionL.textColor = [UIColor whiteColor];
        _connectionL.backgroundColor = [UIColor clearColor];
        [self addSubview:_connectionL];
        _connectionL.font = [UIFont systemFontOfSize:15];
        _connectionL.text = @"串口号: ";
        
        _conField = [[UITextField alloc] initWithFrame:CGRectMake(150,
                                                                  7,
                                                                  frame.size.width - 150-20-40,
                                                                  30)];
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
        btnConnect.frame = CGRectMake(CGRectGetMaxX(_conField.frame), 0, 60, frame.size.height);
        [self addSubview:btnConnect];
        [btnConnect setImage:[UIImage imageNamed:@"connect_icon.png"]
                    forState:UIControlStateNormal];
        
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        line.backgroundColor =  USER_GRAY_COLOR;
        [self addSubview:line];
        
    }
    
    return self;
}

- (void) fillComConnection:(RgsConnectionObj *)connect{
    
    _connectionL.text = connect.name;
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
                          (int)connect.driver_id,
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


@interface DriverPropertyView () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    int leftx;
    
    UIButton *btnSave;
    
    DriverConnectionsView   *_connectionView;
    

    UITableView *_tableView;
    
    int         _curIndex;
    BOOL        _studying;
    
    BOOL        _isIR;
    
    
}
@property (nonatomic, strong) NSMutableArray *_connection_cells;
@property (nonatomic, strong) NSArray *_studyItems;

@property (nonatomic, strong) NSMutableArray *ssidSettings;
@property (nonatomic, strong) NSMutableDictionary *_fieldVals;


@end

@implementation DriverPropertyView
@synthesize _plugDriver;
@synthesize _connection_cells;
@synthesize _studyItems;
@synthesize _isAirQuality;
@synthesize ssidSettings;
@synthesize _fieldVals;

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
        self.layer.borderColor = USER_GRAY_COLOR.CGColor;
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
        
//        UILabel* rightL = [[UILabel alloc] initWithFrame:CGRectMake(15,
//                                                                  0,
//                                                                  frame.size.width-30, 44)];
//        rightL.backgroundColor = [UIColor clearColor];
//        [titleBar addSubview:rightL];
//        rightL.font = [UIFont boldSystemFontOfSize:14];
//        rightL.textColor  = [UIColor whiteColor];
//        rightL.text = @"保存";
//        rightL.textAlignment = NSTextAlignmentRight;

        
        leftx = 30;
        
        int top = 44;
        
        CGRect rc = CGRectMake(0, top, frame.size.width, frame.size.height - 44);

    
        _curIndex = -1;
        _isIR = NO;
        
        self._fieldVals = [NSMutableDictionary dictionary];
        
        _tableView = [[UITableView alloc] initWithFrame:rc];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
       // _tableView.tableHeaderView = _tabHeader;
        
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(frame.size.width - 15 - 70, 0, 70, 44);
        btnSave.layer.cornerRadius = 3;
        btnSave.clipsToBounds = YES;
        [self addSubview:btnSave];
        btnSave.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSave setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        //btnSave.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        btnSave.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [btnSave addTarget:self
                    action:@selector(saveCurrentSetting)
          forControlEvents:UIControlEventTouchUpInside];
        
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyIRRecord:)
                                                     name:@"Notify_Study_IR"
                                                   object:nil];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    if (_isAirQuality) {
        
        NSDictionary *row = [ssidSettings objectAtIndex:1];
        
        UITextField *tField = [_fieldVals objectForKey:[row objectForKey:@"name"]];
        if(tField)
        {
            [RegulusSDK RgsWifiConfWithPassword:tField.text
                                      taskCount:3
                                    timeIntevel:10
                                       callback:^(NSError *error) {
                                           if (error) {
                                               [KVNProgress showErrorWithStatus:[error localizedDescription]];
                                           }
                                           else{
                                               [KVNProgress dismiss];
                                           }
                                       }];
        }
        
        
    }
    else
    {
        for(RgsPropertyObj *pro in _plugDriver._properties)
        {
            UITextField *tField = [_fieldVals objectForKey:pro.name];
            if(tField)
            {
                pro.value = tField.text?tField.text:@"";
            }
        }
        
        [_plugDriver uploadDriverProperty];
    }
    

}

- (void) updateConnectionSet{
    
    [_tableView reloadData];
    
}

- (void) refreshLabelToAirQuality {
    
    if (_isAirQuality)
    {
        if(self.ssidSettings == nil)
        {
            self.ssidSettings = [NSMutableArray array];
            
            NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
            [rowDic setObject:@"SSID" forKey:@"name"];
            
            NSString *ssidName = [RegulusSDK GetWifiSSID];
            if(ssidName == nil)
                ssidName = @"";
            [rowDic setObject:ssidName forKey:@"value"];
            
            [ssidSettings addObject:rowDic];
            
            rowDic = [NSMutableDictionary dictionary];
            [rowDic setObject:@"密码" forKey:@"name"];
            [rowDic setObject:@"" forKey:@"value"];
            
            [ssidSettings addObject:rowDic];
        }
    }
}

- (void) recoverSetting {
    
    [_connectionView removeFromSuperview];
    [_fieldVals removeAllObjects];
    RgsDriverInfo * info = _plugDriver._driverInfo;
    
    _isIR = NO;
    if([info.system isEqualToString:@"IR Controller"])
    {
        _isIR = YES;
    }
    
    if(_isIR)
    {
        if(_plugDriver._irCodeKeys == nil)
        {
            [self syncIRDriverCodeKeys];
        }
        else
        {
            self._studyItems = _plugDriver._irCodeKeys;
        }
    }

    if([_plugDriver._connections count] == 0)
    {
        [self syncCurrentDriverComs];
    }

    if(_isAirQuality)
    {
        
        [self refreshLabelToAirQuality];
        
        [_tableView reloadData];
        return;
    }
    
    if(_plugDriver._properties)
    {
        [_tableView reloadData];
        return;
    }
    
    if(_plugDriver._driver && [_plugDriver._driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(DriverPropertyView);
        
        [KVNProgress show];
        RgsDriverObj *rd = (RgsDriverObj*)_plugDriver._driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverProperties:rd.m_id completion:^(BOOL result, NSArray *properties, NSError *error) {
            if (result) {
                
                [block_self updateDriverProperty:properties];
            }
            else
            {
                [KVNProgress showErrorWithStatus:@"加载失败，请重试"];
            }
        }];
    }
    
    
}

- (void) updateDriverProperty:(NSArray*)properties{
    
    if([properties count])
    {
        _plugDriver._properties = properties;
    }
    [_tableView reloadData];
    
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

- (void) syncIRDriverCodeKeys{
    
    if(_plugDriver._driver
       && [_plugDriver._driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(DriverPropertyView);
        
        [[RegulusSDK sharedRegulusSDK] GetIrDriverIrcodeKey:_plugDriver._driverUUID
                                                 completion:^(BOOL result,
                                                              NSDictionary *code_key,
                                                              NSError *error) {
                                                     
                                                     [block_self prepareIRCodeKeys:code_key];
                                                     
                                                 }];
        
    }
}

- (void) prepareIRCodeKeys:(NSDictionary*)code_key{
    
    NSMutableArray *codeKeys = [NSMutableArray array];
    
    NSArray *keys = [code_key allKeys];
    for(id key in keys)
    {
        NSMutableDictionary *row = [NSMutableDictionary dictionary];
        [row setObject:key forKey:@"name"];
        [row setObject:[code_key objectForKey:key] forKey:@"result"];
        BOOL result = [[code_key objectForKey:key] boolValue];
        if(result)
        {
            [row setObject:@"已学习" forKey:@"state"];
        }
        else
        {
            [row setObject:@"未学习" forKey:@"state"];
        }
        
        [codeKeys addObject:row];
        
    }
    
    self._studyItems = codeKeys;
    _plugDriver._irCodeKeys = codeKeys;
    
    [_tableView reloadData];
}

- (void) updateDriverConnections:(NSArray *)connects{
    
    _plugDriver._connections = connects;
     
    RgsDriverInfo * info = _plugDriver._driverInfo;
    
    BOOL _isIR = NO;
    if([info.system isEqualToString:@"IR Controller"])
    {
        _isIR = YES;
    }
    
    [_tableView reloadData];
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
    {
        if(!_isAirQuality)
            return [_plugDriver._properties count];
        else
            return [ssidSettings count];
    }
    if(section == 1)
    {
        return [_plugDriver._connections count];
    }
    if(section == 2)
        return [_studyItems count];
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    if(indexPath.section == 0)
    {
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(30,
                                                                    12,
                                                                    200, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        
        NSString *nameKey = nil;
        NSString *value = nil;
        if(_isAirQuality)
        {
            NSMutableDictionary *dic = [ssidSettings objectAtIndex:indexPath.row];
            titleL.text = [dic objectForKey:@"name"];
            
            value = [dic objectForKey:@"value"];
        }
        else
        {
            RgsPropertyObj *obj = [_plugDriver._properties objectAtIndex:indexPath.row];
            titleL.text = obj.name;
            
            value = obj.value;
        }
    
        nameKey = titleL.text;
        
        UITextField *tField = [_fieldVals objectForKey:nameKey];
        if(tField)
        {
            [cell.contentView addSubview:tField];
        }
        else
        {
            int width = _tableView.frame.size.width - leftx*2-80;
            
            tField = [[UITextField alloc] initWithFrame:CGRectMake(leftx+80,
                                                                   7,
                                                                   width, 30)];
            tField.delegate = self;
            tField.backgroundColor = [UIColor clearColor];
            tField.returnKeyType = UIReturnKeyDone;
            tField.text = value;
            tField.placeholder = @"请输入";
            tField.textColor = [UIColor whiteColor];
            tField.borderStyle = UITextBorderStyleNone;
            tField.textAlignment = NSTextAlignmentRight;
            tField.font = [UIFont systemFontOfSize:15];
            tField.keyboardType = UIKeyboardTypeASCIICapable;
            tField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell.contentView addSubview:tField];
            
            
            [_fieldVals setObject:tField forKey:nameKey];
        }
        
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43,
                                                                  _tableView.frame.size.width,
                                                                  1)];
        line.backgroundColor =  USER_GRAY_COLOR;
        [cell.contentView addSubview:line];
    }
    else if(indexPath.section == 1)
    {
        ConnectionRowCell *cc = [[ConnectionRowCell alloc] initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      _tableView.frame.size.width,
                                                                                      44)];
        
    
        RgsConnectionObj *connect = [_plugDriver._connections objectAtIndex:indexPath.row];
        cc.btnConnect.tag = indexPath.row;
        [cc.btnConnect addTarget:self
                          action:@selector(connectionSet:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [cc fillIRConnection:connect];
        
        [cell.contentView addSubview:cc];
    }
    else if(indexPath.section == 2)
    {
        //红外学习
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(110,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        
        NSDictionary *dic = [_studyItems objectAtIndex:indexPath.row];
        titleL.text = [dic objectForKey:@"name"];
        valueL.text = [dic objectForKey:@"state"];
        valueL.textColor = YELLOW_COLOR;
        
        if(_curIndex == indexPath.row)
        {
            valueL.text = @"等待学习...";
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line.backgroundColor =  USER_GRAY_COLOR;
        [cell.contentView addSubview:line];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 2)
    {
        if(_isIR)
            return 44;
    }
   
    return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.frame.size.width, 44)];
    if(section == 2)
    {
        if(!_isIR)
            return nil;
        
        header.backgroundColor = RGB(0x2b, 0x2b, 0x2c);
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43,
                                                                  self.frame.size.width, 1)];
        line.backgroundColor =  USER_GRAY_COLOR;
        [header addSubview:line];
        
        
        UILabel *rowL = [[UILabel alloc] initWithFrame:CGRectMake(30,
                                                                  12,
                                                                  CGRectGetWidth(self.frame)-20, 20)];
        rowL.backgroundColor = [UIColor clearColor];
        [header addSubview:rowL];
        rowL.font = [UIFont systemFontOfSize:13];
        rowL.textColor  = [UIColor whiteColor];
        
        if(_studying)
        {
            rowL.text = @"正在学习";
        }
        else
        {
            rowL.text = @"开始学习";
        }
        
        rowL.textColor  = YELLOW_COLOR;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(110,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [header addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [header addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        titleL.text = @"功能";
        valueL.text = @"状态";
        
        UIButton *btnStudy = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStudy.frame = CGRectMake(0, 0, 120, 44);
        [header addSubview:btnStudy];
        [btnStudy addTarget:self
                     action:@selector(buttonStudy:)
           forControlEvents:UIControlEventTouchUpInside];
        
        if(_studying)
        {
            btnStudy.enabled = NO;
        }
        else
        {
            btnStudy.enabled = YES;
        }
    }
    
    return header;
}

- (void) notifyIRRecord:(NSNotification*)notify{
    
    NSDictionary *obj = notify.object;
    NSString *uuid = [obj objectForKey:@"uuid"];
    NSString *name = [obj objectForKey:@"key"];
    NSNumber *result = [obj objectForKey:@"result"];
    if([uuid isEqualToString:_plugDriver._driverUUID])
    {
        if(_curIndex < [_studyItems count])
        {
            NSMutableDictionary *dic = [_studyItems objectAtIndex:_curIndex];
            NSString *key = [dic objectForKey:@"name"];
            if([key isEqualToString:name])
            {
                [dic setObject:result forKey:@"result"];
                if([result intValue] == 1)
                {
                    [dic setObject:@"已学习" forKey:@"state"];
                }
                else
                {
                    [dic setObject:@"未学习" forKey:@"state"];
                }
            }
            
            [NSTimer scheduledTimerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(tryNextKey:)
                                           userInfo:nil
                                            repeats:NO];
            
        }
    }
    
    [_tableView reloadData];
    
}

- (void) tryNextKey:(id)sender{
    
    [self findNextNeedStudy];
    [self tryToStudyNextIRKey];
}

- (void) buttonStudy:(UIButton*)sender{
    
    _curIndex = -1;
    _studying = YES;

    [self findNextNeedStudy];
    [self tryToStudyNextIRKey];
}

- (void) findNextNeedStudy{
    
    BOOL find = NO;
    for(int i = 0; i < [_studyItems count]; i++)
    {
        NSDictionary *dic = [_studyItems objectAtIndex:i];
        BOOL result = [[dic objectForKey:@"result"] boolValue];
        if(!result)
        {
            _curIndex = i;
            find = YES;
            break;
        }
    }
    
    if(!find)
    {
        _curIndex = -1;
    }
}

- (void) tryToStudyNextIRKey{
    
    if(_curIndex >= 0 && _curIndex < [_studyItems count])
    {
        
        NSIndexPath *current = [NSIndexPath indexPathForRow:_curIndex inSection:2];
        CGRect rc = [_tableView rectForRowAtIndexPath:current];
        if(CGRectGetMaxY(rc) > _tableView.contentOffset.y + CGRectGetHeight(_tableView.frame))
        {
            [_tableView scrollToRowAtIndexPath:current
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
        }
        
        [_tableView reloadData];
        
        
        NSDictionary *dic = [_studyItems objectAtIndex:_curIndex];
        NSString *name = [dic objectForKey:@"name"];
        [[RegulusSDK sharedRegulusSDK] RecordIrcode:_plugDriver._driverUUID
                                                cmd:name
                                         completion:^(BOOL result, NSError *error) {
                                             
                                         }];
        
    }
    else
    {
        _studying = NO;
        [_tableView reloadData];
    }
}


@end
