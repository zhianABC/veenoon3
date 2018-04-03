//
//  AdjustAudioVideoEnvSettingsViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2018/4/3.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AdjustAudioVideoEnvSettingsViewCtrl.h"

@interface AdjustAudioVideoEnvSettingsViewCtrl() <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
}

@end

@implementation AdjustAudioVideoEnvSettingsViewCtrl
@synthesize selectedSysDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *centerTitleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleL.textColor = [UIColor whiteColor];
    centerTitleL.backgroundColor = [UIColor clearColor];
    centerTitleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:centerTitleL];
    centerTitleL.text = @"修改配置";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               64,
                                                               SCREEN_WIDTH,
                                                               SCREEN_HEIGHT-64-50)];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
}


- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)  {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"audio"];
        return [audioArray count];
    } else if (section == 1) {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"video"];
        return [audioArray count];
    } else {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"env"];
        return [audioArray count];
    }
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
    
    NSMutableDictionary *dataDic = nil;
    
    if (indexPath.section == 0) {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"audio"];
        dataDic = [audioArray objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"video"];
        dataDic = [audioArray objectAtIndex:indexPath.row];
    } else {
        NSMutableArray *audioArray = [self.selectedSysDic objectForKey:@"env"];
        dataDic = [audioArray objectAtIndex:indexPath.row];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [cell.contentView addSubview:line];
    
    int leftRight = 100;
    int labelWidth = 100;
    int gap = (SCREEN_WIDTH - leftRight*2 - labelWidth*3)/3;
    
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(leftRight,
                                                                5,
                                                                labelWidth, 34)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:15];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentLeft;
    
    valueL.text = [dataDic objectForKey:@"productType"];
    
    
    valueL = [[UILabel alloc] initWithFrame:CGRectMake(leftRight+gap+labelWidth,
                                                                5,
                                                                labelWidth, 34)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:15];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentLeft;
    
    valueL.text = [dataDic objectForKey:@"brand"];
    
    
    valueL = [[UILabel alloc] initWithFrame:CGRectMake(leftRight+2*gap+2*labelWidth,
                                                       5,
                                                       labelWidth, 34)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:15];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentLeft;
    
    valueL.text = [dataDic objectForKey:@"productCategory"];
    
    
    valueL = [[UILabel alloc] initWithFrame:CGRectMake(leftRight+3*gap+3*labelWidth,
                                                       5,
                                                       labelWidth, 34)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:15];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentLeft;
    
    valueL.text = [dataDic objectForKey:@"number"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int section = (int) indexPath.section;
    int row = (int)indexPath.row;
    NSMutableArray *dataArray = nil;
    if (section == 0) {
        dataArray = [self.selectedSysDic objectForKey:@"audio"];
    } else if (section == 1) {
        dataArray = [self.selectedSysDic objectForKey:@"video"];
    } else {
        dataArray = [self.selectedSysDic objectForKey:@"env"];
    }
    
    [dataArray removeObjectAtIndex:row];
    
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    header.backgroundColor = [UIColor clearColor];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tb_header_bg.png"]];
    [header addSubview:bg];
    bg.frame = header.bounds;
    
    if (section == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 26)];
        label.text = @"音频插件";
        label.textColor = [UIColor whiteColor];
        [header addSubview:label];
        
    } else if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 26)];
        label.text = @"视频插件";
        label.textColor = [UIColor whiteColor];
        [header addSubview:label];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 26)];
        label.text = @"环境插件";
        label.textColor = [UIColor whiteColor];
        [header addSubview:label];
    }
    
    
    
    return header;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
