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
    
    int shedingzhuxiNumber;
    int fayanrenshuNumber;
    
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *_btns;
@property (nonatomic) int _numOfChannel;
@end

@implementation MixVoiceSettingsView
@synthesize delegate_;
@synthesize _btns;
@synthesize _numOfChannel;
@synthesize _currentObj;

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
        self.backgroundColor = BLACK_COLOR;
        
        shedingzhuxiNumber = 12;
        fayanrenshuNumber = 5;
        
        _btns = [[NSMutableArray alloc] init];
        self._numOfChannel = 8;
        
        
        
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
}
- (void) biaozhunfayanAction:(id)sender{
    _shexiangzhuizongView.hidden=YES;
    _yuyinjiliView.hidden=YES;
    _biaozhunfayanView.hidden=NO;
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
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, _shexiangzhuizongView.frame.size.width, 20)];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"摄像机协议";
    titleL.textColor = [UIColor whiteColor];
    [_shexiangzhuizongView addSubview:titleL];
    
    int x = 70;
    _shexiangxieyiBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
    _shexiangxieyiBtn.frame = CGRectMake(x, CGRectGetMaxY(titleL.frame) + 10, self.frame.size.width-2*x, 25);
    _shexiangxieyiBtn.clipsToBounds = YES;
    _shexiangxieyiBtn.layer.cornerRadius = 5;
    [_shexiangzhuizongView addSubview:_shexiangxieyiBtn];
    [_shexiangxieyiBtn addTarget:self action:@selector(shexiangxieyiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shexiangxieyiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    _picker = [[CustomPickerView alloc]
               initWithFrame:CGRectMake(_shexiangzhuizongView.frame.size.width/2-100, 130, 200, 120) withGrayOrLight:@"picker_player.png"];
    
    NSMutableArray *dataArray = [_currentObj._proxyObj getCameraPol];
    _picker._pickerDataArray = @[@{@"values":dataArray}];
    
    
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
    }
    
    _picker.hidden = YES;
    
}

- (void) createYuYinJiLiView {
    _yuyinjiliView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-100, self.frame.size.width, self.frame.size.height/2-1)];
    
    [self addSubview:_yuyinjiliView];
    
    int bw = 120;
    int top = 40;
    int gap = 5;
    int x = self.frame.size.width/2 - gap/2 - bw;
    _shedingzhuxiBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:YELLOW_COLOR];
    _shedingzhuxiBtn.frame = CGRectMake(x, top, bw, 25);
    _shedingzhuxiBtn.clipsToBounds = YES;
    _shedingzhuxiBtn.layer.cornerRadius = 5;
    [_yuyinjiliView addSubview:_shedingzhuxiBtn];
    [_shedingzhuxiBtn setTitle:@"设定主席" forState:UIControlStateNormal];
    [_shedingzhuxiBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
    _shedingzhuxiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    x = self.frame.size.width/2 + gap/2;
    _fayanrenshuBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:YELLOW_COLOR];
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
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, _biaozhunfayanView.frame.size.height/2 -10, _biaozhunfayanView.frame.size.width, 20)];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = @"所有话筒均可打开或关闭";
    titleL.textColor = [UIColor whiteColor];
    [_biaozhunfayanView addSubview:titleL];
    _biaozhunfayanView.hidden=YES;
}

- (void) shedingzhuxiAction:(id)sender {
    [_shedingzhuxiBtn setSelected:YES];
    [_fayanrenshuBtn setSelected:NO];
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    for (int index = 0; index < shedingzhuxiNumber; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string = [NSString stringWithFormat:@"%d",titleInt];
        [scenarioBtn setTitle:string forState:UIControlStateNormal];
        [scenarioBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
        scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}
- (void) fayanrenshuAction:(id)sender{
    [_shedingzhuxiBtn setSelected:NO];
    [_fayanrenshuBtn setSelected:YES];
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    int top = _shedingzhuxiBtn.frame.origin.y + 45;
    for (int index = 0; index < fayanrenshuNumber; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:RGB(0, 146, 174) selColor:nil];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        [_yuyinjiliView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string = [NSString stringWithFormat:@"%d",titleInt];
        [scenarioBtn setTitle:string forState:UIControlStateNormal];
        [scenarioBtn addTarget:self action:@selector(shedingzhuxiAction:) forControlEvents:UIControlEventTouchUpInside];
        scenarioBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
}
@end
