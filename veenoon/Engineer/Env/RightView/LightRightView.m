//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "LightRightView.h"
#import "ComSettingView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"

@interface LightRightView () <UITableViewDelegate,
UITableViewDataSource, UITextFieldDelegate,
CustomPickerViewDelegate> {
    
    ComSettingView *_com;
    
    UITableView *_tableView;
    
    int _curIndex;
    BOOL _isAdding;
    BOOL _isStudying;
    
    CustomPickerView *_picker;
    
    int _selRow1;
    int _selRow2;
    int _selRow3;
    
    UITextField *_fieldBrand;
    UITextField *_fieldType;
    
    UIView *_footerView;
    
    NSMutableArray *_btns;
    
}
@property (nonatomic, strong) NSMutableArray *_studyItems;
@property (nonatomic, strong) NSMutableArray *_bianzuArrays;
@property (nonatomic, strong) NSMutableDictionary *_value;

@property (nonatomic, strong) NSMutableArray *_coms;
@property (nonatomic, strong) NSMutableArray *_brands;
@property (nonatomic, strong) NSMutableDictionary *_map;

@property (nonatomic, strong) NSDictionary *_selectedBrand;
@property (nonatomic, strong) NSDictionary *_selectedType;
@end


@implementation LightRightView
@synthesize _studyItems;
@synthesize _bianzuArrays;
@synthesize _value;
@synthesize _brands;
@synthesize _map;
@synthesize _coms;

@synthesize _selectedBrand;
@synthesize _selectedType;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RGB(0, 89, 118);
        
        self._value = [NSMutableDictionary dictionary];
        
        _btns = [[NSMutableArray alloc] init];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
        
        
        _curIndex = -1;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-60-180)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self createFooter];
        
        _picker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 100) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"2", @"3"]}];
        
        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        IMP_BLOCK_SELF(LightRightView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        
        _selRow1 = 0;
        _selRow2 = 0;
        _selRow3 = 0;
        
        [self initData];
        
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

- (void)createFooter{
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           CGRectGetMaxY(_tableView.frame),
                                                           self.frame.size.width,
                                                           180)];
    [self addSubview:_footerView];
    _footerView.backgroundColor = M_GREEN_COLOR;
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    UIColor *rectColor = RGB(0, 146, 174);
    
    int top = 40;
    
    for (int index = 0; index < 7; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        scenarioBtn.tag = index;
        [_footerView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string;
        if (index == 6) {
            string = @"全部";
        } else {
            string = [NSString stringWithFormat:@"%d",titleInt];
        }
        
        [scenarioBtn setTitle:string forState:UIControlStateNormal];
        [scenarioBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_btns addObject:scenarioBtn];
    }
}

