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

@interface UserEnvStateView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_currentDeviceArray;
}
@end

@implementation UserEnvStateView
@synthesize _dataArray;

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
    NSString *notfiyDeviceID = [NSString stringWithFormat:@"%d", (int) dev_notify.device_id];
    NSString *notifyValue = [dev_notify.param objectForKey:@"value"];
    for (NSMutableDictionary *dataDic in _currentDeviceArray) {
        NSString *idStr = [dataDic objectForKey:@"id"];
        if ([notfiyDeviceID isEqualToString:idStr]) {
            NSString *danwei = [dataDic objectForKey:@"danwei"];
            UILabel *valueL = [dataDic objectForKey:@"label"];
            
            
            valueL.text = [notifyValue stringByAppendingString:danwei];
            
            break;
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
    
     //    if (result) {
     //        for (RgsConnectionObj *connectObj in connects) {
     //            [connectObj GetBoundings:^(BOOL result, NSArray *connections, NSError *error) {
     //                if ([connections count]) {
     //                    [connectObjArray addObject:[connections objectAtIndex:0]];
     //                }
     //            }];
     //        }
     //    }
    
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
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:kCellID];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.editing = NO;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    
    UserSensorObj *userSensor = [self._dataArray objectAtIndex:indexPath.section];
    NSMutableArray *connectionArray = userSensor.connectionObjArray;
    
    
    UIImageView *titleIcon = [[UIImageView alloc] init];

    [cell addSubview:titleIcon];
    titleIcon.frame = CGRectMake(30, 12, 20, 20);
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                2,
                                                                CGRectGetWidth(self.frame)/2-110, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
//    RgsDriverInfo *driverInfo = [dataDic objectForKey:@"driverinfo"];
   
    
    
    RgsConnectionObj *connection = [connectionArray objectAtIndex:indexPath.row];
    NSString *danwei = nil;
    if([connection.bound_connect_str count])
    {
        NSString *str = [connection.bound_connect_str objectAtIndex:0];
        if([str containsString:@"PM2.5"])
        {
            titleL.text = @"PM2.5";
            danwei = @" μg/m³";
            titleIcon.image = [UIImage imageNamed:@"pm2.5_zhishu.png"];
        }
        else if([str containsString:@"Temperature"])
        {
            titleL.text = @"温度";
            danwei = @" ℃";
            titleIcon.image = [UIImage imageNamed:@"wendu_zhishu.png"];
        }
        else
        {
            titleL.text = @"湿度";
            danwei = @" %";
            titleIcon.image = [UIImage imageNamed:@"shidu_zhishu.png"];
        }
    }
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-192,
                                                                12,
                                                                80, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    
    titleIcon = [[UIImageView alloc] init];
    [cell addSubview:titleIcon];
    titleIcon.frame = CGRectMake(CGRectGetWidth(self.frame)-135, 17, 20, 20);

    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:connection.driver_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
        
        if([proxys count])
        {
            RgsProxyObj *proxy = [proxys objectAtIndex:0];
            
            [[RegulusSDK sharedRegulusSDK] GetProxyCurState:proxy.m_id completion:^(BOOL result, NSDictionary *state, NSError *error) {
                
                if([state count]) {
                    valueL.text = [[state objectForKey:@"value"] stringByAppendingString:danwei];
                    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
                    [dataDic setObject:valueL forKey:@"label"];
                    [dataDic setObject:danwei forKey:@"danwei"];
                    NSString *idStr = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
                    [dataDic setObject:idStr forKey:@"id"];
                    
                    [_currentDeviceArray addObject:dataDic];
                }
                
            }];
        }
        
    }];
    
//    NSString *state = [dataDic objectForKey:@"state"];
//    if ([state isEqualToString:@"True"]) {
//        valueL.textColor = [UIColor greenColor];
//        valueL.text = @"运行正常";
//        titleIcon.image = [UIImage imageNamed:@"user_state_normal.png"];
//
//    } else {
//        valueL.textColor = [UIColor redColor];
//        valueL.text = @"运行故障";
//        titleIcon.image = [UIImage imageNamed:@"user_state_unnormal.png"];
//    }
    
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, 43,
                                                              self.frame.size.width-140, 1)];
    line.backgroundColor =  NEW_ER_BUTTON_GRAY_COLOR2;
    [cell addSubview:line];
    
    
    
    
    return cell;
}

@end
