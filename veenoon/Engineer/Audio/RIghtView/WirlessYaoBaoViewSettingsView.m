//
//  WirlessHandleSettingsView.m
//  veenoon 无线手持腰包系统
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WirlessYaoBaoViewSettingsView.h"
#import "CustomPickerView.h"
#import "Groups2PickerView.h"
#import "UIButton+Color.h"


@interface WirlessHandleSettingsView () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate>
{
    UITableView *_tableView;
    int _curIndex;
    UIButton *_btnSave;
    
    CustomPickerView *_picker;
    Groups2PickerView *_tpicker;
    
    UIView *_footerView;

}
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableArray *_groupValues;

@property (nonatomic, strong) NSMutableArray *_btns;

@end

@implementation WirlessYaoBaoViewSettingsView
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
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 100) withGrayOrLight:@"picker_player.png"];

        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        IMP_BLOCK_SELF(WirlessYaoBaoViewSettingsView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        _tpicker = [[Groups2PickerView alloc]
                    initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _tpicker._selectColor = YELLOW_COLOR;
        _tpicker._rowNormalColor = [UIColor whiteColor];
        //_tpicker.delegate_ = self;
        //IMP_BLOCK_SELF(WirlessHandleSettingsView);
        _tpicker._selectionBlock = ^(NSDictionary *values)
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
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(_tableView.frame),
                                                               self.frame.size.width,
                                                               160)];
        [self addSubview:_footerView];
        _footerView.backgroundColor = M_GREEN_COLOR;
        
        _numOfChannel = 8;
        [self layoutFooter];
        
        [self initData];
        
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(closeSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionRight;
        
        
        [self addGestureRecognizer:swip];
        
        
    }
    
    return self;
}

- (void) closeSetting{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         self.frame = CGRectMake(SCREEN_WIDTH,
                                                 64, 300, SCREEN_HEIGHT-114);
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

- (void) initData{
    
    self._rows = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    NSMutableArray *dbs = [NSMutableArray array];
    for(int i = 0; i < 80; i++)
    {
        [dbs addObject:[NSString stringWithFormat:@"+%d", i]];
    }
    
    self._groupValues = [NSMutableArray array];
    [_groupValues addObject:@{@"name":@"A", @"subs":@[@"01",@"02",@"03"]}];
    [_groupValues addObject:@{@"name":@"B", @"subs":@[@"04",@"05",@"06"]}];
    [_groupValues addObject:@{@"name":@"C", @"subs":@[@"10",@"20",@"30"]}];
    
    [_rows addObject:@{@"title":@"设备名称",@"values":@[@"D1",@"D2",@"D3"]}];
    [_rows addObject:@{@"title":@"型号规格",@"values":@[@"X1",@"X2",@"X3"]}];
    [_rows addObject:@{@"title":@"自动对频",@"values":@[@"扫描"]}];
    [_rows addObject:@{@"title":@"频率",@"values":@[@"720MHz",@"600MHz"]}];
    [_rows addObject:@{@"title":@"组-通道",@"values":_groupValues}];
    [_rows addObject:@{@"title":@"增益",@"values":dbs}];
    [_rows addObject:@{@"title":@"SQ",@"values":@[@"1",@"2",@"3"]}];
    
    
    [_map setObject:@"扫描" forKey:@2];
    
    
    [_tableView reloadData];
 
    
}

- (void)layoutFooter{
    
    [[_footerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIColor *rectColor = RGB(0, 146, 174);
    
    self._btns = [NSMutableArray array];
    
    int w = 50;
    int sp = 8;
    int y = (160 - w*2 - sp)/2;
    int x = (self.frame.size.width - 4*w - 3*sp)/2;
    for(int i = 0; i < _numOfChannel; i++)
    {
        int col = i%4;
        int xx = x + col*w + col*sp;
        
         if(i && i%4 == 0)
         {
             y+=w;
             y+=sp;
         }
        
        UIButton *btn = [UIButton buttonWithColor:rectColor selColor:nil];
        btn.frame = CGRectMake(xx, y, w, w);
        [_footerView addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1]
             forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
       [btn addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
        
        [_btns addObject:btn];
    }
    
    [self chooseChannelAtTagIndex:0];
  
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
    {
        line.frame = CGRectMake(0, 143, self.frame.size.width, 1);
        
        if(_curIndex == 4)
        {
            _tpicker.tag = _curIndex;
            _tpicker._datas = @[@{@"values":[data objectForKey:@"values"]}];
            
            [cell.contentView addSubview:_tpicker];
            [_tpicker selectRow:0 inComponent:0];
        }
        else if(_curIndex != 2)
        {
            _picker.tag = _curIndex;
            _picker._pickerDataArray = @[@{@"values":[data objectForKey:@"values"]}];
           
            [cell.contentView addSubview:_picker];
            [_picker selectRow:0 inComponent:0];
        }
        
    }

    
    
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
