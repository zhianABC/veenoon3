//
//  EngineerPortSettingView.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPortSettingView.h"
#import "CustomPickerView.h"

@interface EngineerPortSettingView () <UITableViewDelegate,UITableViewDataSource, CustomPickerViewDelegate> {
    int startX;
    int rowGap;
}

@end

@implementation EngineerPortSettingView
@synthesize _portList;
@synthesize _portPicker;
@synthesize _portTypePicker;
@synthesize _portLvPicker;
@synthesize _digitPicker;
@synthesize _checkPicker;
@synthesize _stopPicker;
@synthesize _tableView;
@synthesize _selectedRow;
@synthesize _previousSelectedRow;

-(void) initDat {
    if (_portList) {
        [_portList removeAllObjects];
    } else {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"Com1", @"portNumber",
                                     @"RS-232", @"portType",
                                     @"4800", @"portLv",
                                     @"4", @"digitPosition",
                                     @"PAR_EVEN", @"checkPosition",
                                     @"NONE1", @"stopPosition",
                                     nil];
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"Com2", @"portNumber",
                                     @"RS-232", @"portType",
                                     @"4800", @"portLv",
                                     @"4", @"digitPosition",
                                     @"PAR_EVEN", @"checkPosition",
                                     @"NONE2", @"stopPosition",
                                     nil];
        self._portList = [NSMutableArray arrayWithObjects:dic1, dic2, nil];
    }
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        maskView.backgroundColor = [UIColor clearColor];
        maskView.userInteractionEnabled = YES;
        [self addSubview:maskView];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [maskView addGestureRecognizer:tapGesture];
        
        [self initDat];
        self.backgroundColor = THEME_COLOR;
        self.clipsToBounds = YES;
        _selectedRow = -1;
        _previousSelectedRow=-1;
        startX = 40;
        rowGap = (SCREEN_WIDTH - startX)/6;
        
        UILabel *_portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_PORT_VIEW_HEIGHT, SCREEN_WIDTH-80, 20)];
        _portDNSLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_portDNSLabel];
        _portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
        _portDNSLabel.textColor  = [UIColor whiteColor];
        _portDNSLabel.text = @"端口设置";
        
        int titleHeight = ENGINEER_PORT_VIEW_HEIGHT + 80;
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"串口号";
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"串口类型";
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*2, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"波特率";
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*3, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"数据位";
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*4, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"校验位";
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*5, titleHeight, 100, 30)];
        titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:16];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = @"停止位";
        
        int tableHeight = titleHeight + 40;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableHeight, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:_tableView];
        
        UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        [self addSubview:bottomBar];
        
        //缺切图，把切图贴上即可。
        bottomBar.backgroundColor = [UIColor grayColor];
        bottomBar.userInteractionEnabled = YES;
        bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0,160, 50);
        [bottomBar addSubview:cancelBtn];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [cancelBtn addTarget:self
                      action:@selector(cancelAction:)
            forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
        [bottomBar addSubview:okBtn];
        [okBtn setTitle:@"确认" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [okBtn addTarget:self
                  action:@selector(okAction:)
        forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *_portSettingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _portSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT - 130, 50, 50);
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateNormal];
        [_portSettingsBtn setImage:[UIImage imageNamed:@"engineer_port_s.png"] forState:UIControlStateHighlighted];
        [_portSettingsBtn addTarget:self action:@selector(portAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_portSettingsBtn];
        
        UIButton *_dnsSettingsBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _dnsSettingsBtn.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 130, 50, 50);
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_n.png"] forState:UIControlStateNormal];
        [_dnsSettingsBtn setImage:[UIImage imageNamed:@"engineer_dns_s.png"] forState:UIControlStateHighlighted];
        [_dnsSettingsBtn addTarget:self action:@selector(dnsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dnsSettingsBtn];
        
    }
    return self;
}

- (void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    [self.delegate performSelector:@selector(portViewHandleTapGesture) withObject:nil];
}
- (void) portAction:(id)sender{
    [self.delegate performSelector:@selector(portViewPortAction) withObject:nil];
}

- (void) dnsAction:(id)sender{
    [self.delegate performSelector:@selector(portViewdnsAction) withObject:nil];
}

- (void) cancelAction:(id)sender{
    CGRect rc = self.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    self.frame = rc;
    [UIView commitAnimations];
}

