//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "ElectronicAutoRightView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"
#import "UIImage+Color.h"

#define EAUTO_MAX_NUM   6


@interface ElectronicAutoRightView () <UITableViewDelegate,
UITableViewDataSource, UITextFieldDelegate,
CustomPickerViewDelegate> {
    
    UITableView *_tableView;
    
    int _curIndex;
    int _curSectionIndex;
    BOOL _isAdding;
    BOOL _isStudying;
    
    CustomPickerView *_picker;
    
    int _selRowIp;
    int _selRow2;
    int _selRow3;
    
    UIView *_footerView;
    
    NSMutableArray *_btns;
    
    UITextField *ipTextField;
    
    NSMutableArray *_selectedBtns;
    
    int _number;
    
    UIButton *_previousBtn;
}

@property (nonatomic, strong) NSMutableArray *_studyItems;
@property (nonatomic, strong) NSMutableArray *_bianzuArrays;
@property (nonatomic, strong) NSMutableDictionary *_value;
@property (nonatomic, assign) int _number;
@property (nonatomic, strong) NSMutableArray *_coms;
@property (nonatomic, strong) NSMutableArray *_brands;
@property (nonatomic, strong) NSMutableArray *_ips;
@property (nonatomic, strong) NSMutableDictionary *_map;

@property (nonatomic, strong) NSDictionary *_selectedSecs;
@property (nonatomic, strong) NSDictionary *_selectedType;
@end


@implementation ElectronicAutoRightView
@synthesize _studyItems;
@synthesize _bianzuArrays;
@synthesize _value;
@synthesize _brands;
@synthesize _ips;
@synthesize _map;
@synthesize _coms;
@synthesize _number;
@synthesize _currentBlind;
@synthesize _delegate;
@synthesize _selectedSecs;
@synthesize _selectedType;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame withPlugin:(BlindPlugin*) blindPlugin {
    
    _currentBlind = blindPlugin;
    
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
       
        
        self._value = [NSMutableDictionary dictionary];
        
        _btns = [[NSMutableArray alloc] init];
        _selectedBtns = [[NSMutableArray alloc] init];
        
        
        _curIndex = -1;
        _curSectionIndex = -1;
        
        self._bianzuArrays = [NSMutableArray array];
        
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
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 120) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"2", @"3"]}];
        
        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        IMP_BLOCK_SELF(ElectronicAutoRightView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        _selRowIp = 0;
        _selRow2 = 0;
        _selRow3 = 0;
        
        [self initData];
        
    }
    
    return self;
}