- (void) initData{
    
    if(self._brands == nil)
    {
        self._brands = [NSMutableArray array];
        self._map = [NSMutableDictionary dictionary];
        self._coms = [NSMutableArray array];
        
        [_coms addObject:@"1"];
        [_coms addObject:@"2"];
        [_coms addObject:@"3"];
        
        [_brands addObject:@{@"title":@"PHILIPS"}];
        [_brands addObject:@{@"title":@"PANSONIC"}];
        [_brands addObject:@{@"title":@"Brand 1"}];
        
        
        
        [_map setObject:@[@{@"title":@"pxx1"},@{@"title":@"pxx2"},@{@"title":@"pxx3"}]
                 forKey:@"PHILIPS"];
        [_map setObject:@[@{@"title":@"paxx1"},@{@"title":@"paxx2"},@{@"title":@"paxx3"}]
                 forKey:@"PANSONIC"];
        [_map setObject:@[@{@"title":@"bxx1"},@{@"title":@"bxx2"},@{@"title":@"bxx3"}]
                 forKey:@"Brand 1"];
        
        self._selectedBrand = [_brands objectAtIndex:0];
        if(_selectedBrand)
        {
            id key = [_selectedBrand objectForKey:@"title"];
            NSArray *types = [_map objectForKey:key];
            self._selectedType = [types objectAtIndex:0];
        }
        
        _fieldBrand = [[UITextField alloc] initWithFrame:CGRectMake(90,
                                                                    7,
                                                                    self.frame.size.width-100,
                                                                    30)];
        _fieldBrand.delegate = self;
        _fieldBrand.returnKeyType = UIReturnKeyDone;
        _fieldBrand.attributedPlaceholder = [[NSAttributedString alloc]
                                             initWithString:@"请输入品牌"
                                             attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.6]}];
        _fieldBrand.backgroundColor = [UIColor clearColor];
        _fieldBrand.textColor = [UIColor whiteColor];
        _fieldBrand.borderStyle = UITextBorderStyleNone;
        _fieldBrand.textAlignment = NSTextAlignmentRight;
        _fieldBrand.font = [UIFont systemFontOfSize:13];
        _fieldBrand.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _fieldType = [[UITextField alloc] initWithFrame:CGRectMake(90,
                                                                   44+7,
                                                                   self.frame.size.width-100,
                                                                   30)];
        _fieldType.delegate = self;
        _fieldType.returnKeyType = UIReturnKeyDone;
        _fieldType.attributedPlaceholder = [[NSAttributedString alloc]
                                            initWithString:@"请输入型号"
                                            attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.6]}];
        _fieldType.backgroundColor = [UIColor clearColor];
        _fieldType.textColor = [UIColor whiteColor];
        _fieldType.borderStyle = UITextBorderStyleNone;
        _fieldType.textAlignment = NSTextAlignmentRight;
        _fieldType.font = [UIFont systemFontOfSize:13];
        _fieldType.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self._studyItems = [NSMutableArray array];
        
        [_studyItems addObject:@{@"name":@"开/关", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"播放", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"暂停", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"上一曲", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"下一曲", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"音量+", @"state":@"已学习"}];
        [_studyItems addObject:@{@"name":@"音量-", @"state":@"已学习"}];
        
        [_tableView reloadData];
    }
    
    
}