- (void) okAction:(id)sender{
    CGRect rc = self.frame;
    rc.origin.x = -SCREEN_WIDTH;
    
    [UIView beginAnimations:nil context:nil];
    self.frame = rc;
    [UIView commitAnimations];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_portList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedRow) {
        return 180;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_selectedRow == indexPath.row) {
        _tableView.scrollEnabled=NO;
        return cell;
    } else if (_selectedRow == -1) {
        _tableView.scrollEnabled=YES;
    }
    
    NSMutableDictionary *dic = [self._portList objectAtIndex:indexPath.row];

    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"portNumber"];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"portType"];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*2, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"portLv"];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*3, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"digitPosition"];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*4, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"checkPosition"];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(startX+rowGap*5, 5, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [dic objectForKey:@"stopPosition"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // firstly update the pre selected row number
    if (_previousSelectedRow > -1) {
        NSMutableDictionary *dic = [_portList objectAtIndex:_previousSelectedRow];
        [dic setObject:_portPicker._unitString forKey:@"portNumber"];
        [dic setObject:_portTypePicker._unitString forKey:@"portType"];
        [dic setObject:_portLvPicker._unitString forKey:@"portLv"];
        [dic setObject:_digitPicker._unitString forKey:@"digitPosition"];
        [dic setObject:_checkPicker._unitString forKey:@"checkPosition"];
        [dic setObject:_stopPicker._unitString forKey:@"stopPosition"];
    }
    
    //secondly
    _selectedRow = (int) indexPath.row;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if (_portPicker == nil) {
        _portPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX, 5, 100, 150) withGrayOrLight:@"light"];
        [_portPicker removeArray];
        _portPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_portPicker selectRow:0 inComponent:0];
        _portPicker._selectColor = RGB(253, 180, 0);
        _portPicker._rowNormalColor = RGB(117, 165, 186);
        _portPicker.delegate_=self;
    }
    [cell.contentView addSubview:_portPicker];
    
    if (_portTypePicker == nil) {
        _portTypePicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX+rowGap, 5, 100, 150) withGrayOrLight:@"light"];
        [_portTypePicker removeArray];
        _portTypePicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_portTypePicker selectRow:0 inComponent:0];
        _portTypePicker._selectColor = RGB(253, 180, 0);
        _portTypePicker._rowNormalColor = RGB(117, 165, 186);
        _portTypePicker.delegate_=self;
    }
    [cell.contentView addSubview:_portTypePicker];
    if (_portLvPicker == nil) {
        _portLvPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX+rowGap*2, 5, 100, 150) withGrayOrLight:@"light"];
        [_portLvPicker removeArray];
        _portLvPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_portLvPicker selectRow:0 inComponent:0];
        _portLvPicker._selectColor = RGB(253, 180, 0);
        _portLvPicker._rowNormalColor = RGB(117, 165, 186);
        _portLvPicker.delegate_=self;
    }
    [cell.contentView addSubview:_portLvPicker];
    if (_digitPicker == nil) {
        _digitPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX+rowGap*3, 5, 100, 150) withGrayOrLight:@"light"];
        [_digitPicker removeArray];
        _digitPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_digitPicker selectRow:0 inComponent:0];
        _digitPicker._selectColor = RGB(253, 180, 0);
        _digitPicker._rowNormalColor = RGB(117, 165, 186);
        _digitPicker.delegate_=self;
    }
    [cell.contentView addSubview:_digitPicker];
    if (_checkPicker==nil) {
        _checkPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX+rowGap*4, 5, 100, 150) withGrayOrLight:@"light"];
        [_checkPicker removeArray];
        _checkPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_checkPicker selectRow:0 inComponent:0];
        _checkPicker._selectColor = RGB(253, 180, 0);
        _checkPicker._rowNormalColor = RGB(117, 165, 186);
        _checkPicker.delegate_=self;
    }
        
    [cell.contentView addSubview:_checkPicker];
    if (_stopPicker == nil) {
        _stopPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(startX+rowGap*5, 5, 100, 150) withGrayOrLight:@"light"];
        _stopPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
        [_stopPicker removeArray];
        [_stopPicker selectRow:0 inComponent:0];
        _stopPicker._selectColor = RGB(253, 180, 0);
        _stopPicker._rowNormalColor = RGB(117, 165, 186);
        _stopPicker.delegate_=self;
    }
    [cell.contentView addSubview:_stopPicker];
    
    [_tableView reloadData];
    
    _previousSelectedRow = (int)indexPath.row;
}

- (void) didConfirmPickerValue:(NSString*) pickerValue {
    [_tableView reloadData];
}
@end
