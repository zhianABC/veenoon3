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
#import "ComSettingView.h"
#import "Groups2PickerView.h"

@interface PinJiePingRightView () <UITableViewDelegate, UITableViewDataSource, CenterCustomerPickerViewDelegate, UITextFieldDelegate, Groups2PickerViewDelegate> {
    
    ComSettingView *_com;
    UITextField *ipTextField;
    
    UIView *_footerView;
    
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
@synthesize _numOfChannel;
@synthesize _map;
@synthesize _mapv;
@synthesize _rows;
@synthesize _groupValues;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(0, 89, 118);
        
        _numOfChannel= 8;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 40, 30)];
        titleL.textColor = [UIColor whiteColor];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.text = @"IP地址";
        
        ipTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+30, 25, self.bounds.size.width - 35 - CGRectGetMaxX(titleL.frame), 30)];
        ipTextField.delegate = self;
        ipTextField.backgroundColor = [UIColor clearColor];
        ipTextField.returnKeyType = UIReturnKeyDone;
        ipTextField.text = @"192.168.1.100";
        ipTextField.textColor = [UIColor whiteColor];
        ipTextField.borderStyle = UITextBorderStyleRoundedRect;
        ipTextField.textAlignment = NSTextAlignmentRight;
        ipTextField.font = [UIFont systemFontOfSize:13];
        ipTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:ipTextField];
        
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
        
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,self.bounds.size.height - 160,
                                                               self.frame.size.width,
                                                               160)];
        [self addSubview:_footerView];
        _footerView.backgroundColor = M_GREEN_COLOR;
        
        
        [self layoutFooter];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
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
    [_groupValues addObject:@{@"name":@"4", @"subs":@[@{@"name":@"01"},@{@"name":@"02"},@{@"name":@"03"}]}];
    [_groupValues addObject:@{@"name":@"8", @"subs":@[@{@"name":@"04"},@{@"name":@"05"},@{@"name":@"06"}]}];
    [_groupValues addObject:@{@"name":@"16", @"subs":@[@{@"name":@"10"},@{@"name":@"20"},@{@"name":@"30"}]}];
    
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
    
}

- (void) didValueChangedWithGroups2Picker:(NSDictionary*)value{
    
    id key = [NSNumber numberWithInt:(int)_tpicker.tag];
    [_map setObject:value forKey:key];
    
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
    line.backgroundColor =  M_GREEN_LINE;
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
        
        UIButton *btn = [UIButton buttonWithColor:rectColor selColor:BLUE_DOWN_COLOR];
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
        
        if (i == 6) {
            [btn setTitle:@"全部"
                 forState:UIControlStateNormal];
            break;
        }
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

@end



