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
#import "UserSensorObj.h"
#import "SensorProxy.h"

#define SCEN_PICKER_WIDTH  300

@interface ChuanGanAutoSetView() <CustomPickerViewDelegate>
{
    UIView *whiteView;
    
    CustomPickerView *_youjiwuPicker;
    CustomPickerView *_condi1Picker;
    CustomPickerView *_weakPicker;
    CustomPickerView *_startStop1Picker;
    CustomPickerView *_scnearioPicker1;
    CustomPickerView *_condi2Picker;
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
    
    int _currentSensorType;
    
    int _req_count;
}
@property (nonatomic, strong) NSMutableArray *_scripts;
@property (nonatomic, strong) NSMutableArray *_weaks;
@property (nonatomic, strong) NSMutableDictionary *_selected;

@property (nonatomic, strong) NSMutableArray *_sensorProxys;

@end

@implementation ChuanGanAutoSetView
@synthesize _scripts;
@synthesize _weaks;
@synthesize _scenarios;
@synthesize _selected;
@synthesize ctrl;
@synthesize _schedule;
@synthesize _sensor;

@synthesize _sensorProxys;

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
        for (int i = 80; i >= -40 ; i--) {
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
        
        
        _currentSensorType = 2;
        _youjiwuPicker = [[CustomPickerView alloc]
                   initWithFrame:CGRectMake(x, y, 80, 150) withGrayOrLight:@"picker_player.png"];
        
        _youjiwuPicker._pickerDataArray = @[@{@"values":@[@"温度",@"湿度",@"PM2.5"]}];
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
        
        
        _condi1Picker = [[CustomPickerView alloc]
                            initWithFrame:CGRectMake(CGRectGetMaxX(colL.frame), y, 40, 150) withGrayOrLight:@"picker_player.png"];
        _condi1Picker._pickerDataArray = @[@{@"values":_tempraturArray}];
        _condi1Picker._selectColor = [UIColor blackColor];
        _condi1Picker._rowNormalColor = [UIColor grayColor];
        _condi1Picker.delegate_ = self;
        [_condi1Picker selectRow:0 inComponent:0];
        
        _condi1Picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didTemprtruePickerValue:values];
        };
        [whiteView addSubview:_condi1Picker];
        
        _wenshipmL1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_condi1Picker.frame),
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
        
        _startStop1Picker._pickerDataArray = @[@{@"values":@[@"启动"]}];
        _startStop1Picker._selectColor = [UIColor blackColor];
        _startStop1Picker._rowNormalColor = [UIColor grayColor];
        _startStop1Picker.delegate_ = self;
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
        [_scnearioPicker1 selectRow:0 inComponent:0];
        
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
        
        _condi2Picker = [[CustomPickerView alloc]
                             initWithFrame:CGRectMake(CGRectGetMaxX(colL.frame), y, 40, 150) withGrayOrLight:@"picker_player.png"];
        _condi2Picker._pickerDataArray = @[@{@"values":_tempraturArray}];
        _condi2Picker._selectColor = [UIColor blackColor];
        _condi2Picker._rowNormalColor = [UIColor grayColor];
        _condi2Picker.delegate_ = self;
        [_condi2Picker selectRow:0 inComponent:0];
        
        _condi2Picker._selectionBlock = ^(NSDictionary *values)
        {
            [block_self didTemprtruePickerValue2:values];
        };
        [whiteView addSubview:_condi2Picker];
        
        
        
        _wenshipmL2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_condi2Picker.frame),
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
        
        _startStop2Picker._pickerDataArray = @[@{@"values":@[@"启动"]}];
        _startStop2Picker._selectColor = [UIColor blackColor];
        _startStop2Picker._rowNormalColor = [UIColor grayColor];
        _startStop2Picker.delegate_ = self;
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
        [_scnearioPicker2 selectRow:0 inComponent:0];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyConnectionsLoad:) name:@"Notify_Connections_Loaded"
                                                   object:nil];
    }
    
    return self;
}

- (void) notifyConnectionsLoad:(id)sender{
    
    self._sensorProxys = [NSMutableArray array];
    
    for(RgsConnectionObj *connect in _sensor.connectionObjArray)
    {
        SensorProxy *sp = [[SensorProxy alloc] init];
        sp.connection = connect;
        [_sensorProxys addObject:sp];
        [sp refreshData];
    }
}

- (void) didTemprtruePickerValue:(NSDictionary *)values{
    
    //条件1
    
}

- (void) scenarioPickervalue1:(NSDictionary *)values{
    
    //场景1
    
}

- (void) scenarioPickervalue2:(NSDictionary *)values{
    
    //场景2
    
}


- (void) didTemprtruePickerValue2:(NSDictionary *)values{
    
    //条件2
    
}

- (void) didYoujiwuPickerValue:(NSDictionary *)values{
    
    NSString *data = [values objectForKey:[NSNumber numberWithInt:0]];
    if ([@"温度" isEqualToString:data]) {
        _wenshipmL1.text = @"℃";
        _wenshipmL2.text = @"℃";
        
        _condi1Picker._pickerDataArray = @[@{@"values":_tempraturArray}];
        _condi2Picker._pickerDataArray = @[@{@"values":_tempraturArray}];
        
        [_condi1Picker selectRow:0 inComponent:0];
        [_condi2Picker selectRow:0 inComponent:0];
        
        _currentSensorType = 2;
        
    } else if ([@"湿度" isEqualToString:data]) {
        _wenshipmL1.text = @"%";
        _wenshipmL2.text = @"%";
        
        _condi1Picker._pickerDataArray = @[@{@"values":_shiduArray}];
        _condi2Picker._pickerDataArray = @[@{@"values":_shiduArray}];
        
        [_condi1Picker selectRow:0 inComponent:0];
        [_condi2Picker selectRow:0 inComponent:0];
        
        _currentSensorType = 3;
        
    } else {
        _wenshipmL1.text = @"μg/m³";
        _wenshipmL2.text = @"μg/m³";
        
        _condi1Picker._pickerDataArray = @[@{@"values":_pmArray}];
        _condi2Picker._pickerDataArray = @[@{@"values":_pmArray}];
        
        [_condi1Picker selectRow:0 inComponent:0];
        [_condi2Picker selectRow:0 inComponent:0];
        
        _currentSensorType = 1;
    }
    
}


