//
//  UserDeviceStateView.m
//  veenoon
//
//  Created by 安志良 on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "UserDeviceStateView.h"
#import "RegulusSDK.h"

@interface UserDeviceStateView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation UserDeviceStateView
@synthesize _dataArray;


- (id)initWithFrame:(CGRect)frame withData:(NSMutableArray*) dataArray {
    if(self = [super initWithFrame:frame])
    {
        self._dataArray = dataArray;
        
        self.backgroundColor = [UIColor clearColor];
        
        int top = 20;
        
        CGRect rc = CGRectMake(0, top, frame.size.width, frame.size.height - 44);
        
        _tableView = [[UITableView alloc] initWithFrame:rc];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *currentSectionArray = [self._dataArray objectAtIndex:section];
    return [currentSectionArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.frame.size.width, 30)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, 29,
                                                              self.frame.size.width-60, 1)];
    line.backgroundColor =  NEW_ER_BUTTON_GRAY_COLOR2;
    [header addSubview:line];
    
    
    UILabel *rowL = [[UILabel alloc] initWithFrame:CGRectMake(30,
                                                              12,
                                                              CGRectGetWidth(self.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    
    if(section == 0)
    {
        rowL.text = @"音频设备";
    }
    else if (section == 1)
    {
        rowL.text = @"视频设备";
    }
    else if (section == 2)
    {
        rowL.text = @"环境设备";
    }
    else if (section == 3)
    {
        rowL.text = @"传感设备";
    }
    else if (section == 4)
    {
        rowL.text = @"微气候";
    }
    
    rowL.textColor  = [UIColor whiteColor];
    
    
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
    
    NSMutableArray *sectionRowArray = [self._dataArray objectAtIndex:indexPath.section];
    NSMutableDictionary *dataDic = [sectionRowArray objectAtIndex:indexPath.row];
    
    UIImageView *titleIcon = [[UIImageView alloc] init];
    titleIcon.image = [UIImage imageNamed:[dataDic objectForKey:@"icon"]];
    [cell addSubview:titleIcon];
    titleIcon.frame = CGRectMake(30, 7, 30, 30);
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                12,
                                                                CGRectGetWidth(self.frame)/2-70, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    RgsDriverInfo *driverInfo = [dataDic objectForKey:@"driverinfo"];
    titleL.text = driverInfo.name;
    
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-140,
                                                                12,
                                                                80, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentLeft;
    
    titleIcon = [[UIImageView alloc] init];
    [cell addSubview:titleIcon];
    titleIcon.frame = CGRectMake(CGRectGetWidth(self.frame)-60, 7, 30, 30);
    
    NSString *state = [dataDic objectForKey:@"state"];
    if ([state isEqualToString:@"True"]) {
        valueL.textColor = [UIColor greenColor];
        valueL.text = @"运行正常";
        titleIcon.image = [UIImage imageNamed:@"user_state_normal.png"];
        
    } else {
        valueL.textColor = [UIColor redColor];
        valueL.text = @"运行故障";
        titleIcon.image = [UIImage imageNamed:@"user_state_unnormal.png"];
    }
    
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(30, 29,
                                                              self.frame.size.width-60, 1)];
    line.backgroundColor =  NEW_ER_BUTTON_GRAY_COLOR2;
    [cell addSubview:line];
    
    
    
    
    return cell;
}

@end
