//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "PinJiePingRightView.h"
#import "UIButton+Color.h"
#import "CenterCustomerPickerView.h"
#import "Groups2PickerView.h"
#import "VPinJieSet.h"
#import "EngineerVideoPinJieViewCtrl.h"

@interface PinJiePingRightView () <UITableViewDelegate, UITableViewDataSource, CenterCustomerPickerViewDelegate, UITextFieldDelegate, Groups2PickerViewDelegate, EngineerVideoPinJieViewDelegate> {
    
    UITableView *_tableView;
    
    int _curIndex;
    
    CenterCustomerPickerView *_picker;
    Groups2PickerView *_tpicker;
}
@property (nonatomic, strong) NSMutableArray *_btns;
@property (nonatomic) int _numOfChannel;
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableDictionary *_map;
@property (nonatomic, strong) NSMutableDictionary *_mapv;
@property (nonatomic, strong) NSMutableArray *_groupValues;

@end

@implementation PinJiePingRightView
@synthesize _btns;
@synthesize _map;
@synthesize _mapv;
@synthesize _rows;
@synthesize _groupValues;
@synthesize _currentObj;
@synthesize _numOfDevice;
@synthesize _callback;
@synthesize _curentDeviceIndex;
@synthesize delegate_;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
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
        
        _picker = [[CenterCustomerPickerView alloc]
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 120) ];
        
        [_picker removeArray];
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        
        
        [self initData];
        
        _tpicker = [[Groups2PickerView alloc]
                    initWithFrame:CGRectMake(frame.size.width/2-125, 43, 250, 120) withGrayOrLight:@"picker_player.png"];
        
        
        _tpicker._selectColor = YELLOW_COLOR;
        _tpicker._rowNormalColor = [UIColor whiteColor];
        _tpicker.delegate_ = self;
        
        
        
       
    }
    
    return self;
}

- (void) initData{
    
    self._rows = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    self._mapv = [NSMutableDictionary dictionary];
    
    NSMutableArray *dbs = [NSMutableArray array];
    for(int i = 0; i < 80; i++)
    {
        [dbs addObject:[NSString stringWithFormat:@"+%d", i]];
    }
    
    self._groupValues = [NSMutableArray array];

    
    [_groupValues addObject:@{@"name":@"01", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"02", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"03", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"04", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"05", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"06", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"07", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"08", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"09", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"10", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"11", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"12", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"13", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"14", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"15", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    [_groupValues addObject:@{@"name":@"16", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"},@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"},@{@"name":@"07"},@{@"name":@"08"},@{@"name":@"09"},@{@"name":@"10"},@{@"name":@"11"},@{@"name":@"12"},@{@"name":@"13"},@{@"name":@"14"},@{@"name":@"15"},@{@"name":@"16"}]}];
    
    
    [_rows addObject:@{@"title":@"分频模式",@"values":_groupValues}];
    [_rows addObject:@{@"title":@"调用场景",@"values":@[@"场景一",@"场景二",@"场景三"]}];
    [_rows addObject:@{@"title":@"显示分辨率",@"values":@[@"1080*768",@"1920*1080",@"800*600"]}];
    
    
//    [_map setObject:@"1920*1080" forKey:@2];
//    [_map setObject:@"场景一" forKey:@1];
//    [_map setObject:@"竖8，横12" forKey:@0];
    
    [_tableView reloadData];
    
    
}

- (void) didChangedPickerValue:(NSDictionary*)value{
    
    id key = [NSNumber numberWithInt:(int)_picker.tag];
    
    NSDictionary *dic = [value objectForKey:@0];
    [_map setObject:dic forKey:key];
    
    NSLog(@"dddddd");
}

