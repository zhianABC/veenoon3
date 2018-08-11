//
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HandtoHandLineCheckView.h"
#import "UIButton+Color.h"

@interface HandtoHandLineCheckView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    int _curIndex;
}
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableArray *_btns;

@end

@implementation HandtoHandLineCheckView
@synthesize _rows;
@synthesize _btns;

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
        
        _curIndex = -1;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-60-160)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self initData];
        
    }
    
    return self;
}

- (void) initData{
    
    self._rows = [NSMutableArray array];
    
    [_rows addObject:@{@"title":@"1",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"2",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"3",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"4",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"5",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"6",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"7",@"values":@"在线"}];
    [_rows addObject:@{@"title":@"8",@"values":@"在线"}];
    
    
    [_tableView reloadData];
}

- (void) buttonAction:(UIButton*)btn{
    
    [self chooseChannelAtTagIndex:(int)btn.tag];
}

- (void) chooseChannelAtTagIndex:(int)index{
    
    for(UIButton *btn in _btns)
    {
        if(btn.tag == index)
        {
            [btn setTitleColor:YELLOW_COLOR
                      forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
        }
    }
}

- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    _curIndex = -1;
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
}

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_rows count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(_curIndex == indexPath.row)
        {
            return 44;
        }
    }
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
    
    if (indexPath.row == 0) {
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(2,
                                    2,
                                    40, 40);
        [btnBack setTitle:@"返回" forState:UIControlStateNormal];
        [self addSubview:btnBack];
        [btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnBack setTitleColor:YELLOW_COLOR forState:UIControlStateHighlighted];
        btnBack.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        btnBack.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        line.backgroundColor =  TITLE_LINE_COLOR;
        [cell.contentView addSubview:line];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)-35, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        valueL.text = @"线路检查";
        
        [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnBack];
        
        return cell;
    }
    
    NSDictionary *data = [_rows objectAtIndex:indexPath.row - 1];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-35, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    valueL.text = [data objectForKey:@"values"];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [cell.contentView addSubview:line];
    
    titleL.text = [data objectForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int targetIndx = (int)indexPath.row;
    if(targetIndx != 2)
    {
        if(_curIndex == targetIndx)
        {
            _curIndex = -1;
        }
        else
            _curIndex = targetIndx;
        
        [_tableView reloadData];
    }
    
}

- (void) backAction:(id)object {
    [self removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */




@end


