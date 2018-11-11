//
//  SysInfoVersionView.m
//  veenoon
//
//  Created by 安志良 on 2018/11/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "SysInfoVersionView.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface SysInfoVersionView() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *_datas;
@end


@implementation SysInfoVersionView
@synthesize _datas;

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.layer.borderWidth = 1;
        
        int startX = self.frame.size.width - 50;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(startX, 10, 40, 40);
        [self addSubview:cancelBtn];
        [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self
                      action:@selector(cancelAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    10,
                                            CGRectGetWidth(frame), 40)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.font = [UIFont boldSystemFontOfSize:15];
        titleL.textColor  = [UIColor blackColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"选择升级包";
        [self addSubview:titleL];
        
        CGRect rc = CGRectMake(0, 50, self.frame.size.width,
                               self.frame.size.height - 50);
        
        
        self._datas = [NSMutableArray array];
        
        _tableView = [[UITableView alloc] initWithFrame:rc style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return self;
}

- (void) cancelAction:(id) sender {
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         [self removeFromSuperview];
                         
                     } completion:^(BOOL finished) {
                         // refresh UI.
                     }];
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datas count];
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
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                CGRectGetWidth(self.frame), 44)];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor  = [UIColor blueColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = [_datas objectAtIndex:indexPath.row];
    [cell.contentView addSubview:titleL];
    
    if(indexPath.row == 0)
    {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame)-20, 1)];
        line.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:line];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, CGRectGetWidth(self.frame)-20, 1)];
    line.backgroundColor = LINE_COLOR;
    [cell.contentView addSubview:line];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSString *packName = [_datas objectAtIndex:indexPath.row];
    [[RegulusSDK sharedRegulusSDK] UpdateFromUdisc:packName completion:nil];
    
    
    [self cancelAction:nil];
}

- (void) loadUdiskData{
    
    IMP_BLOCK_SELF(SysInfoVersionView);
    
    [[RegulusSDK sharedRegulusSDK] GetUpdatePacketFromUdisc:^(BOOL result, NSArray *names, NSError *error)
     {
         
         if (result) {
             
             [block_self updateTable:names];
         }
         else
         {
             [KVNProgress showErrorWithStatus:[error localizedDescription]];
         }
     }];
}

- (void) updateTable:(NSArray*)names{
    
    [self._datas addObjectsFromArray:names];
    
    [_tableView reloadData];
}

@end
