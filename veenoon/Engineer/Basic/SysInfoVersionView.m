//
//  SysInfoVersionView.m
//  veenoon
//
//  Created by 安志良 on 2018/11/11.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "SysInfoVersionView.h"

@interface SysInfoVersionView() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
}
@end


@implementation SysInfoVersionView

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
        
        CGRect rc = CGRectMake(40, 40, self.frame.size.width-80, self.frame.size.height - 70);
        
        _tableView = [[UITableView alloc] initWithFrame:rc style:UITableViewStyleGrouped];
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
    
    return 1;
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
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}

@end
