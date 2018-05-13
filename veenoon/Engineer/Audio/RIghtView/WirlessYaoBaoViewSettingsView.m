//
//  WirlessHandleSettingsView.m
//  veenoon 无线手持腰包系统
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WirlessYaoBaoViewSettingsView.h"
#import "CenterCustomerPickerView.h"
#import "Groups2PickerView.h"
#import "UIButton+Color.h"
#import "ComSettingView.h"
#import "AudioEWirlessMike.h"

@interface WirlessYaoBaoViewSettingsView () <UITableViewDelegate, UITableViewDataSource, CenterCustomerPickerViewDelegate, Groups2PickerViewDelegate, UITextFieldDelegate>
{
    UITableView *_tableView;
    int _curIndex;
    UIButton *_btnSave;
    
    CenterCustomerPickerView *_picker;
    Groups2PickerView *_tpicker;
}
@property (nonatomic, strong) NSMutableArray *_rows;
@property (nonatomic, strong) NSMutableDictionary *_map;

@property (nonatomic, strong) NSMutableArray *_btns;

@end

@implementation WirlessYaoBaoViewSettingsView
@synthesize _map;
@synthesize _rows;
@synthesize _btns;
@synthesize _numOfDevice;
@synthesize _audioMike;
@synthesize _curentDeviceIndex;
@synthesize _callback;

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = BLACK_COLOR;
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, frame.size.width, 1)];
        line.backgroundColor = TITLE_LINE_COLOR;
        [self addSubview:line];
        
        _curIndex = -1;
        
        _picker = [[CenterCustomerPickerView alloc]
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 120)];

        [_picker removeArray];
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
       
        
        _tpicker = [[Groups2PickerView alloc]
                    initWithFrame:CGRectMake(frame.size.width/2-125, 43, 250, 120) withGrayOrLight:@"picker_player.png"];
        
        
        _tpicker._selectColor = YELLOW_COLOR;
        _tpicker._rowNormalColor = [UIColor whiteColor];
        _tpicker.delegate_ = self;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-60-160)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    
    }
    
    return self;
}

- (void) showData {
    self._rows = [NSMutableArray array];
    self._map = [NSMutableDictionary dictionary];
    
    [_rows addObject:@{@"title":@"设备名称", @"value":_audioMike._brand}];
    [_rows addObject:@{@"title":@"型号规格", @"value":_audioMike._type}];
    [_rows addObject:@{@"title":@"自动对频",@"value":@"扫描"}];
    [_rows addObject:@{@"title":@"频率",@"values":_audioMike._freqops}];
    [_rows addObject:@{@"title":@"组-通道",@"values":_audioMike._groups}];
    [_rows addObject:@{@"title":@"增益",@"values":_audioMike._dbs}];
    [_rows addObject:@{@"title":@"SQ",@"values":_audioMike._sq}];
    
    
    [_map setObject:@"扫描" forKey:@2];

    //恢复UI数据
    for(int i = 0; i < [_audioMike._freqops count]; i++)
    {
        NSString *v = [_audioMike._freqops objectAtIndex:i];
        
        if([v isEqualToString:_audioMike._freqVal])
        {
            [_map setObject:@{@"index":[NSNumber numberWithInt:i],
                              @"value":v} forKey:@3];
        }
    }
    
    for(int i = 0; i < [_audioMike._dbs count]; i++)
    {
        NSString *v = [_audioMike._dbs objectAtIndex:i];
        
        if([v isEqualToString:_audioMike._dbVal])
        {
            [_map setObject:@{@"index":[NSNumber numberWithInt:i],
                              @"value":v} forKey:@5];
        }
    }
    
    for(int i = 0; i < [_audioMike._sq count]; i++)
    {
        NSString *v = [_audioMike._sq objectAtIndex:i];
        
        if([v isEqualToString:_audioMike._sqVal])
        {
            [_map setObject:@{@"index":[NSNumber numberWithInt:i],
                              @"value":v} forKey:@6];
        }
    }
    
    [_map setObject:_audioMike._groupVal forKey:@4];
    
    self._curentDeviceIndex = _audioMike._index;
    
    [_tableView reloadData];
}

- (void) saveCurrentSetting{
    
    NSDictionary *dic = [_map objectForKey:@3];
    if(dic)
    {
        _audioMike._freqVal = [dic objectForKey:@"value"];
    }
    dic = [_map objectForKey:@6];
    if(dic)
    {
        _audioMike._sqVal = [dic objectForKey:@"value"];
    }
    
    dic = [_map objectForKey:@5];
    if(dic)
    {
        _audioMike._dbVal = [dic objectForKey:@"value"];
    }
    //组-通
    dic = [_map objectForKey:@4];
    if(dic)
    {
       _audioMike._groupVal = dic;
        
    }
}



- (void) didChangedPickerValue:(NSDictionary*)value{
    
    id key = [NSNumber numberWithInt:(int)_picker.tag];
    
    NSDictionary *dic = [value objectForKey:@0];
    [_map setObject:dic forKey:key];

    [_tableView reloadData];
    
    //实时保存到内存
    [self saveCurrentSetting];
}
- (void) didValueChangedWithGroups2Picker:(NSDictionary*)value{
    
    id key = [NSNumber numberWithInt:(int)_tpicker.tag];

    [_map setObject:value forKey:key];

    [_tableView reloadData];
    
    //实时保存到内存
    [self saveCurrentSetting];
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
        if(indexPath.row > 2 && _curIndex == indexPath.row)
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
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-35, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    
    if(indexPath.row > 2)
    {
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 17, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [cell.contentView addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
    }
    
    titleL.text = [data objectForKey:@"title"];
    if([data objectForKey:@"value"])
    {
        //展示的数据
        valueL.text = [data objectForKey:@"value"];
    }
    else
    {
        //设置的新数据
        id v = [_map objectForKey:[NSNumber numberWithInt:(int)indexPath.row]];
        if([v isKindOfClass:[NSString class]])
        {
            valueL.text = v;
        }
        else
        {
            if([v isKindOfClass:[NSDictionary class]] && [v count] == 2)
            {
                NSString *value = [v objectForKey:@"value"];
                if(value)//单组选择
                {
                    valueL.text = value;
                }
                else//双组选择
                {
                    NSDictionary *g0 = [[v objectForKey:@0] objectForKey:@"value"];
                    NSDictionary *g1 = [[v objectForKey:@1] objectForKey:@"value"];
                    if(g0 && g1)
                    {
                        valueL.text = [NSString stringWithFormat:@"%@-%@",
                                       [g0 objectForKey:@"name"],
                                       [g1 objectForKey:@"name"]];
                    }
                }
            }
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [cell.contentView addSubview:line];
    if(_curIndex == indexPath.row)
    {
        line.frame = CGRectMake(0, 163, self.frame.size.width, 1);
        
        if(_curIndex == 4)
        {
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
            
        }
        else if(_curIndex > 2)
        {
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
    if(targetIndx > 2)
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
