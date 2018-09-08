//
//  MixVoiceSettingsView.m
//  veenoon 混音
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "MixVoiceSettingsView.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "AudioEMix.h"

@interface MixVoiceSettingsView () <UITableViewDelegate, UITableViewDataSource,CustomPickerViewDelegate, UITextFieldDelegate>
{
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    
    UIView *_yuyinjiliView;
    UIView *_biaozhunfayanView;
    UIView *_yinpinchuliView;
    UIView *_shexiangzhuizongView;
    
    UIButton *_shedingzhuxiBtn;
    UIButton *_fayanrenshuBtn;
    UIButton *_shexiangxieyiBtn;
    CustomPickerView *_picker;
    UIButton *biaozhunfayanBtn;
    
    UITableView *_tableView;

    
    NSString *_zhuxiDaibiao;
}
@property (nonatomic, strong) NSMutableArray *_btns;
@property (nonatomic, strong) UIButton *_selectedBtn;
@end

@implementation MixVoiceSettingsView
@synthesize delegate_;
@synthesize _btns;
@synthesize _currentObj;
@synthesize _selectedBtn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withAudioMixSet:(AudioEMix*) audioEMix
{
    self._currentObj = audioEMix;
    
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
        
        _btns = [[NSMutableArray alloc] init];
        
        self._selectedBtn = nil;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   60,
                                                                   frame.size.width,
                                                                   frame.size.height-400)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [self createYuYinJiLiView];
        [self createBiaoZhunFaYanView];
        [self createShexiangzhuizongView];
    }
    
    return self;
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

#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
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
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-30, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    if (indexPath.row == 0) {
        titleL.text = @"语音激励";
    } else if (indexPath.row == 1) {
        titleL.text = @"标准发言";
    } else if (indexPath.row == 2) {
        titleL.text = audio_process_name;
    } else {
        titleL.text = @"摄像追踪";
    }
    
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame)+5, 17, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_right.png"];
    [cell.contentView addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int targetIndx = (int)indexPath.row;
    
    if (targetIndx == 0) {
        [self yuyinjiliAction:nil];
    } else if (targetIndx == 1) {
        [self biaozhunfayanAction:nil];
    } else if (targetIndx == 2) {
        [self yinpinchuliAction:nil];
    } else {
        [self shexiangzhuizongAction:nil];
    }
}


