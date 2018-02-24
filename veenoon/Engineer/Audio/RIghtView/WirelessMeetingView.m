//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "WirelessMeetingView.h"
#import "ComSettingView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"
#import "GroupsPickerView.h"
#import "UIImage+Color.h"

@interface WirelessMeetingView () <UITableViewDelegate,
UITableViewDataSource, UITextFieldDelegate,
CustomPickerViewDelegate, GroupsPickerViewDelegate> {
    
    ComSettingView *_com;
    
    UITableView *_tableView;
    
    int _curIndex;
    int _curSectionIndex;
    BOOL _isAdding;
    BOOL _isStudying;
    
    GroupsPickerView *_secsGroup;
    GroupsPickerView *_secsGroup2;
    GroupsPickerView *_secsGroup3;
    
    int _selRowIp;
    int _selRow2;
    int _selRow3;
    
    NSMutableArray *_btns;
    NSMutableArray *_btns2;
    NSMutableArray *_btns3;
    
    BOOL _isPower;
}
@property (nonatomic, strong) NSMutableArray *_studyItems;
@property (nonatomic, strong) NSMutableArray *_bianzuArrays;
@property (nonatomic, strong) NSMutableDictionary *_value;

@property (nonatomic, strong) NSMutableArray *_coms;
@property (nonatomic, strong) NSMutableArray *_brands;
@property (nonatomic, strong) NSMutableArray *_ips;
@property (nonatomic, strong) NSMutableDictionary *_map;

@property (nonatomic, strong) NSDictionary *_selectedSecs;
@property (nonatomic, strong) NSDictionary *_selectedSecs2;
@property (nonatomic, strong) NSDictionary *_selectedSecs3;
@property (nonatomic, strong) NSDictionary *_selectedType;
@end


@implementation WirelessMeetingView
@synthesize _studyItems;
@synthesize _value;
@synthesize _brands;
@synthesize _ips;
@synthesize _map;
@synthesize _coms;

@synthesize _selectedSecs;
@synthesize _selectedSecs2;
@synthesize _selectedSecs3;
@synthesize _selectedType;

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
        
        self._value = [NSMutableDictionary dictionary];
        
        _btns = [[NSMutableArray alloc] init];
        _btns2 = [[NSMutableArray alloc] init];
        _btns3 = [[NSMutableArray alloc] init];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 100)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[ComSettingView alloc] initWithFrame:self.bounds];
        
        
        _curIndex = -1;
        _curSectionIndex = -1;
        
        self._bianzuArrays = [NSMutableArray array];
        
        _isPower = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-60-180)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        _secsGroup = [[GroupsPickerView alloc]
                      initWithFrame:CGRectMake(frame.size.width/2-90, 43, 250, 100) withGrayOrLight:@"picker_player.png"];
        
        _secsGroup._gdatas = @[@[@"00",@"01",@"02"],@[@"00",@"01",@"02"],@[@"00",@"01",@"02"],@[@"00",@"01",@"02"],@[@"00",@"01",@"02"]];
        
        _secsGroup._selectColor = YELLOW_COLOR;
        _secsGroup._rowNormalColor = [UIColor whiteColor];
        _secsGroup.delegate_ = self;
        [_secsGroup selectRow:0 inComponent:0];
        
        IMP_BLOCK_SELF(WirelessMeetingView);
        
        _secsGroup._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerGValue:values];
        };
        
        
        
        _secsGroup2 = [[GroupsPickerView alloc]
                      initWithFrame:CGRectMake(frame.size.width/2-90, 43, 250, 100) withGrayOrLight:@"picker_player.png"];
        
        _secsGroup2._gdatas = @[@[@"03",@"04",@"05"],@[@"03",@"04",@"05"],@[@"03",@"04",@"05"],@[@"03",@"04",@"05"],@[@"03",@"04",@"05"]];
        
        _secsGroup2._selectColor = YELLOW_COLOR;
        _secsGroup2._rowNormalColor = [UIColor whiteColor];
        _secsGroup2.delegate_ = self;
        [_secsGroup2 selectRow:0 inComponent:0];
        
        _secsGroup2._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerGValue2:values];
        };
        
        
        
        _secsGroup3 = [[GroupsPickerView alloc]
                      initWithFrame:CGRectMake(frame.size.width/2-90, 43, 120, 100) withGrayOrLight:@"picker_player.png"];
        
        _secsGroup3._gdatas = @[@[@"06",@"07",@"08"],@[@"06",@"07",@"08"]];
        
        _secsGroup3._selectColor = YELLOW_COLOR;
        _secsGroup3._rowNormalColor = [UIColor whiteColor];
        _secsGroup3.delegate_ = self;
        [_secsGroup3 selectRow:0 inComponent:0];
        
        _secsGroup3._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerGValue3:values];
        };
        
        _selRowIp = 0;
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