- (void)createFooter{
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           CGRectGetMaxY(_tableView.frame),
                                                           self.frame.size.width,
                                                           180)];
    [self addSubview:_footerView];
    _footerView.backgroundColor = RIGHT_VIEW_CORNER_COLOR;
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*space)/2;
    
    int top = 40;
    
    for (int index = 0; index <= EAUTO_MAX_NUM; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        scenarioBtn.frame = CGRectMake(startX, startY, cellWidth, cellHeight);
        scenarioBtn.clipsToBounds = YES;
        scenarioBtn.layer.cornerRadius = 5;
        scenarioBtn.tag = index;
        [_footerView addSubview:scenarioBtn];
        int titleInt = index + 1;
        NSString *string;
        if (index == EAUTO_MAX_NUM) {
            string = @"全部";
            scenarioBtn.tag = 100;
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-20, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [headerView addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-35, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [headerView addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    valueL.textAlignment = NSTextAlignmentRight;
    
    UIImageView *icon = [[UIImageView alloc]
                         initWithFrame:CGRectMake(CGRectGetMaxX(valueL.frame)+5, 16, 10, 10)];
    icon.image = [UIImage imageNamed:@"remote_video_down.png"];
    [headerView addSubview:icon];
    icon.alpha = 0.8;
    icon.layer.contentsGravity = kCAGravityResizeAspect;
    
    titleL.text = @"编组";
    icon.frame = CGRectMake(CGRectGetMaxX(valueL.frame)-20, 11, 20, 20);
    icon.image = [UIImage imageNamed:@"add_brand_icon.png"];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(headerView.frame)-1,
                                                              self.frame.size.width,
                                                              1)];
    line.backgroundColor =  M_GREEN_LINE;
    [headerView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = headerView.bounds;
    [headerView addSubview:btn];
    [btn addTarget:self
            action:@selector(addGroup:)
  forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableHeaderView = headerView;
    
    if(self._ips == nil)
    {
        self._ips = [NSMutableArray array];
        
        [_ips addObject:@"192.168.1.10"];
        [_ips addObject:@"192.168.1.11"];
        [_ips addObject:@"192.168.1.12"];
        
    }
    
}

- (void) addGroup:(id)sender{
    
    
    int i = (int)[_bianzuArrays count] + 1;
    
    UITextField *f = [[UITextField alloc] initWithFrame:CGRectMake(10,
                                                                   7,
                                                                   _tableView.frame.size.width-100,
                                                                   30)];
    f.delegate = self;
    f.returnKeyType = UIReturnKeyDone;
    f.attributedPlaceholder = [[NSAttributedString alloc]
                               initWithString:[NSString stringWithFormat:@"编组%d", i]
                               attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.6]}];
    f.backgroundColor = [UIColor clearColor];
    f.textColor = [UIColor whiteColor];
    f.borderStyle = UITextBorderStyleNone;
    f.textAlignment = NSTextAlignmentLeft;
    f.font = [UIFont systemFontOfSize:13];
    f.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    f.tag = i-1;
    
    NSMutableArray *values = [NSMutableArray array];
    NSMutableDictionary *rowv = [NSMutableDictionary dictionary];
    [rowv setObject:f forKey:@"title"];
    [rowv setObject:@"" forKey:@"value"];
    [rowv setObject:values forKey:@"values"];
    [_bianzuArrays addObject:rowv];
    
    _isAdding = YES;
    
    _curIndex = (int)[_bianzuArrays count] - 1;
    
    [self refreshFooterButtonsState];
    
    [_tableView reloadData];
    
}


- (void) didConfirmPickerValue:(NSString*) pickerValue{
    
    _curSectionIndex = -1;
    
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
}



#pragma mark -
#pragma mark Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
    {
        return [self._bianzuArrays count];
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return 54;
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
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
        line.backgroundColor =  TITLE_LINE_COLOR;
        [cell.contentView addSubview:line];
        
        NSDictionary *dic = [_bianzuArrays objectAtIndex:indexPath.row];
        
        UITextField *f = [dic objectForKey:@"title"];
        [cell.contentView addSubview:f];
        
        UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                    12,
                                                                    CGRectGetWidth(self.frame)-35, 20)];
        valueL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:valueL];
        valueL.font = [UIFont systemFontOfSize:13];
        valueL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        valueL.textAlignment = NSTextAlignmentRight;
        
        valueL.text = [dic objectForKey:@"value"];
        
        if(_curIndex == indexPath.row)
        {
            cell.backgroundColor = RGBA(255, 180, 0, 0.5);
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    _curIndex = (int)indexPath.row;
    
    [self refreshFooterButtonsState];
    
    [_tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return 0;
    
    if(_curSectionIndex == section)
    {
        return 164;
    }
    return 54;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
        return nil;
    
    int height = 54;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    header.backgroundColor = [UIColor clearColor];
    
    
    UILabel* rowLT = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               12,
                                                               CGRectGetWidth(self.frame)-20, 20)];
    rowLT.backgroundColor = [UIColor clearColor];
    [header addSubview:rowLT];
    rowLT.font = [UIFont systemFontOfSize:13];
    rowLT.textColor  = [UIColor whiteColor];
    
    
    UILabel* valueL = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                12,
                                                                CGRectGetWidth(self.frame)-35, 20)];
    valueL.backgroundColor = [UIColor clearColor];
    [header addSubview:valueL];
    valueL.font = [UIFont systemFontOfSize:13];
    valueL.textColor  = [UIColor whiteColor];
    valueL.textAlignment = NSTextAlignmentRight;
    
    if(section == 1)  {
        UIButton *openBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        openBtn.frame = CGRectMake(10, 9, 70, 36);
        openBtn.clipsToBounds = YES;
        openBtn.layer.cornerRadius = 5;
        [header addSubview:openBtn];
        [openBtn setTitle:@"开" forState:UIControlStateNormal];
        [openBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [openBtn addTarget:self action:@selector(openBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        openBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *stopBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        stopBtn.frame = CGRectMake(115, 9, 70, 36);
        stopBtn.clipsToBounds = YES;
        stopBtn.layer.cornerRadius = 5;
        [header addSubview:stopBtn];
        [stopBtn setTitle:@"停" forState:UIControlStateNormal];
        [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [stopBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [stopBtn addTarget:self action:@selector(stopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        stopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *closeBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        closeBtn.frame = CGRectMake(220, 9, 70, 36);
        closeBtn.clipsToBounds = YES;
        closeBtn.layer.cornerRadius = 5;
        [header addSubview:closeBtn];
        [closeBtn setTitle:@"关" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, height-1, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [header addSubview:line];
    
    return header;
}

- (void) openBtnAction:(UIButton*) sender {
    
    if (sender == _previousBtn) {
        return;
    }
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didButtonAction:)]) {
        [_delegate didButtonAction:1];
    }
}

- (void) stopBtnAction:(UIButton*) sender {
    if (sender == _previousBtn) {
        return;
    }
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didButtonAction:)]) {
        [_delegate didButtonAction:2];
    }
}

- (void) closeBtnAction:(UIButton*) sender {
    
    if (sender == _previousBtn) {
        return;
    }
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
    
    if(_delegate && [_delegate respondsToSelector:@selector(didButtonAction:)]) {
        [_delegate didButtonAction:3];
    }
}

- (void) clickHeader:(UIButton*)sender{
    
    int curIdx = (int)sender.tag;
    if(_curSectionIndex == curIdx)
    {
        _curSectionIndex = -1;
    }
    else
    {
        _curSectionIndex = curIdx;
    }
    
    [_tableView reloadData];
}

- (void) didPickerValue:(NSDictionary *)values{
    
    if(_picker.tag == 1)
    {
        _selRowIp = [[values objectForKey:@"row"] intValue];
    }
    
    //_curSectionIndex = -1;
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
    
}

- (void) buttonAction:(UIButton*)sender{
    for (UIButton *button in _selectedBtns) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    if ([_selectedBtns containsObject:sender]) {
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
        [_selectedBtns removeObject:sender];
    } else {
        [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
        [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
        [_selectedBtns addObject:sender];
    }
}

- (void) refreshFooterButtonsState{
    
    if(_curIndex >= 0 && _curIndex < [_bianzuArrays count])
    {
        NSMutableDictionary *mdic = [_bianzuArrays objectAtIndex:_curIndex];
        
        NSMutableArray *values = [mdic objectForKey:@"values"];
        for(UIButton *btn in _btns)
        {
            int tidx = (int)btn.tag + 1;
            id obj = [NSNumber numberWithInt:tidx];
            
            if([values containsObject:obj])
            {
                [btn changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
                [btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
            }
            else
            {
                [btn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
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

