//
//  AutoRunSetView.m
//  veenoon
//
//  Created by chen jack on 2018/7/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ChuanGanAutoSetView.h"
#import "CheckButton.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "WebClient.h"
#import "DataBase.h"
#import "User.h"
#import "UserDefaultsKV.h"
#import "Utilities.h"
#import "NSDate-Helper.h"
#import "KVNProgress.h"
#import "CustomPickerView.h"

#define SCEN_PICKER_WIDTH  300

@interface ChuanGanAutoSetView() <CustomPickerViewDelegate>
{
    UIView *whiteView;
    
    CustomPickerView *_youjiwuPicker;
    CustomPickerView *_tempraturePicker;
    CustomPickerView *_weakPicker;
    CustomPickerView *_startStop1Picker;
    CustomPickerView *_scnearioPicker1;
    CustomPickerView *_tempraturePicker2;
    CustomPickerView *_startStop2Picker;
    CustomPickerView *_scnearioPicker2;
    
    UILabel *_wenshipmL1;
    UILabel *_wenshipmL2;
    
    int col;
    
    UIView *maskView;
    
    int currentRow;
    
    WebClient *_client;
    
    NSMutableArray *_tempraturArray;
    NSMutableArray *_shiduArray;
    NSMutableArray *_pmArray;
}
@property (nonatomic, strong) NSMutableArray *_scripts;
@property (nonatomic, strong) NSMutableArray *_weaks;
@property (nonatomic, strong) NSMutableDictionary *_selected;

@end

@implementation ChuanGanAutoSetView
@synthesize _scripts;
@synthesize _weaks;
@synthesize _scenarios;
@synthesize _selected;
@synthesize ctrl;
@synthesize _schedule;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void) initArray {
    if (_tempraturArray) {
        [_tempraturArray removeAllObjects];
    } else {
        _tempraturArray = [NSMutableArray array];
        for (int i = -40; i < 81; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%d", i];
            [_tempraturArray addObject:wendu];
        }
    }
    
    if (_shiduArray) {
        [_shiduArray removeAllObjects];
    } else {
        _shiduArray = [NSMutableArray array];
        for (int i = 0; i < 101; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%d", i];
            [_shiduArray addObject:wendu];
        }
    }
    
    if (_pmArray) {
        [_pmArray removeAllObjects];
    } else {
        _pmArray = [NSMutableArray array];
        for (int i = 0; i < 201; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%d", i*5];
            [_pmArray addObject:wendu];
        }
    }
}

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    
    return self;
}