- (void) didValueChangedWithGroups2Picker:(NSDictionary*)value{
    
    id key = [NSNumber numberWithInt:(int)_tpicker.tag];
    [_map setObject:value forKey:key];
    
    NSDictionary *firstDic = [value objectForKey:[NSNumber numberWithInt:0]];
    NSDictionary *secondDic = [value objectForKey:[NSNumber numberWithInt:1] ];
    
    NSDictionary *firstValueDic = [firstDic objectForKey:@"value"];
    NSDictionary *secValueDic = [secondDic objectForKey:@"value"];
    
    NSString *firstValue = [firstValueDic objectForKey:@"name"];
    NSString *secValue = [secValueDic objectForKey:@"name"];
    
    int row = [firstValue intValue];
    int column = [secValue intValue];
    
    if(delegate_ && [delegate_ respondsToSelector:@selector(didEndEditCell:withColumn:)])
    {
        [delegate_ didEndEditCell:row withColumn:column];
    }
}
#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(_curIndex == indexPath.row)
        {
            return 164;
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
    titleL.text = [data objectForKey:@"title"];
    
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-35, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    
    id v = [_map objectForKey:[NSNumber numberWithInt:(int)indexPath.row]];
    if([v isKindOfClass:[NSString class]])
    {
        valueL.text = v;
    }
    else
    {
        valueL.text = [v objectForKey:@"title"];
    }
    
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 17, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [cell.contentView addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [cell.contentView addSubview:line];
    
    if(_curIndex == indexPath.row) {
        
        line.frame = CGRectMake(0, 163, self.frame.size.width, 1);
        
        if(_curIndex == 0) {
            
            _tpicker.tag = _curIndex;
            _tpicker._datas = [data objectForKey:@"values"];
            
            [cell.contentView addSubview:_tpicker];
            
            id key = [NSNumber numberWithInt:_curIndex];
            NSDictionary *dic = [_map objectForKey:key];
            int row1 = 0;
            int row2 = 0;
            if(dic)
            {
                NSDictionary *col1 = [dic objectForKey:[NSNumber numberWithInt:0]];
                if(col1)
                {
                    row1 = [[col1 objectForKey:@"index"] intValue];
                }
                NSDictionary *col2 = [dic objectForKey:[NSNumber numberWithInt:1]];
                if(col2)
                {
                    row2 = [[col2 objectForKey:@"index"] intValue];
                }
            }
            
            [_tpicker selectRows:@[[NSNumber numberWithInt:row1],
                                   [NSNumber numberWithInt:row2]]];
            
        } else if(_curIndex == 1) {
            
            _picker.tag = _curIndex;
            _picker._pickerDataArray = @[@{@"values":[data objectForKey:@"values"]}];
            
            [cell.contentView addSubview:_picker];
           
            id key = [NSNumber numberWithInt:_curIndex];
            NSDictionary *dic = [_map objectForKey:key];
            
            int row = 0;
            if(dic)
            {
                row = [[dic objectForKey:@"index"] intValue];
            }
            
            [_picker selectRow:row inComponent:0];
            
            
        } else if (_curIndex == 2) {
            
            _picker.tag = _curIndex;
            _picker._pickerDataArray = @[@{@"values":[data objectForKey:@"values"]}];
            
            [cell.contentView addSubview:_picker];
           
            id key = [NSNumber numberWithInt:_curIndex];
            NSDictionary *dic = [_map objectForKey:key];
            
            int row = 0;
            if(dic)
            {
                row = [[dic objectForKey:@"index"] intValue];
            }
            
            [_picker selectRow:row inComponent:0];
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int targetIndx = (int)indexPath.row;
    
    if(_curIndex == targetIndx)
        _curIndex = -1;
    else
        _curIndex = targetIndx;
    
    [_tableView reloadData];
}



-(void) refreshView:(VPinJieSet*) vPinJieSet {
    self._currentObj = vPinJieSet;
    
    self._curentDeviceIndex = _currentObj._index;
    [self chooseChannelAtTagIndex:_curentDeviceIndex];
    
    
}

- (void) buttonAction:(UIButton*)btn{
    
    [self chooseChannelAtTagIndex:(int)btn.tag];
    
    int idx = (int)btn.tag;
    
    if(_callback) {
        _callback(idx);
    }
}

- (void) chooseChannelAtTagIndex:(int)index{
    
    for(UIButton *btn in _btns)
    {
        if(btn.tag == index)
        {
            [btn setTitleColor:YELLOW_COLOR
                      forState:UIControlStateNormal];
            [btn setSelected:YES];
        }
        else
        {
            [btn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
            [btn setSelected:NO];
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //_curIndex = (int)textField.tag;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end



