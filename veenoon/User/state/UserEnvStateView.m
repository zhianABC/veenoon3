//
//  UserEnvStateView.m
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserEnvStateView.h"
#import "UserSensorObj.h"
#import "RegulusSDK.h"
#import "EnvStateTableViewCell.h"

@interface UserEnvStateView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_currentDeviceArray;
}
@property (nonatomic, strong) NSMutableDictionary *_dataMap;
@end

@implementation UserEnvStateView
@synthesize _dataArray;
@synthesize _dataMap;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame withData:(NSMutableArray*) dataArray {
    if(self = [super initWithFrame:frame])
    {
        self._dataArray = dataArray;
        
        self.backgroundColor = [UIColor clearColor];
        
        if ([_currentDeviceArray count]) {
            [_currentDeviceArray removeAllObjects];
        } else {
            _currentDeviceArray = [NSMutableArray array];
        }
        
        int top = 20;
        
        CGRect rc = CGRectMake(40, top, frame.size.width-80, frame.size.height - 44);
        
        _tableView = [[UITableView alloc] initWithFrame:rc];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        self._dataMap = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyConnectionsLoad:) name:@"Notify_Connections_Loaded"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onStateChange:)
         name:@"RgsDeviceNotify"
         object:nil];
        
        [self reloadConnects];
    }
    return self;
}

-(void)onStateChange:(NSNotification *)notify
{
    
    //TODO: 处理温度/湿度/PM2.5的刷新
    RgsDeviceNoteObj * dev_notify = notify.object;
    if(dev_notify && [dev_notify isKindOfClass:[RgsDeviceNoteObj class]])
    {
        id notfiyDeviceID = [NSNumber numberWithInteger:dev_notify.device_id];
        
        if([dev_notify.param objectForKey:@"value"])
        {
            NSString *notifyValue = [dev_notify.param objectForKey:@"value"];
            
            [self._dataMap setObject:notifyValue forKey:notfiyDeviceID];
            
            [_tableView reloadData];
        }
    }
    
}

- (void) notifyConnectionsLoad:(id)sender{
    
    [_tableView reloadData];
}

- (void) reloadConnects{
    
    for(UserSensorObj *userSensor in self._dataArray)
    {
        [userSensor getMyConnects];
        
    }
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self._dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UserSensorObj *userSensor = [self._dataArray objectAtIndex:section];
    
    NSMutableArray *connectionArray = userSensor.connectionObjArray;
    return [connectionArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.frame.size.width, 54)];
    header.backgroundColor = USER_GRAY_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, 53,
                                                              self.frame.size.width-140, 1)];
    line.backgroundColor =  NEW_ER_BUTTON_GRAY_COLOR2;
    [header addSubview:line];
    
    
    UILabel *rowL = [[UILabel alloc] initWithFrame:CGRectMake(30,
                                                              7,
                                                              CGRectGetWidth(self.frame)-20, 40)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    
    UserSensorObj *userSensor = [self._dataArray objectAtIndex:section];
    RgsDriverObj *driverObj = userSensor.rgsDriverObj;
    rowL.text = [@"传感设备 - " stringByAppendingString:driverObj.name];
    
    rowL.textColor  = NEW_ER_BUTTON_SD_COLOR;

    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellID = @"listCell";
    
    EnvStateTableViewCell *cell = (EnvStateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(1) {
        cell = [[EnvStateTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.editing = NO;
    }
   
    UserSensorObj *userSensor = [self._dataArray objectAtIndex:indexPath.section];
    NSMutableArray *connectionArray = userSensor.connectionObjArray;
    
    cell.connection = [connectionArray objectAtIndex:indexPath.row];
    
    [cell refreshData];
    [cell updateValue:_dataMap];
    
    return cell;
}

@end
