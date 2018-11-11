//
//  SysInfoViewController.m
//  veenoon
//
//  Created by 安志良 on 2018/11/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "SysInfoViewController.h"

@interface SysInfoViewController () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
}

@end

@implementation SysInfoViewController

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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = LINE_COLOR.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"系统时间";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  LINE_COLOR;
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                      1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 35)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 35)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = LINE_COLOR.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"系统信息";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  LINE_COLOR;
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = LINE_COLOR.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"网络信息";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  LINE_COLOR;
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            UIView *cellV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 45)];
            cellV.backgroundColor = SYS_INFO_SEC_COLOR;
            cellV.layer.cornerRadius = 5;
            cellV.layer.borderColor = LINE_COLOR.CGColor;
            cellV.layer.borderWidth = 1;
            
            [cell.contentView addSubview:cellV];
            
            titleName = @"关于应用程序";
            [cellV addSubview:titleL];
            
            cell.backgroundColor = SYS_INFO_SEC_COLOR;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                                      SCREEN_WIDTH-100, 1)];
            line.backgroundColor =  LINE_COLOR;
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
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
            line.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line];
            
            UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                       1, 36)];
            line2.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line2];
            
            UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(cellV.frame.size.width-1, 0,
                                                                       1, 36)];
            line3.backgroundColor =  LINE_COLOR;
            [cellV addSubview:line3];
        }
    }
    titleL.text = titleName;
    titleL2.text = titleName2;
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-215,
                                                                12,
                                                                80, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    valueL.text = @"Asian/Shanghai";
    
    return cell;
}
- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
