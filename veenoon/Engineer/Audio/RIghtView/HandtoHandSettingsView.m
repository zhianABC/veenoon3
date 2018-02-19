//
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "HandtoHandSettingsView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"
#import "HandtoHandLineCheckView.h"
#import "ComSettingView.h"


@interface HandtoHandSettingsView () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate>
{
    UITableView *_tableView;
    int _curIndex;
    UIButton *_btnSave;
    
    CustomPickerView *_picker;
    ComSettingView *_com;
}
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableDictionary *_groupValues;

@property (nonatomic, strong) NSMutableArray *_btns;

@end

@implementation HandtoHandSettingsView
@synthesize _rows;
@synthesize _map;
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
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        IMP_BLOCK_SELF(HandtoHandSettingsView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
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
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
    }
    
    return self;
}

- (void) switchComSetting{
    
    if([_com superview])
        return;
    
    CGRect rc = _com.frame;
    rc.origin.y = 0-rc.size.height;
    
    _com.frame = rc;
    [self addSubview:_com];
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _com.frame = self.bounds;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

- (void) initData{
    
    self._rows = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    [_rows addObject:@{@"title":@"线路检查",@"values":@[@"D1",@"D2",@"D3"]}];
    [_rows addObject:@{@"title":@"发言模式",@"values":@[@"先进先出"]}];
    [_rows addObject:@{@"title":@"发言人数",@"values":@[@"1"]}];
    [_rows addObject:@{@"title":@"主席数量",@"values":@[@"1",@"2"]}];
    [_rows addObject:@{@"title":@"设备ID",@"values":@[@"1",@"2"]}];
    [_rows addObject:@{@"title":@"摄像机ID",@"values":@[@"1",@"2"]}];
    [_rows addObject:@{@"title":@"摄像机协议",@"values":@[@"VISCA",@"VISCB",@"VISCC"]}];
    [_rows addObject:@{@"title":@"波特率",@"values":@[@"115200",@"2400",@"4800"]}];
    
    
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

- (void) didPickerValue:(NSDictionary *)values{
    
    id key = [NSNumber numberWithInt:(int)_picker.tag];
    
    NSString *obj = [values objectForKey:@0];
    [_map setObject:obj forKey:key];
    
    [_tableView reloadData];
    
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
    
    if(indexPath.row != 0)
    {
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 17, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [cell.contentView addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
    } else {
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 17, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_right.png"];
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
    if(_curIndex == indexPath.row) {
        line.frame = CGRectMake(0, 143, self.frame.size.width, 1);
        
        _picker.tag = _curIndex;
        _picker._pickerDataArray = @[@{@"values":[data objectForKey:@"values"]}];
        
        [cell.contentView addSubview:_picker];
        [_picker selectRow:0 inComponent:0];
        
    }
    
    return cell;
}

- (void)toHandtoHandCheckView {
    HandtoHandLineCheckView *ecp = [[HandtoHandLineCheckView alloc]
                                   initWithFrame:CGRectMake(0,
                                                            0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:ecp];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
    int targetIndx = (int)indexPath.row;
    
    if (targetIndx == 0) {
        [self toHandtoHandCheckView];
        return;
    }
    if (_curIndex == targetIndx) {
        _curIndex = -1;
    } else {
        _curIndex = targetIndx;
    }
    
    [_tableView reloadData];
}

@end

