//
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HandtoHandLineCheckView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"

@interface HandtoHandLineCheckView () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate>
{
    UITableView *_tableView;
    int _curIndex;
    UIButton *_btnSave;
}
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableDictionary *_groupValues;

@property (nonatomic, strong) NSMutableArray *_btns;

@end

@implementation HandtoHandLineCheckView
@synthesize _map;
@synthesize _rows;
@synthesize _groupValues;
@synthesize _btns;
@synthesize _numOfChannel;

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(0, 89, 118);
        
        _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSave.frame = CGRectMake(frame.size.width-90,
                                    20,
                                    70, 40);
        [_btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [self addSubview:_btnSave];
        [_btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnSave.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        _btnSave.titleLabel.font = [UIFont systemFontOfSize:14];
        
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
        
        _numOfChannel = 8;
        
        [self initData];
        
    }
    
    return self;
}

- (void) initData{
    
    self._rows = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    NSMutableArray *dbs = [NSMutableArray array];
    for(int i = 0; i < 80; i++)
    {
        [dbs addObject:[NSString stringWithFormat:@"+%d", i]];
    }
    
    self._groupValues = [NSMutableDictionary dictionary];
    [_groupValues setObject:@[@"01",@"02",@"03"] forKey:@"A"];
    [_groupValues setObject:@[@"04",@"05",@"06"] forKey:@"B"];
    [_groupValues setObject:@[@"10",@"20",@"30"] forKey:@"C"];
    
    [_rows addObject:@{@"title":@"1",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"2",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"3",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"4",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"5",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"6",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"7",@"values":@[@"在线"]}];
    [_rows addObject:@{@"title":@"8",@"values":@[@"在线"]}];
    
    [_map setObject:@"扫描" forKey:@2];
    
    
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
    
    return [_rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(_curIndex == indexPath.row)
        {
            return 144;
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
    
    
    NSDictionary *data = [_rows objectAtIndex:indexPath.row];
    
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
    
    if(indexPath.row != 2)
    {
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 17, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [cell.contentView addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
    }
    
    titleL.text = [data objectForKey:@"title"];
    
    id v = [_map objectForKey:[NSNumber numberWithInt:(int)indexPath.row]];
    if([v isKindOfClass:[NSString class]])
    {
        valueL.text = v;
    }
    else
    {
        valueL.text = [v objectForKey:@"title"];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [cell.contentView addSubview:line];
    if(_curIndex == indexPath.row)
    
    
    
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */




@end


