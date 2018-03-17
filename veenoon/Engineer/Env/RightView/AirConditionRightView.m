//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "AirConditionRightView.h"
#import "AirConditionComIRView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"

@interface AirConditionRightView () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate, UITextFieldDelegate> {
    AirConditionComIRView *_com;
    
    int _curIndex;
    int _selRow1;
    int _selRow2;
    int _selRow3;
    UITableView *_tableView;
    
    CustomPickerView *_picker;
    
    UIView *_footerView;
    
    NSMutableArray *_btns;
    
    UITextField *ipTextField;
    
    UILabel *wenduL;
    
}
@property (nonatomic, strong) NSMutableArray *_coms;
@property (nonatomic, strong) NSMutableArray *_brands;
@property (nonatomic, strong) NSMutableArray *_brands2;

@property (nonatomic, strong) NSDictionary *_selectedBrand;
@property (nonatomic, strong) NSDictionary *_selectedType;
@end


@implementation AirConditionRightView
@synthesize _coms;
@synthesize _brands;
@synthesize _brands2;
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
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 40, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont systemFontOfSize:13];
        titleL.textColor  = [UIColor colorWithWhite:1.0 alpha:0.8];
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
        
        _btns = [[NSMutableArray alloc] init];
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        [self addSubview:headView];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(switchComSetting)];
        swip.direction = UISwipeGestureRecognizerDirectionDown;
        
        
        [headView addGestureRecognizer:swip];
        
        _com = [[AirConditionComIRView alloc] initWithFrame:self.bounds];
        
        _curIndex = -1;
        _selRow1 = 0;
        _selRow2 = 0;
        _selRow3 = 0;
        
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
        IMP_BLOCK_SELF(AirConditionRightView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        [self initData];
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

- (void) initData{
    
    if(self._brands == nil)
    {
        self._brands = [NSMutableArray array];
        self._brands2 = [NSMutableArray array];
        self._coms = [NSMutableArray array];
        
        [_coms addObject:@"1"];
        [_coms addObject:@"2"];
        [_coms addObject:@"3"];
        
        [_brands addObject:@"1"];
        [_brands addObject:@"2"];
        [_brands addObject:@"3"];
        
        [_brands2 addObject:@"1"];
        [_brands2 addObject:@"2"];
        [_brands2 addObject:@"3"];
        
        
        [_tableView reloadData];
    }
    
    
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
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
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

- (void) buttonAction:(id)sender{
    
    
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

- (void) didPickerValue:(NSDictionary *)values{
    
    if(_picker.tag == 1) {
        _selRow1 = [[values objectForKey:@"row"] intValue];
    } else if(_picker.tag == 3) {
        _selRow3 = [[values objectForKey:@"row"] intValue];
    }
    
    [_tableView reloadData];
    
}

- (void) didConfirmPickerValue:(NSString*) pickerValue{
    _curIndex=-1;
    
    _tableView.scrollEnabled = YES;
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) {
        if(_curIndex == indexPath.row && _curIndex != 1)
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
    if (_curIndex != 1) {
        
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
    }
    
    
    if (indexPath.row == 0) {
        titleL.text = @"空调模式";
        valueL.text = @"自动";
        if (_selRow1 > 0) {
            valueL.text = [_coms objectAtIndex:_selRow1];
        }
        
    } else if (indexPath.row == 1) {
        titleL.text = @"空调温度";
        wenduL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-35,
                                                           12,
                                                           70, 20)];
        wenduL.text = @"26";
        wenduL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:wenduL];
        wenduL.font = [UIFont systemFontOfSize:13];
        wenduL.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
        wenduL.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_airecon_wendu_n.png"] ];
        imageView.frame = CGRectMake(160, 16, 12, 8);
        [cell addSubview:imageView];
        
        if (_selRow2 > 0) {
            wenduL.text = [_brands objectAtIndex:_selRow2];
        }
        UIColor *rectColor = RGB(0, 146, 174);
        
        UIButton *addBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        addBtn.frame = CGRectMake(10, 7, 60, 30);
        addBtn.clipsToBounds = YES;
        addBtn.layer.cornerRadius = 5;
        [cell addSubview:addBtn];
        
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        UIButton *minusBtn = [UIButton buttonWithColor:rectColor selColor:M_GREEN_COLOR];
        minusBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-70, 7, 60, 30);
        minusBtn.clipsToBounds = YES;
        minusBtn.layer.cornerRadius = 5;
        [cell addSubview:minusBtn];
        
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
        minusBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    } else {
        titleL.text = @"空调风速";
        valueL.text = @"自动";
        
        if (_selRow3 > 0) {
            valueL.text = [_brands2 objectAtIndex:_selRow3];
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  M_GREEN_LINE;
    [cell.contentView addSubview:line];
    
    if(_curIndex == indexPath.row && _curIndex != 1) {
        line.frame = CGRectMake(0, 143, self.frame.size.width, 1);
        [cell.contentView addSubview:_picker];
    }
    
    if(_curIndex == 0) {
        _picker.tag = 1;
        _picker._pickerDataArray = @[@{@"values":_coms}];
        [_picker selectRow:_selRow1 inComponent:0];
    }  else if(_curIndex == 2) {
        _picker.tag = 3;
        _picker._pickerDataArray = @[@{@"values":_brands2}];
        [_picker selectRow:_selRow3 inComponent:0];
    }
    
    
    return cell;
}
- (void) addAction:(id)sender {
    NSString *wenduStr = wenduL.text;
    int value = [wenduStr intValue];
    value++;
    
    wenduStr = [NSString stringWithFormat:@"%d", value];
    
    wenduL.text = wenduStr;
}

- (void) minusAction:(id)sender {
    NSString *wenduStr = wenduL.text;
    int value = [wenduStr intValue];
    value--;
    
    wenduStr = [NSString stringWithFormat:@"%d", value];
    
    wenduL.text = wenduStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        _curIndex = (int)indexPath.row;
        if (_curIndex != 1) {
            _tableView.scrollEnabled = NO;
            [_tableView reloadData];
        }
    }
}

@end