- (id) initWithPicker:(CGRect)frame withScnearios:(NSArray*) scenarios {
    
    if(self = [super initWithFrame:frame])
    {
        self._scenarios = scenarios;
        
        [self initArray];
        
        self.backgroundColor = [UIColor clearColor];
        
        maskView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:maskView];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [maskView addGestureRecognizer:tapGesture];
        
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height,
                                                             frame.size.width,
                                                             390)];
        [self addSubview:whiteView];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        
        int x = 85;
        int y = 80;
        
        
        _youjiwuPicker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(x, y, 80, 150) withGrayOrLight:@"picker_player.png"];
        
        _youjiwuPicker._pickerDataArray = @[@{@"values":@[@"温度",@"湿度",@"PM2,5"]}];
        _youjiwuPicker._selectColor = [UIColor blackColor];
        _youjiwuPicker._rowNormalColor = [UIColor grayColor];
        _youjiwuPicker.delegate_ = self;
        IMP_BLOCK_SELF(ChuanGanAutoSetView);
        _youjiwuPicker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didYoujiwuPickerValue:values];
        };
        [whiteView addSubview:_youjiwuPicker];
        
        UILabel *colL;
        colL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_youjiwuPicker.frame)+50,
                                                         y+65,
                                                         60, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"高于";
        
        
        _tempraturePicker = [[CustomPickerView alloc]
                            initWithFrame:CGRectMake(CGRectGetMaxX(colL.frame), y, 40, 150) withGrayOrLight:@"picker_player.png"];
        NSMutableArray *wenduArray = [NSMutableArray array];
        for (int i = -40; i < 81; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%d", i];
            [wenduArray addObject:wendu];
        }
        
        _tempraturePicker._pickerDataArray = @[@{@"values":wenduArray}];
        _tempraturePicker._selectColor = [UIColor blackColor];
        _tempraturePicker._rowNormalColor = [UIColor grayColor];
        _tempraturePicker.delegate_ = self;
        
        _tempraturePicker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didTemprtruePickerValue:values];
        };
        [whiteView addSubview:_tempraturePicker];
        
        _wenshipmL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tempraturePicker.frame),
                                                         y+65,
                                                         50, 20)];
        _wenshipmL1.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:_wenshipmL1];
        _wenshipmL1.font = [UIFont systemFontOfSize:15];
        _wenshipmL1.textColor  = [UIColor blackColor];
        _wenshipmL1.textAlignment = NSTextAlignmentCenter;
        _wenshipmL1.text = @"℃";
        
        
        _startStop1Picker = [[CustomPickerView alloc]
                          initWithFrame:CGRectMake(CGRectGetMaxX(_wenshipmL1.frame)+30, y, 80, 150) withGrayOrLight:@"picker_player.png"];
        
        _startStop1Picker._pickerDataArray = @[@{@"values":@[@"启动",@"关闭"]}];
        _startStop1Picker._selectColor = [UIColor blackColor];
        _startStop1Picker._rowNormalColor = [UIColor grayColor];
        _startStop1Picker.delegate_ = self;
        _startStop1Picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self startStop1Pickervalue:values];
        };
        [whiteView addSubview:_startStop1Picker];
        
        
        
        
        _scnearioPicker1 = [[CustomPickerView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(_startStop1Picker.frame)+40, y, 80, 150) withGrayOrLight:@"picker_player.png"];
        NSMutableArray *scenarioNames = [NSMutableArray array];
        for (Scenario *scenario in self._scenarios) {
            NSMutableDictionary *scenarioDic = [scenario senarioData];
            [scenarioNames addObject:[scenarioDic objectForKey:@"name"]];
        }
        _scnearioPicker1._pickerDataArray = @[@{@"values":scenarioNames}];
        _scnearioPicker1._selectColor = [UIColor blackColor];
        _scnearioPicker1._rowNormalColor = [UIColor grayColor];
        _scnearioPicker1.delegate_ = self;
        _scnearioPicker1._selectionBlock = ^(NSDictionary *values)
        {
            [block_self scenarioPickervalue1:values];
        };
        [whiteView addSubview:_scnearioPicker1];
        
        colL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_scnearioPicker1.frame)+40,
                                                         y+65,
                                                         60, 20)];
        colL.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:colL];
        colL.font = [UIFont systemFontOfSize:15];
        colL.textColor  = [UIColor blackColor];
        colL.textAlignment = NSTextAlignmentCenter;
        colL.text = @"低于";
        
        _tempraturePicker2 = [[CustomPickerView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(colL.frame), y, 40, 150) withGrayOrLight:@"picker_player.png"];
        NSMutableArray *wenduArray2 = [NSMutableArray array];
        for (int i = -40; i < 81; i++) {
            NSString *wendu = [NSString stringWithFormat:@"%d", i];
            [wenduArray2 addObject:wendu];
        }
        _tempraturePicker2._pickerDataArray = @[@{@"values":wenduArray2}];
        _tempraturePicker2._selectColor = [UIColor blackColor];
        _tempraturePicker2._rowNormalColor = [UIColor grayColor];
        _tempraturePicker2.delegate_ = self;
        
        _tempraturePicker2._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didTemprtruePickerValue2:values];
        };
        [whiteView addSubview:_tempraturePicker2];
        
        
        
        _wenshipmL2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tempraturePicker2.frame),
                                                         y+65,
                                                         50, 20)];
        _wenshipmL2.backgroundColor = [UIColor clearColor];
        [whiteView addSubview:_wenshipmL2];
        _wenshipmL2.font = [UIFont systemFontOfSize:15];
        _wenshipmL2.textColor  = [UIColor blackColor];
        _wenshipmL2.textAlignment = NSTextAlignmentCenter;
        _wenshipmL2.text = @"℃";
        
        
        _startStop2Picker = [[CustomPickerView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(_wenshipmL2.frame), y, 80, 150) withGrayOrLight:@"picker_player.png"];
        
        _startStop2Picker._pickerDataArray = @[@{@"values":@[@"启动",@"关闭"]}];
        _startStop2Picker._selectColor = [UIColor blackColor];
        _startStop2Picker._rowNormalColor = [UIColor grayColor];
        _startStop2Picker.delegate_ = self;
        _startStop2Picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self startStop2Pickervalue:values];
        };
        [whiteView addSubview:_startStop2Picker];
        
        
        _scnearioPicker2 = [[CustomPickerView alloc]
                            initWithFrame:CGRectMake(CGRectGetMaxX(_startStop2Picker.frame), y, 80, 150) withGrayOrLight:@"picker_player.png"];
        NSMutableArray *scenarioNames2 = [NSMutableArray array];
        for (Scenario *scenario in self._scenarios) {
            NSMutableDictionary *scenarioDic = [scenario senarioData];
            [scenarioNames2 addObject:[scenarioDic objectForKey:@"name"]];
        }
        _scnearioPicker2._pickerDataArray = @[@{@"values":scenarioNames2}];
        _scnearioPicker2._selectColor = [UIColor blackColor];
        _scnearioPicker2._rowNormalColor = [UIColor grayColor];
        _scnearioPicker2.delegate_ = self;
        _scnearioPicker2._selectionBlock = ^(NSDictionary *values)
        {
            [block_self scenarioPickervalue2:values];
        };
        [whiteView addSubview:_scnearioPicker2];
        
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight(whiteView.frame)-50,
                                                                  CGRectGetWidth(whiteView.frame),
                                                                  1)];
        [whiteView addSubview:line];
        line.backgroundColor = LINE_COLOR;
        
        UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSave.frame = CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(whiteView.frame), 50);
        [whiteView addSubview:btnSave];
        [btnSave setTitle:@"存储" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        [btnSave addTarget:self
                    action:@selector(saveSchedule:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        currentRow = 0;
    }
    
    return self;
}

- (void) scenarioPickervalue2:(NSDictionary *)values{
    
    
    
}

- (void) startStop2Pickervalue:(NSDictionary *)values{
    
    
    
}

- (void) didTemprtruePickerValue2:(NSDictionary *)values{
    
    
    
}

- (void) scenarioPickervalue1:(NSDictionary *)values{
    
    
    
}

- (void) startStop1Pickervalue:(NSDictionary *)values{
    
    
    
}

- (void) didTemprtruePickerValue:(NSDictionary *)values{
    
    
    
}

- (void) didYoujiwuPickerValue:(NSDictionary *)values{
    
    NSString *data = [values objectForKey:[NSNumber numberWithInt:0]];
    if ([@"温度" isEqualToString:data]) {
        _wenshipmL1.text = @"℃";
        _wenshipmL2.text = @"℃";
        
        _tempraturePicker._pickerDataArray = @[@{@"values":_tempraturArray}];
        _tempraturePicker2._pickerDataArray = @[@{@"values":_tempraturArray}];
        
        [_tempraturePicker selectRow:0 inComponent:0];
        [_tempraturePicker2 selectRow:0 inComponent:0];
    } else if ([@"湿度" isEqualToString:data]) {
        _wenshipmL1.text = @"%";
        _wenshipmL2.text = @"%";
        
        _tempraturePicker._pickerDataArray = @[@{@"values":_shiduArray}];
        _tempraturePicker2._pickerDataArray = @[@{@"values":_shiduArray}];
        
        [_tempraturePicker selectRow:0 inComponent:0];
        [_tempraturePicker2 selectRow:0 inComponent:0];
    } else {
        _wenshipmL1.text = @"μg/m³";
        _wenshipmL2.text = @"μg/m³";
        
        _tempraturePicker._pickerDataArray = @[@{@"values":_pmArray}];
        _tempraturePicker2._pickerDataArray = @[@{@"values":_pmArray}];
        
        [_tempraturePicker selectRow:0 inComponent:0];
        [_tempraturePicker2 selectRow:0 inComponent:0];
    }
    
}


- (void) saveSchedule:(id)sender
{
    
}

- (void) handleTapGesture:(id)sender{
    
    [self hidden];
}

- (void) hidden{
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.frame = CGRectMake(0, self.frame.size.height,
                                                      self.frame.size.width,
                                                      390);
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                     }];
}

- (void) show {
    
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.frame = CGRectMake(0, self.frame.size.height - 390,
                                                      self.frame.size.width,
                                                      390);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}


@end
