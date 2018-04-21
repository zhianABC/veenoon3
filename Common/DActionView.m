//
//  DActionView.m
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DActionView.h"
#import "UIButton+Color.h"

@interface DActionView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton    *btnCancel;
}
@property (nonatomic, strong) NSArray *_datas;

@end

@implementation DActionView
@synthesize _datas;
@synthesize _selectIndex;
@synthesize _callback;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        btnCancel = [UIButton buttonWithColor:RGBA(0, 0, 0, 0.3) selColor:nil];
        btnCancel.frame = CGRectMake(0, frame.size.height-50, frame.size.width, 50);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:btnCancel];
        btnCancel.alpha = 0.6;
        [btnCancel setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        [btnCancel addTarget:self
                      action:@selector(cancelAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void) cancelAction:(id)sender{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame),
                                                       CGRectGetWidth(self.frame),
                                                       CGRectGetHeight(self.frame));
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
}

- (void) setSelectDatas:(NSArray *)datas
{
    self._datas = datas;
    int h = (int)[datas count] * 60;
    int max = self.frame.size.height/2;
    if(h > max)
    {
        h = max;
    }
    
    _tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame),
                                  CGRectGetWidth(self.frame),
                                  h);
    
    [UIView animateWithDuration:0.25
                     animations:^{
                        
                         _tableView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - h - 50,
                                                       CGRectGetWidth(self.frame),
                                                       h);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    [_tableView reloadData];
    
}

- (void) dismissView{
    
    [self cancelAction:nil];
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

    return 60;
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
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, self.frame.size.width, 1)];
        line.backgroundColor =  [UIColor colorWithWhite:1.0 alpha:0.3];
        [cell.contentView addSubview:line];
        
        NSDictionary *dic = [_datas objectAtIndex:indexPath.row];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    15,
                                                                    CGRectGetWidth(self.frame)-20, 30)];
        valueL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:20];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentCenter;
        
        valueL.text = [dic objectForKey:@"name"];
        
        if(_selectIndex == indexPath.row)
        {
            UIImageView *round = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            round.backgroundColor = LINE_COLOR;
            round.layer.cornerRadius = 5;
            round.clipsToBounds = YES;
            [cell.contentView addSubview:round];
            
            CGSize s = [valueL.text sizeWithAttributes:@{NSFontAttributeName:valueL.font}];
            round.center = CGPointMake(SCREEN_WIDTH/2 - s.width/2-15, 30);
            
        }

        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if(_callback)
    {
        NSDictionary *dic = [_datas objectAtIndex:indexPath.row];
        
        _callback((int)indexPath.row, [dic objectForKey:@"object"]);
    }
    
    [self dismissView];
}




@end