- (void) yuyinjiliAction:(id)sender{
    _shexiangzhuizongView.hidden=YES;
    _biaozhunfayanView.hidden=YES;
    _yuyinjiliView.hidden=NO;
    
    // control yuyinjili
    [_currentObj._proxyObj controlWorkMode:@"语音激励"];
}
- (void) biaozhunfayanAction:(id)sender{
    _shexiangzhuizongView.hidden=YES;
    _yuyinjiliView.hidden=YES;
    _biaozhunfayanView.hidden=NO;
    
    // control biaozhunfayan
    [_currentObj._proxyObj controlWorkMode:@"标准发言"];
    
    NSString *isBiaoZhunFaYan = _currentObj._proxyObj._workMode;
    if ([@"标准发言" isEqualToString:isBiaoZhunFaYan]) {
        biaozhunfayanBtn.selected = YES;
        [biaozhunfayanBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
        [biaozhunfayanBtn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    } else {
        biaozhunfayanBtn.selected = NO;
        [biaozhunfayanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [biaozhunfayanBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
    }
}
- (void) yinpinchuliAction:(id)sender{
    
    if([delegate_ respondsToSelector:@selector(didSelectButtonAction:)]){
        [delegate_ didSelectButtonAction:btn3.titleLabel.text];
    }
}
- (void) shexiangzhuizongAction:(id)sender{
    _biaozhunfayanView.hidden=YES;
    _yuyinjiliView.hidden=YES;
    _shexiangzhuizongView.hidden=NO;
}

- (void) createShexiangzhuizongView {
    _shexiangzhuizongView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-150, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_shexiangzhuizongView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, _shexiangzhuizongView.frame.size.width, 20)];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"摄像机协议";
    titleL.textColor = [UIColor whiteColor];
    [_shexiangzhuizongView addSubview:titleL];
    
    int x = 70;
    _shexiangxieyiBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _shexiangxieyiBtn.frame = CGRectMake(x, CGRectGetMaxY(titleL.frame) + 30, self.frame.size.width-2*x, 25);
    _shexiangxieyiBtn.clipsToBounds = YES;
    _shexiangxieyiBtn.layer.cornerRadius = 5;
    [_shexiangzhuizongView addSubview:_shexiangxieyiBtn];
    [_shexiangxieyiBtn addTarget:self action:@selector(shexiangxieyiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shexiangxieyiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    _picker = [[CustomPickerView alloc]
               initWithFrame:CGRectMake(_shexiangzhuizongView.frame.size.width/2-100, 170, 200, 120) withGrayOrLight:@"picker_player.png"];
    
    NSMutableArray *dataArray = [_currentObj._proxyObj getCameraPol];
    if (dataArray) {
        _picker._pickerDataArray = @[@{@"values":dataArray}];
    } else {
        NSArray *dummyDataArray = [NSArray arrayWithObjects:@"PELCOP", @"PELCOD", @"VISCA", nil];
        _picker._pickerDataArray = @[@{@"values":dummyDataArray}];
    }
    
    _picker._selectColor = YELLOW_COLOR;
    _picker._rowNormalColor = [UIColor whiteColor];
    _picker.delegate_ = self;
    _picker.tag = 1;
    [_picker selectRow:0 inComponent:0];
    IMP_BLOCK_SELF(MixVoiceSettingsView);
    _picker._selectionBlock = ^(NSDictionary *values)
    {
        [block_self didPickerValue:values];
    };
    
    [_shexiangzhuizongView addSubview:_picker];
    _picker.hidden = YES;
    
    _shexiangzhuizongView.hidden=YES;
}
-(void) shexiangxieyiAction:(id)sender {
    if (_picker.hidden) {
        _picker.hidden = NO;
    } else {
        _picker.hidden=YES;
    }
}

- (void) didPickerValue:(NSDictionary *)values{
    
    if(_picker.tag == 1)
    {
        [_shexiangxieyiBtn setTitle:_picker._unitString forState:UIControlStateNormal];
        
        [_currentObj._proxyObj controlDeviceCameraPol:_picker._unitString];
    }
    
    _picker.hidden = YES;
    
}

- (void) createYuYinJiLiView {
    
    _yuyinjiliView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              self.frame.size.height/2-100,
                                                              self.frame.size.width,
                                                              self.frame.size.height/2-1)];
    
    [self addSubview:_yuyinjiliView];
    
    int bw = 120;
    int top = 40;
    int gap = 5;
    int x = self.frame.size.width/2 - gap/2 - bw;
    _shedingzhuxiBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    _shedingzhuxiBtn.frame = CGRectMake(x, top, bw, 25);
    _shedingzhuxiBtn.clipsToBounds = YES;
    _shedingzhuxiBtn.layer.cornerRadius = 5;
    [_yuyinjiliView addSubview:_shedingzhuxiBtn];
    [_shedingzhuxiBtn setTitle:@"设定主席" forState:UIControlStateNormal];
    [_shedingzhuxiBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shedingzhuxiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    x = self.frame.size.width/2 + gap/2;
    _fayanrenshuBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    _fayanrenshuBtn.frame = CGRectMake(x, top, bw, 25);
    _fayanrenshuBtn.clipsToBounds = YES;
    _fayanrenshuBtn.layer.cornerRadius = 5;
    [_yuyinjiliView addSubview:_fayanrenshuBtn];
    [_fayanrenshuBtn setTitle:@"设定代表" forState:UIControlStateNormal];
    [_fayanrenshuBtn addTarget:self action:@selector(fayanrenshuAction:) forControlEvents:UIControlEventTouchUpInside];
    _fayanrenshuBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _yuyinjiliView.hidden = YES;
}

- (void) createBiaoZhunFaYanView {
    _biaozhunfayanView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-100, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_biaozhunfayanView];
    
    biaozhunfayanBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
    biaozhunfayanBtn.frame = CGRectMake(_biaozhunfayanView.frame.size.width/2-35, _biaozhunfayanView.frame.size.height/2 -10, 70, 30);
    biaozhunfayanBtn.clipsToBounds = YES;
    biaozhunfayanBtn.layer.cornerRadius = 5;
    [_biaozhunfayanView addSubview:biaozhunfayanBtn];
    [biaozhunfayanBtn setTitle:@"启用" forState:UIControlStateNormal];
    [biaozhunfayanBtn addTarget:self action:@selector(biaozhunfayanAction:) forControlEvents:UIControlEventTouchUpInside];
    biaozhunfayanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _biaozhunfayanView.hidden=YES;
}

- (void) shedingzhuxiAction:(id)sender {
    
    [[_yuyinjiliView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_shedingzhuxiBtn setSelected:YES];
    [_fayanrenshuBtn setSelected:NO];
    
    [_shedingzhuxiBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [_fayanrenshuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _zhuxiDaibiao = @"设定主席";
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    
    NSMutableDictionary *minMaxDic = [_currentObj._proxyObj getPriorityMinMax];
    int min = [[minMaxDic objectForKey:@"min"] intValue];
    int max = [[minMaxDic objectForKey:@"max"] intValue];
    
    int count = (max - min) + 1;
    
    for (int index = 0; index < count; index++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_BL_COLOR];
        btn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:btn];
        
        NSString *string = [NSString stringWithFormat:@"%d",min];
        [btn setTitle:string forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(setPriorityAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        if(_currentObj._proxyObj._fayanPriority == min)
        {
            self._selectedBtn = btn;
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                      forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        
        min++;
        
        btn.tag = min;
    }
}
- (void) setPriorityAction:(id)sender {
    
    UIButton *btn = (UIButton*) sender;
    NSString *numberStr = btn.titleLabel.text;
    if (_selectedBtn == nil) {
        
        [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                  forState:UIControlStateNormal];
        [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    }
    else
    {
        if (_selectedBtn.tag == btn.tag) {
            
        }
        else
        {
            [_selectedBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
            [_selectedBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                      forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
    }
    
    self._selectedBtn = btn;
    
    int numberInt = [numberStr intValue];
    [_currentObj._proxyObj controlFayanPriority:numberInt
                                       withType:_zhuxiDaibiao];
}
- (void) fayanrenshuAction:(id)sender{
    
    [[_yuyinjiliView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_shedingzhuxiBtn setSelected:NO];
    [_fayanrenshuBtn setSelected:YES];
    [_fayanrenshuBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [_shedingzhuxiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _zhuxiDaibiao = @"设定代表";
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    
    NSMutableDictionary *minMaxDic = [_currentObj._proxyObj getPriorityMinMax];
    int min = [[minMaxDic objectForKey:@"min"] intValue];
    int max = [[minMaxDic objectForKey:@"max"] intValue];
    
    int count = (max - min) + 1;
    
    for (int index = 0; index < count; index++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR
                                         selColor:NEW_ER_BUTTON_BL_COLOR];
        btn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        btn.clipsToBounds = YES;
        btn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:btn];
        
        NSString *string = [NSString stringWithFormat:@"%d", min];
        [btn setTitle:string forState:UIControlStateNormal];
        [btn addTarget:self
                        action:@selector(setDaiBiaoAction:)
              forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        min++;
        
        if(_currentObj._proxyObj._numberOfDaiBiao == min)
        {
            self._selectedBtn = btn;
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                      forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
        
        btn.tag = min;
    }
}

- (void) setDaiBiaoAction:(id)sender {
    
    UIButton *btn = (UIButton*) sender;
    NSString *numberStr = btn.titleLabel.text;
    if (_selectedBtn == nil) {
        
        [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                  forState:UIControlStateNormal];
        [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    }
    else
    {
        if (_selectedBtn.tag == btn.tag) {
            
        }
        else
        {
            [_selectedBtn setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
            [_selectedBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR];
            [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR
                      forState:UIControlStateNormal];
            [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        }
    }
    
    self._selectedBtn = btn;
    
    int numberInt = [numberStr intValue];
    [_currentObj._proxyObj controlFayanPriority:numberInt
                                       withType:_zhuxiDaibiao];
}

@end