- (void) saveSchedule:(id)sender
{
    int proxyId = 0;
    if(_currentSensorType > 0)
    {
        for(SensorProxy *sp in _sensorProxys)
        {
            if(sp._sensorType == _currentSensorType)
            {
                proxyId = sp._proxyId;
                break;
            }
        }
    }

        
    NSString *unit = @"";
    NSString *name = @"自动化";
    NSArray *datas = nil;
    if(_currentSensorType == 2)
    {
        name = @"温度传感器";
        datas = _tempraturArray;
        unit = @"℃";
    }
    else if(_currentSensorType == 3)
    {
         name = @"湿度传感器";
        datas = _shiduArray;
        unit = @"%";
    }
    else if(_currentSensorType == 1)
    {
         name = @"PM2.5传感器";
        datas = _pmArray;
        unit = @"μg/m³";
    }
    
    if(proxyId)
    {
        NSDictionary *cond1 = [_condi1Picker resultOfCurrentValue];
        NSDictionary *s1 = [_scnearioPicker1 resultOfCurrentValue];
        
        NSDictionary *cond2 = [_condi2Picker resultOfCurrentValue];
        NSDictionary *s2 = [_scnearioPicker2 resultOfCurrentValue];
        
        Scenario *scenario1 = nil;
        Scenario *scenario2 = nil;
        if([s1 objectForKey:@"row"])
        {
            int row = [[s1 objectForKey:@"row"] intValue];
            scenario1 = [_scenarios objectAtIndex:row];
        }
        if([s2 objectForKey:@"row"])
        {
            int row = [[s2 objectForKey:@"row"] intValue];
            scenario2 = [_scenarios objectAtIndex:row];
        }
        
        NSString *val1 = nil;
        NSString *val2 = nil;
        if([cond1 objectForKey:@"row"])
        {
            int row = [[cond1 objectForKey:@"row"] intValue];
            if(row < [datas count])
            {
                val1 = [datas objectAtIndex:row];
            }
        }
        if([cond2 objectForKey:@"row"])
        {
            int row = [[cond2 objectForKey:@"row"] intValue];
            if(row < [datas count])
            {
                val2 = [datas objectAtIndex:row];
            }
        }
        
        if(scenario1 && scenario2 && val1 && val2)
        {
            NSMutableArray *opts1 = [NSMutableArray array];
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scenario1._rgsSceneObj.m_id
                                                                              cmd:@"invoke"
                                                                            param:nil];
            [opts1 addObject:opt];
            
            RgsSceneOperation * if1 = [[RgsSceneOperation alloc] initCondWithParam:proxyId
                                                                              cond:RGS_COND_TYPE_GE
                                                                        param_name:@"value"
                                                                       param_value:val1
                                                                        operations:@[]];
            
            NSString *autoName = [NSString stringWithFormat:@"%@;高于 %@%@ 打开;%@",name,val1,unit,scenario1.name];
            
            _req_count = 0;
            
            IMP_BLOCK_SELF(ChuanGanAutoSetView);
            
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] CreateAutomation:autoName
                                                        img:@"noimage"
                                                     iftype:RGS_COND_IF_TYPE_OR
                                                     ifthis:@[if1]
                                                   thenthat:opts1 completion:^(BOOL result, RgsAutomationObj *auto_obj, NSError *error) {
                                                       
                                                       [block_self checkDone:result];
                                                       
                                                   }];
            
            
            NSMutableArray *opts2 = [NSMutableArray array];
            opt = [[RgsSceneOperation alloc] initCmdWithParam:scenario2._rgsSceneObj.m_id
                                                                              cmd:@"invoke"
                                                                            param:nil];
            [opts2 addObject:opt];
            
            RgsSceneOperation * if2 = [[RgsSceneOperation alloc] initCondWithParam:proxyId
                                                                              cond:RGS_COND_TYPE_LE param_name:@"value"
                                                                       param_value:val2
                                                                        operations:@[]];
            
            
            
            autoName = [NSString stringWithFormat:@"%@;低于 %@%@ 打开;%@",name,val2,unit,scenario2.name];
            
            [[RegulusSDK sharedRegulusSDK] CreateAutomation:autoName
                                                        img:@"noimage"
                                                     iftype:RGS_COND_IF_TYPE_OR
                                                     ifthis:@[if2]
                                                   thenthat:opts2 completion:^(BOOL result, RgsAutomationObj *auto_obj, NSError *error) {
                                                       
                                                       [block_self checkDone:result];
                                                       
                                                   }];
        }
        
    }
}

- (void) checkDone:(BOOL)result{
    
    _req_count++;
    
    if(_req_count>=2)
    {
        [KVNProgress dismiss];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Refresh_Items"
                                                            object:nil];
        
        [self hidden];
    }
    
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
    
    if([_sensor.connectionObjArray count] == 0)
        [_sensor getMyConnects];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         whiteView.frame = CGRectMake(0, self.frame.size.height - 390,
                                                      self.frame.size.width,
                                                      390);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}


- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
