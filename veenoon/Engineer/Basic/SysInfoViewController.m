//
//  SysInfoViewController.m
//  veenoon
//
//  Created by 安志良 on 2018/11/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "SysInfoViewController.h"
#import "WSDatePickerView.h"
#import "JCActionView.h"
#import "AppDelegate.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "SysInfoVersionView.h"
#import "EngineerMeetingRoomListViewCtrl.h"

@interface SysInfoViewController () <UITableViewDelegate, UITableViewDataSource, JCActionViewDelegate>{
    UITableView *_tableView;
    WSDatePickerView * timepicker;
    
    UIView *whiteView;
}
@property (nonatomic, strong) NSMutableDictionary *_mapValue;
@property (nonatomic, strong) RgsUpdatePacketInfo *_pack;
@end

@implementation SysInfoViewController
@synthesize _mapValue;
@synthesize _pack;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    UIView *_topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topBar.backgroundColor = DARK_GRAY_COLOR;
    [self.view addSubview:_topBar];
    
    UILabel *centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleLabel.textColor = [UIColor whiteColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    centerTitleLabel.text = @"系统信息";
    centerTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_topBar addSubview:centerTitleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(30, 32, 40, 20);
    [backBtn setImage:[UIImage imageNamed:@"left_back_bg.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"left_back_bg.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:backBtn];
    
    CGRect rc = CGRectMake(50, 60, SCREEN_WIDTH-100, SCREEN_HEIGHT - 84);
    
    _tableView = [[UITableView alloc] initWithFrame:rc style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [whiteView addGestureRecognizer:tapGesture];
    
    
    whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 390, SCREEN_WIDTH,
                                                         390)];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    CGRect rc2 = CGRectMake((SCREEN_WIDTH - 600)/2, 40, 600, 300);
    timepicker = [[WSDatePickerView alloc]
                  initWithDateStyle:DateStyleShowYearMonthDayHourMinute frame:rc2];
    timepicker.dateLabelColor = [UIColor orangeColor];//年-月-日-时-分 颜色
    timepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    
    [whiteView addSubview:timepicker];
    
     UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake((SCREEN_WIDTH - 600)/2, 310, 600, 50);
    [whiteView addSubview:saveBtn];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [saveBtn addTarget:self
                action:@selector(saveAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    whiteView.hidden = YES;
    
    self._mapValue = [NSMutableDictionary dictionary];
    
    [self getSysInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(goBack:)
                                                 name:@"NotifyGoBackWhenReboot"
                                               object:nil];
    
}

- (void) goBack:(id)sender{
    
    UIViewController *roomsVC = nil;
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[EngineerMeetingRoomListViewCtrl class]])
        {
            roomsVC = vc;
            break;
        }
    }
    
    if(roomsVC)
    {
        [self.navigationController popToViewController:roomsVC
                                              animated:YES];
    }
    
}

- (void) getSysInfo{
 
    IMP_BLOCK_SELF(SysInfoViewController);
    [[RegulusSDK sharedRegulusSDK] GetSystemInfo:^(BOOL result, RgsSystemInfo *sys_info, NSError *error) {
        
        [block_self prepareData:sys_info];
    }];
    
}

- (void) prepareData:(RgsSystemInfo*)sysInfo{
 
    NSDate *sysDate = sysInfo.sys_time;
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:sysDate];
    
    [_mapValue setObject:currentDateString forKey:@"sys_date"];
    
    
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    [_mapValue setObject:localTimeZone.name forKey:@"local_zone"];
    
    [_mapValue setObject:sysInfo.hardware forKey:@"hardware"];
    
    [_mapValue setObject:sysInfo.software_version forKey:@"software_version"];
    
    NSString *autoIp = sysInfo.auto_ip==YES?@"是":@"否";
    
    [_mapValue setObject:autoIp forKey:@"autoIp"];
    
    [_mapValue setObject:sysInfo.ip forKey:@"ip"];
    
    [_mapValue setObject:sysInfo.mask forKey:@"mask"];
    [_mapValue setObject:sysInfo.gateway forKey:@"gateway"];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    [_mapValue setObject:app_Version forKey:@"app_version"];
    
    [_tableView reloadData];
}


