//
//  PlayerSettingsPannel.m
//  veenoon
//
//  Created by chen jack on 2017/12/16.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "NewWindRightView.h"
#import "CustomPickerView.h"
#import "UIButton+Color.h"

@interface NewWindRightView () <UITableViewDelegate, UITableViewDataSource, CustomPickerViewDelegate, UITextFieldDelegate> {
    int _curIndex;
    int _selRow1;
    int _selRow2;
    int _selRow3;
    UITableView *_tableView;
    
    CustomPickerView *_picker;
    
    UIView *_footerView;
    
    NSMutableArray *_btns;
    
    NSMutableArray *_selectedBtns;
}
@property (nonatomic, strong) NSMutableArray *_coms;
@property (nonatomic, strong) NSMutableArray *_brands;
@property (nonatomic, strong) NSMutableArray *_brands2;

@property (nonatomic, strong) NSDictionary *_selectedBrand;
@property (nonatomic, strong) NSDictionary *_selectedType;
@end


@implementation NewWindRightView
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
        self.backgroundColor = RIGHT_VIEW_CORNER_SD_COLOR;
        
        _btns = [[NSMutableArray alloc] init];
        
        _selectedBtns = [[NSMutableArray alloc] init];
        
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
                   initWithFrame:CGRectMake(frame.size.width/2-100, 43, 200, 120) withGrayOrLight:@"picker_player.png"];
        
        
        _picker._pickerDataArray = @[@{@"values":@[@"1", @"2", @"3"]}];
        
        
        _picker._selectColor = YELLOW_COLOR;
        _picker._rowNormalColor = [UIColor whiteColor];
        _picker.delegate_ = self;
        [_picker selectRow:0 inComponent:0];
        IMP_BLOCK_SELF(NewWindRightView);
        _picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didPickerValue:values];
        };
        
        [self initData];
    }
    return self;
}

- (void) initData{
    
    if(self._brands == nil)
    {
        self._brands = [NSMutableArray array];
        self._brands2 = [NSMutableArray array];
        self._coms = [NSMutableArray array];
        
        [_coms addObject:@"自动"];
        [_coms addObject:@"睡眠"];
        [_coms addObject:@"舒适"];
        
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
    _footerView.backgroundColor = RIGHT_VIEW_CORNER_COLOR;
    
    int colNumber = 4;
    int space = 5;
    int cellWidth = 115/2;
    int cellHeight = 115/2;
    int leftRight = (self.frame.size.width - 4*cellWidth - 3*5)/2;
    
    int top = 40;
    
    for (int index = 0; index < 7; index++) {
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        UIButton *scenarioBtn = [UIButton buttonWithColor:RIGHT_VIEW_CORNER_BTN_COLOR selColor:RIGHT_VIEW_CORNER_SD_COLOR];
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
    for (UIButton *button in _selectedBtns) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setSelected:NO];
    }
    if ([_selectedBtns containsObject:sender]) {
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [_selectedBtns removeObject:sender];
    } else {
        [sender setTitleColor:YELLOW_COLOR forState:UIControlStateNormal];
        [sender setSelected:YES];
        [_selectedBtns addObject:sender];
    }
    
}

- (void) didPickerValue:(NSDictionary *)values{
    
    if(_picker.tag == 1) {
        _selRow1 = [[values objectForKey:@"row"] intValue];
    } else if(_picker.tag == 2) {
        _selRow2 = [[values objectForKey:@"row"] intValue];
    } else if(_picker.tag == 3) {
        _selRow3 = [[values objectForKey:@"row"] intValue];
    }
    
    _tableView.scrollEnabled = YES;
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
        titleL.text = @"模式";
        valueL.text = @"自动";
        if (_selRow1 > 0) {
            valueL.text = [_coms objectAtIndex:_selRow1];
        }
        
    } else if (indexPath.row == 1) {
        titleL.text = @"风速";
        valueL.text = @"中";
        
        if (_selRow2 > 0) {
            valueL.text = [_brands objectAtIndex:_selRow2];
        }
    } else {
        titleL.text = @"传感器";
        valueL.text = @"198.162.1.2";
        
        if (_selRow3 > 0) {
            valueL.text = [_brands2 objectAtIndex:_selRow3];
        }
    }
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.frame.size.width, 1)];
    line.backgroundColor =  TITLE_LINE_COLOR;
    [cell.contentView addSubview:line];
    
    if(_curIndex == indexPath.row) {
        line.frame = CGRectMake(0, 163, self.frame.size.width, 1);
        [cell.contentView addSubview:_picker];
    }
    
    if(_curIndex == 0) {
        _picker.tag = 1;
        _picker._pickerDataArray = @[@{@"values":_coms}];
        [_picker selectRow:_selRow1 inComponent:0];
    }  else if(_curIndex == 1) {
        _picker.tag = 2;
        _picker._pickerDataArray = @[@{@"values":_brands}];
        [_picker selectRow:_selRow2 inComponent:0];
    } else if(_curIndex == 2) {
        _picker.tag = 3;
        _picker._pickerDataArray = @[@{@"values":_brands2}];
        [_picker selectRow:_selRow3 inComponent:0];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
        int curIdx = (int)indexPath.row;
        
        if(_curIndex == curIdx)
        {
            _curIndex = -1;
        }
        else
        {
            _curIndex = curIdx;
            _tableView.scrollEnabled = NO;
        }
        
        
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