- (void) didPickerValue:(NSDictionary *)values{
    
    if(_picker.tag == 1)
    {
        _selRow1 = [[values objectForKey:@"row"] intValue];
    }
    else if(_picker.tag == 2)
    {
        _selRow2 = [[values objectForKey:@"row"] intValue];
        _selRow3 = 0;
        self._selectedBrand = [values objectForKey:@0];
    }
    else if(_picker.tag == 3)
    {
        _selRow3 = [[values objectForKey:@"row"] intValue];
        self._selectedType = [values objectForKey:@0];
    }
    
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
    
    if(_isAdding)
        return 2;
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1)
        return 4;
    
    if(section == 0)
    {
        return [self._bianzuArrays count] + 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(_curIndex == indexPath.row)
        {
            return 144;
        }
    }
    else if(indexPath.section == 1)
    {
        return 34;
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
    
    
    if(indexPath.section == 0)
    {
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
        
        UIImageView *icon = [[UIImageView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 16, 10, 10)];
        icon.image = [UIImage imageNamed:@"remote_video_down.png"];
        [cell.contentView addSubview:icon];
        icon.alpha = 0.8;
        icon.layer.contentsGravity = kCAGravityResizeAspect;
        
        if (indexPath.row == 0) {
            titleL.text = @"编组";
            icon.frame = CGRectMake(CGRectGetMaxX(valueL.frame)-20, 11, 20, 20);
            icon.image = [UIImage imageNamed:@"add_brand_icon.png"];
            
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [cell.contentView addSubview:line];
        if(_curIndex == indexPath.row)
        {
            line.frame = CGRectMake(0, 143, self.frame.size.width, 1);
            
            [cell.contentView addSubview:_picker];
        }
        
        if(_curIndex == 0)
        {
            _picker.tag = 1;
            _picker._pickerDataArray = @[@{@"values":_coms}];
            [_picker selectRow:_selRow1 inComponent:0];
        }
        else if(_curIndex == 1)
        {
            _picker.tag = 2;
            _picker._pickerDataArray = @[@{@"values":_brands}];
            [_picker selectRow:_selRow2 inComponent:0];
        }
        else if(_curIndex == 2)
        {
            if(_selectedBrand)
            {
                _picker.tag = 3;
                id key = [_selectedBrand objectForKey:@"title"];
                _picker._pickerDataArray = @[@{@"values":[_map objectForKey:key]}];
                [_picker selectRow:_selRow3 inComponent:0];
            }
        }
        
    }
    else if(indexPath.section == 1)
    {
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
        
        if(indexPath.row == 1)
        {
            titleL.text = @"电源";
            valueL.text = @"PHILIPS";
            
            if(_selectedBrand)
            {
                valueL.text  = [_selectedBrand objectForKey:@"title"];
            }
        }
        else if(indexPath.row == 2)
        {
            titleL.text = @"选择型号";
            valueL.text = @"XXXXX";
            
            if(_selectedType)
            {
                valueL.text  = [_selectedType objectForKey:@"title"];
            }
        }
        else if(indexPath.row == 3)
        {
            titleL.text = @"红外端口";
            
            if([_coms count])
                valueL.text = [_coms objectAtIndex:_selRow1];
            
        }
        
        cell.backgroundColor = M_GREEN_COLOR;
        
        UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                    7,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        titleL2.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleL2];
        titleL2.font = [UIFont systemFontOfSize:13];
        titleL2.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        UILabel* valueL2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2,
                                                                    7,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        valueL2.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL2];
        valueL2.font = [UIFont systemFontOfSize:13];
        valueL2.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL2.textAlignment = NSTextAlignmentRight;
        
        
        NSDictionary *dic = [_studyItems objectAtIndex:indexPath.row];
        titleL2.text = [dic objectForKey:@"name"];
        valueL2.text = [dic objectForKey:@"state"];
        valueL2.textColor = YELLOW_COLOR;
        
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line2.backgroundColor =  M_GREEN_LINE;
        [cell.contentView addSubview:line2];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
        {
            _curIndex = -1;
            
            //Add
            
            _isAdding = YES;
        }
        else
        {
            if(indexPath.row == _curIndex)
            {
                _curIndex = -1;
            }
            else
            {
                _curIndex = (int)indexPath.row;
                _tableView.scrollEnabled = NO;
            }
        }
        [_tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 0;
    
    int height = 44*3;
    if(_isStudying)
    {
        height = 44*4;
    }
    return height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return nil;
    
    int height = 44*3;
    if(_isStudying)
    {
        height = 44*4;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    header.backgroundColor = M_GREEN_COLOR;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [header addSubview:line];
    
    UILabel* rowL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                              12,
                                                              CGRectGetWidth(self.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    rowL.text = @"品牌";
    
    [header addSubview:_fieldBrand];
    
    line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44+43, self.frame.size.width, 1)];
    line.backgroundColor =  RGB(1, 138, 182);
    [header addSubview:line];
    
    rowL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                     44+12,
                                                     CGRectGetWidth(self.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    rowL.text = @"型号";
    
    [header addSubview:_fieldType];
    
    if(!_isStudying)
    {
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44*2+43, self.frame.size.width, 1)];
        line.backgroundColor =  M_GREEN_LINE;
        [header addSubview:line];
        
        UIButton *btn = [UIButton buttonWithColor:RGB(0, 79, 105)
                                         selColor:nil];
        btn.frame = CGRectMake(0, 44*2+1, CGRectGetWidth(self.frame), 42);
        [header addSubview:btn];
        [btn addTarget:self
                action:@selector(buttonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    }
    
    rowL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                     44*2+12,
                                                     CGRectGetWidth(self.frame)-20, 20)];
    rowL.backgroundColor = [UIColor clearColor];
    [header addSubview:rowL];
    rowL.font = [UIFont systemFontOfSize:13];
    rowL.textColor  = [UIColor whiteColor];
    rowL.text = @"开始学习";
    
    if(_isStudying)
    {
        rowL.textColor  = YELLOW_COLOR;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(70,
                                                                    44*3+12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        [header addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2,
                                                                    44*3+12,
                                                                    CGRectGetWidth(self.frame)/2-70, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [header addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        titleL.text = @"功能";
        valueL.text = @"状态";
    }
    
    
    return header;
}

- (void) buttonAction:(id)sender{
    
    NSString *brand = _fieldBrand.text;
    NSString *type = _fieldType.text;
    
    if([_fieldBrand isFirstResponder])
        [_fieldBrand resignFirstResponder];
    
    if([_fieldType isFirstResponder])
        [_fieldType resignFirstResponder];
    
    if([brand length] && [type length])
    {
        _isStudying = YES;
        _footerView.hidden = NO;
        [_tableView reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"请输入品牌和型号"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