- (void) saveAction:(id)sender {
    
    NSDate *sysDate = [timepicker getSelectedDate];
    [[RegulusSDK sharedRegulusSDK] SetDate:sysDate
                                completion:nil];
    
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:sysDate];
    
    [_mapValue setObject:currentDateString forKey:@"sys_date"];
    
    [_tableView reloadData];
    
    
    [self hidden];
}
#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 5;
    } else {
        return 3;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                2,
                                                                CGRectGetWidth(self.view.frame)/2-110, 32)];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    titleL.textAlignment = NSTextAlignmentLeft;
    NSString *titleName = @"";
    
    UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(30,
                                                                2,
                                                                CGRectGetWidth(self.view.frame)/2-110, 32)];
    titleL2.backgroundColor = [UIColor clearColor];
    titleL2.font = [UIFont systemFontOfSize:13];
    titleL2.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    titleL2.textAlignment = NSTextAlignmentLeft;
    NSString *titleName2 = @"";
    
    cell.clipsToBounds = YES;
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-135-200,
                                                                12,
                                                                200, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    valueL.text = @"";

    UIColor *lineColor = USER_GRAY_COLOR;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = lineColor.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"系统时间";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
        } else if (indexPath.row == 1) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"时间";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                      1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"sys_date"];
            
        } else if (indexPath.row == 2) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"时区";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 35)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 35)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"local_zone"];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = lineColor.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"系统信息";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
        } else if (indexPath.row == 1) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"硬件";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"hardware"];
            
        } else if (indexPath.row == 2) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"软件版本";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"software_version"];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = lineColor.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"网络信息";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
        } else if (indexPath.row == 1) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"自动获取IP";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"autoIp"];
            
        } else if (indexPath.row == 2) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"IP";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"ip"];
            
        } else if (indexPath.row == 3) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"掩码";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"mask"];
            
        } else if (indexPath.row == 4) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"网关";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"gateway"];
            
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = lineColor.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"关于应用程序";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
        } else if (indexPath.row == 1) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"当前版本账号";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
            
            valueL.text = [_mapValue objectForKey:@"app_version"];
            
        } else if (indexPath.row == 2) {
            
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 36)];
            cellV.backgroundColor = LOGIN_BLACK_COLOR;
            
            [cell.contentView addSubview:cellV];
            
            [cellV addSubview:titleL];
            [cellV addSubview:titleL2];
            
            titleName2 = @"更新系统";
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  lineColor;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  lineColor;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  lineColor;
            [cellV addSubview:line3];
        }
    }
    titleL.text = titleName;
    titleL2.text = titleName2;
    
    [cell.contentView addSubview:valueL];
    
    return cell;
}
- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int selectedSection = (int)indexPath.section;
    int selectedRow = (int)indexPath.row;
    
    if (selectedSection == 0 && selectedRow == 0) {
        [self popupTimeView];
    } else if (selectedSection == 2 && selectedRow == 0) {
        [self popupIPView];
    } else if (selectedSection == 1 && selectedRow == 0) {
        [self popupVersionView];
    }
    
    //NSLog(@"sss");
    
}

- (void) popupTimeView {
    whiteView.hidden = NO;
}

- (void) popupIPView {
    JCActionView *jcAction = [[JCActionView alloc] initWithTils:@[@"动态IP", @"静态IP"]
                                                          frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) title:@"请选择网络配置"];
    jcAction.delegate_ = self;
    jcAction.tag = 2017;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:jcAction];
    [jcAction animatedShow];
}

- (void) handleTapGesture:(id)sender{
    
    [self hidden];
}

- (void) hidden{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.hidden = YES;
                         
                     } completion:^(BOOL finished) {
                         // refresh UI.
                     }];
}

- (void) popupVersionView {
    
    IMP_BLOCK_SELF(SysInfoViewController);
    
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] RequestSystemVersionCheck:^(BOOL result, RgsUpdatePacketInfo *info, NSError *error) {
        
        [KVNProgress dismiss];
        [block_self reqUpdateInfo:info];
    }];
    
    
}

- (void) reqUpdateInfo:(RgsUpdatePacketInfo*)info{
 
    NSMutableArray *btns = [NSMutableArray array];
    NSString *title = @"";
    int tag = 201801;
    if(info == nil)
    {
        title = @"当前已经是最新版本";
        [btns addObject:@"U盘更新"];
        tag = 201801;
    }
    else
    {
        self._pack = info;
        
        title = [NSString stringWithFormat:@"发现新版本：%@",info.version];
        [btns addObject:@"网络更新"];
        [btns addObject:@"U盘更新"];
        tag = 201802;
    }
    
    JCActionView *jcAction = [[JCActionView alloc] initWithTils:btns
                                                          frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                          title:title];
    jcAction.delegate_ = self;
    jcAction.tag = tag;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:jcAction];
    [jcAction animatedShow];

}

- (void) didJCActionButtonIndex:(int)index actionView:(UIView*)actionView{
    
    IMP_BLOCK_SELF(SysInfoViewController);

    if(actionView.tag == 2017)
    {
        if (index == 1) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"网络参数"
                                                  message:@"请设置网格参数"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"IP";
                textField.text = [_mapValue objectForKey:@"ip"];
            }];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"New Mask";
                textField.text = [_mapValue objectForKey:@"mask"];
            }];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"Gateway";
                textField.text = [_mapValue objectForKey:@"gateway"];
            }];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if([alertController.textFields count] == 3)
                {
                    UITextField *t1 = [alertController.textFields objectAtIndex:0];
                    UITextField *t2 = [alertController.textFields objectAtIndex:1];
                    UITextField *t3 = [alertController.textFields objectAtIndex:2];
                    
                    if([t1.text length] && [t2.text length] && [t3.text length])
                    {
                        [block_self doSetRegulusIP:@[t1.text,t2.text,t3.text]];
                    }
                    
                }
            }]];
            
            
            [self presentViewController:alertController animated:true completion:nil];
        }
        else if(index == 0)
        {
            [[RegulusSDK sharedRegulusSDK] SetIPAuto:nil];
        }
    }
    else if(actionView.tag == 201801)
    {
         [self gotoUdiskUpdate];
    }
    else if(actionView.tag == 201802)
    {
        if(index == 0)
        {
            [[RegulusSDK sharedRegulusSDK] DownloadAndInstallUpdatePacket:_pack completion:nil];
        }
        else if(index == 1)
        {
            [self gotoUdiskUpdate];
        }
    }
}

- (void) gotoUdiskUpdate{
 
    SysInfoVersionView *sv = [[SysInfoVersionView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [self.view addSubview:sv];
    sv.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetHeight(self.view.frame)/2);
    
    [sv loadUdiskData];
}

- (void) doSetRegulusIP:(NSArray*)vals{
    
    [[RegulusSDK sharedRegulusSDK] SetIPManual:[vals objectAtIndex:0]
                                          mask:[vals objectAtIndex:1]
                                       gateway:[vals objectAtIndex:2]
                                    completion:nil];
}

- (void) dealloc
{
 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