- (void) initData {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    titleL.text = @"通道             A         B          C          D         E";
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame)-1,
                                                              self.frame.size.width,
                                                              1)];
    line.backgroundColor =  M_GREEN_LINE;
    [headerView addSubview:line];
    
    _tableView.tableHeaderView = headerView;
    
    if(self._ips == nil) {
        self._ips = [NSMutableArray array];
        
        [_ips addObject:@"192.168.1.10"];
        [_ips addObject:@"192.168.1.11"];
        [_ips addObject:@"192.168.1.12"];
        
    }
    
}


- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    _curSectionIndex = -1;
    
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _curIndex = (int)indexPath.row;
    
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 0;
    
    if(_curSectionIndex == section)
    {
        return 144;
    }
    return 44;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return nil;
    
    int height = 44;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel* rowLT = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               12,
                                                               CGRectGetWidth(self.frame)-20, 20)];
    rowLT.backgroundColor = [UIColor clearColor];
    [header addSubview:rowLT];
    rowLT.font = [UIFont systemFontOfSize:13];
    rowLT.textColor  = [UIColor whiteColor];
    
    if(section == 1) {
        rowLT.text = @"频道";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = header.bounds;
        [header addSubview:btn];
        btn.tag = section;
        [btn addTarget:self
                action:@selector(clickHeader:)
      forControlEvents:UIControlEventTouchUpInside];
        
        int colNumber = 5;
        int space = 5;
        int cellWidth = 40;
        int cellHeight = 28;
        int leftRight = (self.frame.size.width - 4*cellWidth - 3*space)/2;
        UIColor *rectColor = RGB(0, 146, 174);
        
        int top = 8;
        
        for (int index = 0; index < 5; index++) {
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:nil];
            scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            scenarioBtn.clipsToBounds = YES;
            scenarioBtn.layer.cornerRadius = 5;
            scenarioBtn.tag = index;
            [header addSubview:scenarioBtn];
            int titleInt = index + 1+70;
            NSString *string = [NSString stringWithFormat:@"%d",titleInt];
            
            [scenarioBtn setTitle:string forState:UIControlStateNormal];
            scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [_btns addObject:scenarioBtn];
            
            if([_selectedSecs count]) {
                NSString *m1 = [_selectedSecs objectForKey:[NSNumber numberWithInteger:index]];
                if(m1==nil)
                    m1=@"00";
                [scenarioBtn setTitle:m1 forState:UIControlStateNormal];
            }
        }
        
        if(_curSectionIndex == section)
        {
            [header addSubview:_secsGroup];
            
            height = 144;
        }
    } else if(section == 2) {
        rowLT.text = @"音量";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = header.bounds;
        [header addSubview:btn];
        btn.tag = section;
        [btn addTarget:self
                action:@selector(clickHeader:)
      forControlEvents:UIControlEventTouchUpInside];
        
        int colNumber = 5;
        int space = 5;
        int cellWidth = 40;
        int cellHeight = 28;
        int leftRight = (self.frame.size.width - 4*cellWidth - 3*space)/2;
        UIColor *rectColor = RGB(0, 146, 174);
        
        int top = 8;
        
        for (int index = 0; index < 5; index++) {
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:nil];
            scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            scenarioBtn.clipsToBounds = YES;
            scenarioBtn.layer.cornerRadius = 5;
            scenarioBtn.tag = index;
            [header addSubview:scenarioBtn];
            int titleInt = index + 1+10;
            NSString *string = [NSString stringWithFormat:@"%d",titleInt];
            
            [scenarioBtn setTitle:string forState:UIControlStateNormal];
            scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [_btns2 addObject:scenarioBtn];
            
            if([_selectedSecs2 count]) {
                NSString *m1 = [_selectedSecs2 objectForKey:[NSNumber numberWithInteger:index]];
                if(m1==nil)
                    m1=@"00";
                [scenarioBtn setTitle:m1 forState:UIControlStateNormal];
            }
        }
        
        if(_curSectionIndex == section)
        {
            [header addSubview:_secsGroup2];
            
            height = 144;
        }
    }
    else if(section == 3)
    {
        rowLT.text = @"辅助";

        UILabel* rowLT2 = [[UILabel alloc] initWithFrame:CGRectMake(10+50,
                                                                   12,
                                                                   CGRectGetWidth(self.frame)-20, 20)];
        rowLT2.backgroundColor = [UIColor clearColor];
        [header addSubview:rowLT2];
        rowLT2.font = [UIFont systemFontOfSize:13];
        rowLT2.textColor  = [UIColor whiteColor];
        
        rowLT2.text = @"USB";
        
        UILabel* rowLT3 = [[UILabel alloc] initWithFrame:CGRectMake(10+100,
                                                                   12,
                                                                   CGRectGetWidth(self.frame)-20, 20)];
        rowLT3.backgroundColor = [UIColor clearColor];
        [header addSubview:rowLT3];
        rowLT3.font = [UIFont systemFontOfSize:13];
        rowLT3.textColor  = [UIColor whiteColor];
        
        rowLT3.text = @"AUX";
    }
    else if(section == 4)
    {
        rowLT.text = @"音量";
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = header.bounds;
        [header addSubview:btn];
        btn.tag = section;
        [btn addTarget:self
                action:@selector(clickHeader:)
      forControlEvents:UIControlEventTouchUpInside];

        int colNumber = 2;
        int space = 5;
        int cellWidth = 40;
        int cellHeight = 28;
        int leftRight = (self.frame.size.width - 4*cellWidth - 3*space)/2;
        UIColor *rectColor = RGB(0, 146, 174);
        
        int top = 8;
        
        for (int index = 0; index < 2; index++) {
            int row = index/colNumber;
            int col = index%colNumber;
            int startX = col*cellWidth+col*space+leftRight;
            int startY = row*cellHeight+space*row+top;
            
            UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:nil];
            scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
            scenarioBtn.clipsToBounds = YES;
            scenarioBtn.layer.cornerRadius = 5;
            scenarioBtn.tag = index;
            [header addSubview:scenarioBtn];
            int titleInt = index + 1+70;
            NSString *string = [NSString stringWithFormat:@"%d",titleInt];
            
            [scenarioBtn setTitle:string forState:UIControlStateNormal];
            scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [_btns3 addObject:scenarioBtn];
            
            if([_selectedSecs3 count]) {
                NSString *m1 = [_selectedSecs3 objectForKey:[NSNumber numberWithInteger:index]];
                if(m1==nil)
                    m1=@"00";
                [scenarioBtn setTitle:m1 forState:UIControlStateNormal];
            }
        }
        if(_curSectionIndex == section)
        {
            [header addSubview:_secsGroup3];
            
            height = 144;
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, height-1, self.frame.size.width, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [header addSubview:line];
    
    return header;
}

- (void) clickHeader:(UIButton*)sender{
    
    _curSectionIndex = (int)sender.tag;
    
    [_tableView reloadData];
}

- (void) changePowerSwitch:(UISwitch*)swit{
    
    _isPower = swit.on;
    
    //[_tableView reloadData];
}

- (void) didPickerGValue:(NSDictionary *)values{
    
    _curSectionIndex = -1;
    
    self._selectedSecs = values;
    
    [_tableView reloadData];
    
}

- (void) didPickerGValue2:(NSDictionary *)values{
    
    _curSectionIndex = -1;
    
    self._selectedSecs2 = values;
    
    [_tableView reloadData];
    
}

- (void) didPickerGValue3:(NSDictionary *)values{
    
    _curSectionIndex = -1;
    
    self._selectedSecs3 = values;
    
    [_tableView reloadData];
    
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
